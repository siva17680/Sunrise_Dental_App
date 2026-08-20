package com.sunrise.servlet;

import com.sunrise.factory.UserFactory;
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

@WebServlet("/api/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User newUser = UserFactory.createUser("PATIENT");
        newUser.setUsername(request.getParameter("username"));
        newUser.setPassword(request.getParameter("password"));
        newUser.setName(request.getParameter("name"));
        newUser.setContactNumber(request.getParameter("contactNumber"));

        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            // Insert User
            String sql = "INSERT INTO users (username, password, role, name, contact_number) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, newUser.getUsername());
            stmt.setString(2, newUser.getPassword());
            stmt.setString(3, newUser.getRole());
            stmt.setString(4, newUser.getName());
            stmt.setString(5, newUser.getContactNumber());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    int userId = keys.getInt(1);
                    // Insert Patient record
                    String address = request.getParameter("address");
                    String ageStr = request.getParameter("age");
                    int age = (ageStr != null && !ageStr.isEmpty()) ? Integer.parseInt(ageStr) : 0;
                    
                    String patSql = "INSERT INTO patients (patient_id, address, age) VALUES (?, ?, ?)";
                    PreparedStatement patStmt = conn.prepareStatement(patSql);
                    patStmt.setInt(1, userId);
                    patStmt.setString(2, address);
                    patStmt.setInt(3, age);
                    patStmt.executeUpdate();
                    
                    request.setAttribute("success", "Registration successful. Please log in.");
                    request.getRequestDispatcher("/index.jsp").forward(request, response);
                    return;
                }
            }
            request.setAttribute("error", "Registration failed.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Database error: User may already exist.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
