package com.sunrise.servlet;

import com.sunrise.chain.AuthenticationHandler;
import com.sunrise.chain.AuthorizationHandler;
import com.sunrise.chain.FilterHandler;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/api/secure/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Base Auth check
        FilterHandler authHandler = new AuthenticationHandler();
        
        // Very basic routing based on URL path for demonstration
        String path = req.getRequestURI();
        if (path.contains("/admin/")) {
            authHandler.setNext(new AuthorizationHandler("ADMIN"));
        } else if (path.contains("/doctor/")) {
            authHandler.setNext(new AuthorizationHandler("DOCTOR"));
        } else if (path.contains("/patient/")) {
            authHandler.setNext(new AuthorizationHandler("PATIENT"));
        } else if (path.contains("/pharmacist/")) {
            authHandler.setNext(new AuthorizationHandler("PHARMACIST"));
        }

        try {
            if (authHandler.handle(req, res)) {
                chain.doFilter(request, response);
            }
        } catch (Exception e) {
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write("{\"error\": \"Server error during authentication\"}");
        }
    }
}
