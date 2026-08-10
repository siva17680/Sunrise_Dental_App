package com.sunrise.validation;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Authentication Handler for Chain of Responsibility.
 */
public class AuthHandler extends Handler {
    @Override
    public boolean handle(Object request) {
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpSession session = httpRequest.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                if (nextHandler != null) {
                    return nextHandler.handle(request);
                }
                return true;
            }
        }
        return false;
    }
}
