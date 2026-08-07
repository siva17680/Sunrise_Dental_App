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
import java.sql.SQLException;

@WebServlet("/api/secure/admin/services")
public class AdminServiceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String desc = request.getParameter("description");
        double cost = Double.parseDouble(request.getParameter("cost"));
        String cat = request.getParameter("category");

        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            String sql = "INSERT INTO services (name, description, cost, category) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, desc);
            stmt.setDouble(3, cost);
            stmt.setString(4, cat);
            stmt.executeUpdate();
            
            response.sendRedirect(request.getContextPath() + "/adminDashboard");
        } catch (SQLException e) {
            response.getWriter().write("Database error");
        }
    }
}
