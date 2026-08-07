package com.sunrise.servlet;

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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/adminAppointments")
public class AdminAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.sunrise.model.User user = (com.sunrise.model.User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Map<String, Object>> appointments = new ArrayList<>();
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            String sql = "SELECT a.id, a.appointment_date, a.appointment_time, a.status, " +
                         "p.name as patient_name, d.name as doctor_name " +
                         "FROM appointments a " +
                         "JOIN users p ON a.patient_id = p.id " +
                         "JOIN users d ON a.doctor_id = d.id " +
                         "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> appt = new HashMap<>();
                appt.put("id", rs.getInt("id"));
                appt.put("date", rs.getDate("appointment_date"));
                appt.put("time", rs.getTime("appointment_time"));
                appt.put("status", rs.getString("status"));
                appt.put("patient", rs.getString("patient_name"));
                appt.put("doctor", rs.getString("doctor_name"));
                appointments.add(appt);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Database error loading appointments");
        }
        
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/admin_appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        if (idStr != null && action != null) {
            int id = Integer.parseInt(idStr);
            String newStatus = action.equals("approve") ? "APPROVED" : "REJECTED";
            
            try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
                String sql = "UPDATE appointments SET status = ? WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, newStatus);
                stmt.setInt(2, id);
                stmt.executeUpdate();

                // If approved, automatically generate the invoice
                if ("APPROVED".equals(newStatus)) {
                    // Check if an invoice already exists (to prevent duplicates if re-approved)
                    boolean invoiceExists = false;
                    String checkSql = "SELECT invoice_id FROM invoices WHERE appointment_id = ?";
                    PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                    checkStmt.setInt(1, id);
                    ResultSet checkRs = checkStmt.executeQuery();
                    if (checkRs.next()) {
                        invoiceExists = true;
                    }

                    if (!invoiceExists) {
                        // 1. Get patient and doctor ID
                        int patientId = 0;
                        int doctorId = 0;
                        String getApptSql = "SELECT patient_id, doctor_id FROM appointments WHERE id = ?";
                        PreparedStatement getApptStmt = conn.prepareStatement(getApptSql);
                        getApptStmt.setInt(1, id);
                        ResultSet apptRs = getApptStmt.executeQuery();
                        if (apptRs.next()) {
                            patientId = apptRs.getInt("patient_id");
                            doctorId = apptRs.getInt("doctor_id");
                        }

                        // 2. Calculate base total using Decorator Pattern
                        com.sunrise.decorator.InvoiceCost invoiceTotal = new com.sunrise.decorator.BaseInvoice();
                        String svcsSql = "SELECT s.name, s.cost FROM appointment_services as_s JOIN services s ON as_s.service_id = s.id WHERE as_s.appointment_id = ?";
                        PreparedStatement svcsStmt = conn.prepareStatement(svcsSql);
                        svcsStmt.setInt(1, id);
                        ResultSet svcsRs = svcsStmt.executeQuery();
                        while (svcsRs.next()) {
                            invoiceTotal = new com.sunrise.decorator.ServiceDecorator(invoiceTotal, svcsRs.getDouble("cost"), svcsRs.getString("name"));
                        }
                        double baseAmount = invoiceTotal.getCost();

                        // 3. Insert Invoice
                        String insertInvSql = "INSERT INTO invoices (patient_id, appointment_id, doctor_id, total_amount, status) VALUES (?, ?, ?, ?, 'UNPAID')";
                        PreparedStatement insertInvStmt = conn.prepareStatement(insertInvSql);
                        insertInvStmt.setInt(1, patientId);
                        insertInvStmt.setInt(2, id);
                        insertInvStmt.setInt(3, doctorId);
                        insertInvStmt.setDouble(4, baseAmount);
                        insertInvStmt.executeUpdate();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/adminAppointments");
    }
}
