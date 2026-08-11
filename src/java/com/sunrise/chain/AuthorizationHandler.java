package com.sunrise.chain;

import com.sunrise.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthorizationHandler extends FilterHandler {
    private String requiredRole;

    public AuthorizationHandler(String requiredRole) {
        this.requiredRole = requiredRole;
    }

    @Override
    public boolean handle(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equalsIgnoreCase(requiredRole)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Forbidden. You do not have permission to access this resource.\"}");
            return false;
        }
        return handleNext(request, response);
    }
}
