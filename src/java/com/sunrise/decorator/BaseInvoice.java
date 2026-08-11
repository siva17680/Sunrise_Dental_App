package com.sunrise.decorator;

public class BaseInvoice implements InvoiceCost {
    @Override
    public double getCost() {
        return 0.0; // Base cost is 0, services add to it.
    }

    @Override
    public String getDescription() {
        return "Invoice";
    }
}
