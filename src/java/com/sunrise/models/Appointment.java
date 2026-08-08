package com.sunrise.models;

import java.sql.Date;
import java.sql.Time;

/**
 * Appointment model class.
 * Uses the Builder Design Pattern to simplify object creation.
 */
public class Appointment {
    private String appointmentNumber;
    private String patientName;
    private String address;
    private String contactNumber;
    private String dentistName;
    private String treatmentType;
    private Date appointmentDate;
    private Time appointmentTime;

    // Private constructor used by the Builder
    private Appointment(AppointmentBuilder builder) {
        this.appointmentNumber = builder.appointmentNumber;
        this.patientName = builder.patientName;
        this.address = builder.address;
        this.contactNumber = builder.contactNumber;
        this.dentistName = builder.dentistName;
        this.treatmentType = builder.treatmentType;
        this.appointmentDate = builder.appointmentDate;
        this.appointmentTime = builder.appointmentTime;
    }

    // Getters
    public String getAppointmentNumber() { return appointmentNumber; }
    public String getPatientName() { return patientName; }
    public String getAddress() { return address; }
    public String getContactNumber() { return contactNumber; }
    public String getDentistName() { return dentistName; }
    public String getTreatmentType() { return treatmentType; }
    public Date getAppointmentDate() { return appointmentDate; }
    public Time getAppointmentTime() { return appointmentTime; }

    /**
     * Builder Design Pattern implementation for Appointment.
     */
    public static class AppointmentBuilder {
        private String appointmentNumber;
        private String patientName;
        private String address;
        private String contactNumber;
        private String dentistName;
        private String treatmentType;
        private Date appointmentDate;
        private Time appointmentTime;

        public AppointmentBuilder(String appointmentNumber, String patientName) {
            this.appointmentNumber = appointmentNumber;
            this.patientName = patientName;
        }

        public AppointmentBuilder address(String address) {
            this.address = address;
            return this;
        }

        public AppointmentBuilder contactNumber(String contactNumber) {
            this.contactNumber = contactNumber;
            return this;
        }

        public AppointmentBuilder dentistName(String dentistName) {
            this.dentistName = dentistName;
            return this;
        }

        public AppointmentBuilder treatmentType(String treatmentType) {
            this.treatmentType = treatmentType;
            return this;
        }

        public AppointmentBuilder appointmentDate(Date appointmentDate) {
            this.appointmentDate = appointmentDate;
            return this;
        }

        public AppointmentBuilder appointmentTime(Time appointmentTime) {
            this.appointmentTime = appointmentTime;
            return this;
        }

        public Appointment build() {
            return new Appointment(this);
        }
    }
}
