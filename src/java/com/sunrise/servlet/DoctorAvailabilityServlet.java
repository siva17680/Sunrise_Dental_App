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

@WebServlet("/api/secure/doctor/availability")
public class DoctorAvailabilityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        
        String date = request.getParameter("date");
        String startTime = request.getParameter("start_time");
        String endTime = request.getParameter("end_time");

        try (Connection conn = DatabaseConnectionManager.getInstance().getConnection()) {
            String sql = "INSERT INTO doctor_availability (doctor_id, available_date, start_time, end_time) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, user.getId());
            stmt.setString(2, date);
            stmt.setString(3, startTime);
            stmt.setString(4, endTime);
            stmt.executeUpdate();
            
            response.sendRedirect(request.getContextPath() + "/doctorDashboard?success=time_added");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/doctorDashboard?error=db_error");
        }
    }
}
