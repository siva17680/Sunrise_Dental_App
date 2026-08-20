package com.sunrise.models;

/**
 * Factory Design Pattern implementation for creating Treatment objects.
 */
public class TreatmentFactory {
    public static Treatment getTreatment(String type) {
        if (type == null) {
            return null;
        }
        if (type.equalsIgnoreCase("CLEANING")) {
            return new CleaningTreatment();
        } else if (type.equalsIgnoreCase("FILLING")) {
            return new FillingTreatment();
        }
        return null;
    }
}
