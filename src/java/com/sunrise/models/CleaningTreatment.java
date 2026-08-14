package com.sunrise.models;

/**
 * Concrete implementation for Cleaning treatment.
 */
public class CleaningTreatment implements Treatment {
    @Override
    public String getTreatmentName() {
        return "Teeth Cleaning";
    }

    @Override
    public double getCost() {
        return 5000.0;
    }
}
