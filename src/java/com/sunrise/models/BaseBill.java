package com.sunrise.models;

/**
 * Concrete component for Base Bill.
 */
public class BaseBill implements BillComponent {
    private Treatment treatment;
    private double consultationFee = 2000.0; // Fixed consultation fee

    public BaseBill(Treatment treatment) {
        this.treatment = treatment;
    }

    @Override
    public String getDescription() {
        return "Consultation + " + treatment.getTreatmentName();
    }

    @Override
    public double getCost() {
        return consultationFee + treatment.getCost();
    }
}
