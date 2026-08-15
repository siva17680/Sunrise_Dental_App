package com.sunrise.validation;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Data Validation Handler for Chain of Responsibility.
 */
public class DataHandler extends Handler {
    @Override
    public boolean handle(Object request) {
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            String apptNo = httpRequest.getParameter("appointmentNumber");
            String name = httpRequest.getParameter("patientName");
            
            if (apptNo != null && !apptNo.trim().isEmpty() && name != null && !name.trim().isEmpty()) {
                if (nextHandler != null) {
                    return nextHandler.handle(request);
                }
                return true;
            }
        }
        return false;
    }
}
