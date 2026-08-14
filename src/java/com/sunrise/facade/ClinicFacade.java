package com.sunrise.facade;

import com.sunrise.models.Appointment;
import com.sunrise.utils.DBConnection;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Facade Design Pattern implementation.
 * Hides the complexity of database operations from the Servlets.
 */
public class ClinicFacade {
    
    public boolean authenticate(String username, String password) {
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, password);
            ResultSet rs = pst.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(ClinicFacade.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    
    public boolean registerAppointment(Appointment appointment) {
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "INSERT INTO appointments (appointment_number, patient_name, address, contact_number, dentist_name, treatment_type, appointment_date, appointment_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, appointment.getAppointmentNumber());
            pst.setString(2, appointment.getPatientName());
            pst.setString(3, appointment.getAddress());
            pst.setString(4, appointment.getContactNumber());
            pst.setString(5, appointment.getDentistName());
            pst.setString(6, appointment.getTreatmentType());
            pst.setDate(7, appointment.getAppointmentDate());
            pst.setTime(8, appointment.getAppointmentTime());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ClinicFacade.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    
    public Appointment getAppointment(String appointmentNumber) {
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            String sql = "SELECT * FROM appointments WHERE appointment_number = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, appointmentNumber);
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                return new Appointment.AppointmentBuilder(rs.getString("appointment_number"), rs.getString("patient_name"))
                        .address(rs.getString("address"))
                        .contactNumber(rs.getString("contact_number"))
                        .dentistName(rs.getString("dentist_name"))
                        .treatmentType(rs.getString("treatment_type"))
                        .appointmentDate(rs.getDate("appointment_date"))
                        .appointmentTime(rs.getTime("appointment_time"))
                        .build();
            }
        } catch (SQLException ex) {
            Logger.getLogger(ClinicFacade.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
