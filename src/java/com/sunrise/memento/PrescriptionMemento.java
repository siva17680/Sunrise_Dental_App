package com.sunrise.memento;

public class PrescriptionMemento {
    private final String[] medicines;
    private final String[] dosages;
    private final String[] quantities;

    public PrescriptionMemento(String[] medicines, String[] dosages, String[] quantities) {
        this.medicines = medicines;
        this.dosages = dosages;
        this.quantities = quantities;
    }

    public String[] getMedicines() {
        return medicines;
    }

    public String[] getDosages() {
        return dosages;
    }

    public String[] getQuantities() {
        return quantities;
    }
}
