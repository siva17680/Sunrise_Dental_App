package com.sunrise.decorator;

public class ServiceDecorator implements InvoiceCost {
    protected InvoiceCost tempInvoice;
    private double cost;
    private String description;

    public ServiceDecorator(InvoiceCost newInvoice, double cost, String description) {
        this.tempInvoice = newInvoice;
        this.cost = cost;
        this.description = description;
    }

    @Override
    public double getCost() {
        return tempInvoice.getCost() + this.cost;
    }

    @Override
    public String getDescription() {
        return tempInvoice.getDescription() + ", " + this.description;
    }
}
