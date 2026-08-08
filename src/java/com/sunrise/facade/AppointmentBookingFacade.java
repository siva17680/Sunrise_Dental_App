package com.sunrise.facade;

import com.sunrise.util.DatabaseConnectionManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Facade pattern to simplify appointment booking.
 */
public class AppointmentBookingFacade {

    public static boolean bookAppointment(int patientId, int doctorId, String date, String time) {
        // Complex logic hidden behind facade:
        // 1. Check if doctor is available on this date/time.
        // 2. Validate patient data.
        // 3. Insert into appointments table.
        
        Connection conn = DatabaseConnectionManager.getInstance().getConnection();
        
        try {
            // Step 1: Check Availability (simplified for facade demonstration)
            String checkSql = "SELECT * FROM doctor_availability WHERE doctor_id = ? AND available_date = ? AND start_time <= ? AND end_time >= ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, doctorId);
                checkStmt.setString(2, date);
                checkStmt.setString(3, time);
                checkStmt.setString(4, time);
                ResultSet rs = checkStmt.executeQuery();
                if (!rs.next()) {
                    return false; // Doctor not available
                }
            }

            // Step 2: Book Appointment
            String insertSql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status) VALUES (?, ?, ?, ?, 'PENDING')";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setInt(1, patientId);
                insertStmt.setInt(2, doctorId);
                insertStmt.setString(3, date);
                insertStmt.setString(4, time);
                int rows = insertStmt.executeUpdate();
                return rows > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
