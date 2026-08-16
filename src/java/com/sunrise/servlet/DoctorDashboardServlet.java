package com.sunrise.servlet;

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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/doctorDashboard")
public class DoctorDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Map<String, Object>> records = new ArrayList<>();
        
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            // Get approved appointments AND open guest invoices for this doctor
            // We use UNION to combine them into a single list
            String sql = "SELECT a.id as appt_id, NULL as invoice_id, a.appointment_date as record_date, a.appointment_time as record_time, " +
                         "u.name as patient_name, p.medical_history, a.patient_id, 'REGISTERED' as type " +
                         "FROM appointments a " +
                         "JOIN users u ON a.patient_id = u.id " +
                         "JOIN patients p ON a.patient_id = p.patient_id " +
                         "WHERE a.doctor_id = ? AND a.status = 'APPROVED' " +
                         "UNION ALL " +
                         "SELECT NULL as appt_id, i.invoice_id, DATE(i.issue_date) as record_date, TIME(i.issue_date) as record_time, " +
                         "i.guest_name as patient_name, 'Guest Walk-in' as medical_history, NULL as patient_id, 'GUEST' as type " +
                         "FROM invoices i " +
                         "WHERE i.doctor_id = ? AND i.patient_id IS NULL AND i.appointment_id IS NULL";
                         
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, user.getId());
            stmt.setInt(2, user.getId());
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> rec = new HashMap<>();
                rec.put("appt_id", rs.getObject("appt_id"));
                rec.put("invoice_id", rs.getObject("invoice_id"));
                rec.put("patient_id", rs.getObject("patient_id"));
                rec.put("patient_name", rs.getString("patient_name"));
                rec.put("date", rs.getDate("record_date"));
                rec.put("time", rs.getTime("record_time"));
                rec.put("history", rs.getString("medical_history"));
                rec.put("type", rs.getString("type"));
                records.add(rec);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading data");
        }

        request.setAttribute("appointments", records);
        request.getRequestDispatcher("/doctor.jsp").forward(request, response);
    }
}
