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

@WebServlet("/pharmacistDashboard")
public class PharmacistDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"PHARMACIST".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Map<String, Object>> prescriptions = new ArrayList<>();
        
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            String sql = "SELECT p.id, p.date_issued, i.invoice_id, COALESCE(u.name, i.guest_name, 'Guest') as patient_name, u2.name as doctor_name " +
                         "FROM prescriptions p " +
                         "JOIN invoices i ON p.invoice_id = i.invoice_id " +
                         "LEFT JOIN users u ON p.patient_id = u.id " +
                         "JOIN users u2 ON p.doctor_id = u2.id " +
                         "ORDER BY p.date_issued DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> pres = new HashMap<>();
                pres.put("id", rs.getInt("id"));
                pres.put("invoice_id", rs.getInt("invoice_id"));
                pres.put("patient", rs.getString("patient_name"));
                pres.put("doctor", rs.getString("doctor_name"));
                pres.put("date", rs.getTimestamp("date_issued"));
                prescriptions.add(pres);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error loading data");
        }

        request.setAttribute("prescriptions", prescriptions);
        request.getRequestDispatcher("/pharmacist.jsp").forward(request, response);
    }
}
