package com.sunrise.decorator;

public class ServiceAddOnDecorator implements DentalService {
    protected DentalService decoratedService;
    private String addOnName;
    private double addOnCost;

    public ServiceAddOnDecorator(DentalService decoratedService, String addOnName, double addOnCost) {
        this.decoratedService = decoratedService;
        this.addOnName = addOnName;
        this.addOnCost = addOnCost;
    }

    @Override
    public double getCost() {
        return decoratedService.getCost() + addOnCost;
    }

    @Override
    public String getDescription() {
        return decoratedService.getDescription() + " + " + addOnName;
    }
}
