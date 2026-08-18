package com.sunrise.model;

import java.sql.Timestamp;

public class InvoiceBuilder {
    int invoiceId;
    int patientId;
    Integer appointmentId;
    double totalAmount;
    String status = "UNPAID"; // Default
    Timestamp issueDate;

    public InvoiceBuilder(int patientId) {
        this.patientId = patientId;
    }

    public InvoiceBuilder setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
        return this;
    }

    public InvoiceBuilder setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
        return this;
    }

    public InvoiceBuilder setStatus(String status) {
        this.status = status;
        return this;
    }

    public InvoiceBuilder setIssueDate(Timestamp issueDate) {
        this.issueDate = issueDate;
        return this;
    }

    public Invoice build() {
        return new Invoice(this);
    }
}
