package com.sunrise.models;

/**
 * Decorator abstract class.
 */
public abstract class BillDecorator implements BillComponent {
    protected BillComponent decoratedBill;

    public BillDecorator(BillComponent decoratedBill) {
        this.decoratedBill = decoratedBill;
    }

    @Override
    public String getDescription() {
        return decoratedBill.getDescription();
    }

    @Override
    public double getCost() {
        return decoratedBill.getCost();
    }
}
