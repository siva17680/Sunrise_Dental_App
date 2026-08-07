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

@WebServlet("/adminDoctors")
public class AdminDoctorsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        com.sunrise.model.User user = (com.sunrise.model.User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Map<String, Object>> schedules = new ArrayList<>();
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            String sql = "SELECT a.id, a.available_date, a.start_time, a.end_time, " +
                         "d.name as doctor_name, doc.specialization " +
                         "FROM doctor_availability a " +
                         "JOIN users d ON a.doctor_id = d.id " +
                         "JOIN doctors doc ON d.id = doc.doctor_id " +
                         "ORDER BY a.available_date DESC, a.start_time ASC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> schedule = new HashMap<>();
                schedule.put("id", rs.getInt("id"));
                schedule.put("date", rs.getDate("available_date"));
                schedule.put("start", rs.getTime("start_time"));
                schedule.put("end", rs.getTime("end_time"));
                schedule.put("doctor", rs.getString("doctor_name"));
                schedule.put("specialization", rs.getString("specialization"));
                schedules.add(schedule);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Database error loading schedules");
        }
        
        request.setAttribute("schedules", schedules);
        request.getRequestDispatcher("/admin_doctors.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String specialization = request.getParameter("specialization");
        
        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Insert into users
                String insertUser = "INSERT INTO users (name, username, password, role) VALUES (?, ?, ?, 'DOCTOR')";
                PreparedStatement stmtUser = conn.prepareStatement(insertUser, PreparedStatement.RETURN_GENERATED_KEYS);
                stmtUser.setString(1, name);
                stmtUser.setString(2, username);
                stmtUser.setString(3, password);
                stmtUser.executeUpdate();
                
                ResultSet rs = stmtUser.getGeneratedKeys();
                if (rs.next()) {
                    int docId = rs.getInt(1);
                    // Insert into doctors table
                    String insertDoc = "INSERT INTO doctors (doctor_id, specialization) VALUES (?, ?)";
                    PreparedStatement stmtDoc = conn.prepareStatement(insertDoc);
                    stmtDoc.setInt(1, docId);
                    stmtDoc.setString(2, specialization);
                    stmtDoc.executeUpdate();
                }
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/adminDoctors");
    }
}
