package com.sunrise.models;

/**
 * Concrete implementation for Filling treatment.
 */
public class FillingTreatment implements Treatment {
    @Override
    public String getTreatmentName() {
        return "Cavity Filling";
    }

    @Override
    public double getCost() {
        return 8000.0;
    }
}
