package com.sunrise.servlet;

import com.sunrise.model.User;
import com.sunrise.util.DatabaseConnectionManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/api/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = com.sunrise.model.UserFactory.createUser(
                    rs.getInt("id"), rs.getString("username"),
                    rs.getString("role"), rs.getString("name"), rs.getString("contact_number")
                );
                
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);

                // Redirect based on role
                String role = user.getRole();
                if (role.equals("ADMIN")) response.sendRedirect(request.getContextPath() + "/adminDashboard");
                else if (role.equals("DOCTOR")) response.sendRedirect(request.getContextPath() + "/doctorDashboard");
                else if (role.equals("PATIENT")) response.sendRedirect(request.getContextPath() + "/patientDashboard");
                else if (role.equals("PHARMACIST")) response.sendRedirect(request.getContextPath() + "/pharmacistDashboard");

            } else {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
