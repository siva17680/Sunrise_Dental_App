package com.sunrise.chain;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public abstract class FilterHandler {
    protected FilterHandler nextHandler;

    public void setNext(FilterHandler nextHandler) {
        this.nextHandler = nextHandler;
    }

    public abstract boolean handle(HttpServletRequest request, HttpServletResponse response) throws Exception;

    protected boolean handleNext(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (nextHandler == null) {
            return true;
        }
        return nextHandler.handle(request, response);
    }
}
