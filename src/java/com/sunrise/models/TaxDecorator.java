package com.sunrise.models;

/**
 * Concrete decorator to add Tax to the bill.
 */
public class TaxDecorator extends BillDecorator {
    public TaxDecorator(BillComponent decoratedBill) {
        super(decoratedBill);
    }

    @Override
    public String getDescription() {
        return super.getDescription() + " (Includes 10% Tax)";
    }

    @Override
    public double getCost() {
        return super.getCost() * 1.10; // 10% tax
    }
}
