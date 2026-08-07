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

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> services = new ArrayList<>();
        
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            String sql = "SELECT * FROM services";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> svc = new HashMap<>();
                svc.put("id", rs.getInt("id"));
                svc.put("name", rs.getString("name"));
                svc.put("description", rs.getString("description"));
                svc.put("cost", rs.getDouble("cost"));
                svc.put("category", rs.getString("category"));
                services.add(svc);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error loading services");
        }
        
        request.setAttribute("services", services);
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }
}
