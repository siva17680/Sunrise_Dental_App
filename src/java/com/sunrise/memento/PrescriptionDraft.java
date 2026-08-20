package com.sunrise.memento;

public class PrescriptionDraft {
    private String medicineName;
    private String dosage;
    private int quantity;

    public void setDraft(String medicineName, String dosage, int quantity) {
        this.medicineName = medicineName;
        this.dosage = dosage;
        this.quantity = quantity;
    }

    public PrescriptionDraftMemento saveToMemento() {
        return new PrescriptionDraftMemento(medicineName, dosage, quantity);
    }

    public void restoreFromMemento(PrescriptionDraftMemento memento) {
        this.medicineName = memento.getMedicineName();
        this.dosage = memento.getDosage();
        this.quantity = memento.getQuantity();
    }

    public String getMedicineName() { return medicineName; }
    public String getDosage() { return dosage; }
    public int getQuantity() { return quantity; }
}
