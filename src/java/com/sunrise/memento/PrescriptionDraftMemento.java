package com.sunrise.memento;

public class PrescriptionDraftMemento {
    private final String medicineName;
    private final String dosage;
    private final int quantity;

    public PrescriptionDraftMemento(String medicineName, String dosage, int quantity) {
        this.medicineName = medicineName;
        this.dosage = dosage;
        this.quantity = quantity;
    }

    public String getMedicineName() { return medicineName; }
    public String getDosage() { return dosage; }
    public int getQuantity() { return quantity; }
}
