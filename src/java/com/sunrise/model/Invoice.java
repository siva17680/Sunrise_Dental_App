package com.sunrise.model;

import java.sql.Timestamp;

public class Invoice {
    private int invoiceId;
    private int patientId;
    private Integer appointmentId;
    private double totalAmount;
    private String status;
    private Timestamp issueDate;

    // Package-private constructor, only accessible via Builder
    Invoice(InvoiceBuilder builder) {
        this.invoiceId = builder.invoiceId;
        this.patientId = builder.patientId;
        this.appointmentId = builder.appointmentId;
        this.totalAmount = builder.totalAmount;
        this.status = builder.status;
        this.issueDate = builder.issueDate;
    }

    // Getters
    public int getInvoiceId() { return invoiceId; }
    public int getPatientId() { return patientId; }
    public Integer getAppointmentId() { return appointmentId; }
    public double getTotalAmount() { return totalAmount; }
    public String getStatus() { return status; }
    public Timestamp getIssueDate() { return issueDate; }
    
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }
}
