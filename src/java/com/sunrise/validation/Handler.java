package com.sunrise.validation;

/**
 * Handler interface for Chain of Responsibility Design Pattern.
 */
public abstract class Handler {
    protected Handler nextHandler;

    public void setNext(Handler nextHandler) {
        this.nextHandler = nextHandler;
    }

    public abstract boolean handle(Object request);
}
