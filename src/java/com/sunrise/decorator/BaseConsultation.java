package com.sunrise.decorator;

public class BaseConsultation implements DentalService {
    private double baseCost;

    public BaseConsultation(double baseCost) {
        this.baseCost = baseCost;
    }

    @Override
    public double getCost() {
        return baseCost;
    }

    @Override
    public String getDescription() {
        return "General Consultation";
    }
}
