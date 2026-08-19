package com.sunrise.servlet;

import com.sunrise.facade.AppointmentBookingFacade;
import com.sunrise.model.User;
import com.sunrise.util.DatabaseConnectionManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/api/secure/patient/book")
public class PatientBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String availabilityIdStr = request.getParameter("availability_id");
        String[] serviceIds = request.getParameterValues("services");

        if (availabilityIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/patientDashboard?error=missing_info");
            return;
        }

        int availId = Integer.parseInt(availabilityIdStr);

        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            // Get doc info from availability id
            String getDocSql = "SELECT doctor_id, available_date, start_time FROM doctor_availability WHERE id = ?";
            PreparedStatement getDocStmt = conn.prepareStatement(getDocSql);
            getDocStmt.setInt(1, availId);
            ResultSet docRs = getDocStmt.executeQuery();
            
            if (docRs.next()) {
                int doctorId = docRs.getInt("doctor_id");
                String date = docRs.getString("available_date");
                String time = docRs.getString("start_time");

                // 1. Chain of Responsibility for Validation
                com.sunrise.chain.BookingValidator validationChain = new com.sunrise.chain.PatientCheck();
                validationChain.linkWith(new com.sunrise.chain.TimeSlotCheck());
                
                boolean isValid = false;
                try {
                    isValid = validationChain.check(user.getId(), date, time);
                } catch (Exception ex) {
                    System.out.println("Validation failed: " + ex.getMessage());
                }

                // 2. Facade pattern
                boolean success = false;
                if (isValid) {
                    success = AppointmentBookingFacade.bookAppointment(user.getId(), doctorId, date, time);
                }
                
                if (success && serviceIds != null && serviceIds.length > 0) {
                    // Need to get the newly created appointment ID to link services
                    String getApptSql = "SELECT id FROM appointments WHERE patient_id = ? AND doctor_id = ? AND appointment_date = ? AND appointment_time = ? ORDER BY id DESC LIMIT 1";
                    PreparedStatement apptStmt = conn.prepareStatement(getApptSql);
                    apptStmt.setInt(1, user.getId());
                    apptStmt.setInt(2, doctorId);
                    apptStmt.setString(3, date);
                    apptStmt.setString(4, time);
                    ResultSet apptRs = apptStmt.executeQuery();
                    
                    if (apptRs.next()) {
                        int appointmentId = apptRs.getInt("id");
                        // Insert requested add-ons
                        String insertSvcSql = "INSERT INTO appointment_services (appointment_id, service_id) VALUES (?, ?)";
                        PreparedStatement insertSvcStmt = conn.prepareStatement(insertSvcSql);
                        for (String svcId : serviceIds) {
                            insertSvcStmt.setInt(1, appointmentId);
                            insertSvcStmt.setInt(2, Integer.parseInt(svcId));
                            insertSvcStmt.addBatch();
                        }
                        insertSvcStmt.executeBatch();
                    }
                }
                
                response.sendRedirect(request.getContextPath() + "/patientDashboard?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/patientDashboard?error=invalid_availability");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patientDashboard?error=db_error");
        }
    }
}
