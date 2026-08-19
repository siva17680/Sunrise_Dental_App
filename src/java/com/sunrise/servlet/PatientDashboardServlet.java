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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/patientDashboard")
public class PatientDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.sunrise.model.User user = (com.sunrise.model.User) request.getSession().getAttribute("user");
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Map<String, Object>> doctors = new ArrayList<>();
        List<Map<String, Object>> services = new ArrayList<>();
        
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            // Load available doctors
            String docSql = "SELECT u.name, d.specialization, a.id as avail_id, a.available_date, a.start_time, a.end_time " +
                            "FROM users u JOIN doctors d ON u.id = d.doctor_id " +
                            "JOIN doctor_availability a ON d.doctor_id = a.doctor_id " +
                            "WHERE a.available_date >= CURDATE()";
            PreparedStatement docStmt = conn.prepareStatement(docSql);
            ResultSet docRs = docStmt.executeQuery();
            while (docRs.next()) {
                Map<String, Object> d = new HashMap<>();
                d.put("name", docRs.getString("name"));
                d.put("specialization", docRs.getString("specialization"));
                d.put("avail_id", docRs.getInt("avail_id"));
                d.put("date", docRs.getDate("available_date"));
                d.put("start", docRs.getTime("start_time"));
                d.put("end", docRs.getTime("end_time"));
                doctors.add(d);
            }

            // Load services for patient to select
            String svcSql = "SELECT * FROM services";
            PreparedStatement svcStmt = conn.prepareStatement(svcSql);
            ResultSet svcRs = svcStmt.executeQuery();
            while (svcRs.next()) {
                Map<String, Object> s = new HashMap<>();
                s.put("id", svcRs.getInt("id"));
                s.put("name", svcRs.getString("name"));
                s.put("cost", svcRs.getDouble("cost"));
                s.put("category", svcRs.getString("category"));
                services.add(s);
            }
            
            // Load patient appointments
            List<Map<String, Object>> appointments = new ArrayList<>();
            String apptSql = "SELECT a.id, a.appointment_date, a.appointment_time, a.status, d.name as doctor_name " +
                             "FROM appointments a " +
                             "JOIN users d ON a.doctor_id = d.id " +
                             "WHERE a.patient_id = ? " +
                             "ORDER BY a.appointment_date DESC";
            PreparedStatement apptStmt = conn.prepareStatement(apptSql);
            apptStmt.setInt(1, user.getId());
            ResultSet apptRs = apptStmt.executeQuery();
            while (apptRs.next()) {
                Map<String, Object> a = new HashMap<>();
                a.put("id", apptRs.getInt("id"));
                a.put("date", apptRs.getDate("appointment_date"));
                a.put("time", apptRs.getTime("appointment_time"));
                a.put("status", apptRs.getString("status"));
                a.put("doctor", apptRs.getString("doctor_name"));
                appointments.add(a);
            }
            request.setAttribute("appointments", appointments);

            // Load patient invoices
            List<Map<String, Object>> invoices = new ArrayList<>();
            String invSql = "SELECT i.invoice_id, i.total_amount, i.status, i.issue_date, d.name as doctor_name " +
                            "FROM invoices i " +
                            "LEFT JOIN users d ON i.doctor_id = d.id " +
                            "WHERE i.patient_id = ? " +
                            "ORDER BY i.issue_date DESC";
            PreparedStatement invStmt = conn.prepareStatement(invSql);
            invStmt.setInt(1, user.getId());
            ResultSet invRs = invStmt.executeQuery();
            while (invRs.next()) {
                Map<String, Object> inv = new HashMap<>();
                inv.put("id", invRs.getInt("invoice_id"));
                inv.put("amount", invRs.getDouble("total_amount"));
                inv.put("status", invRs.getString("status"));
                inv.put("date", invRs.getTimestamp("issue_date"));
                
                String dName = invRs.getString("doctor_name");
                inv.put("doctor", dName != null ? dName : "Unassigned");
                invoices.add(inv);
            }
            request.setAttribute("invoices", invoices);

        } catch (SQLException e) {
            request.setAttribute("error", "Error loading data");
        }
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("services", services);
        request.getRequestDispatcher("/patient.jsp").forward(request, response);
    }
}
