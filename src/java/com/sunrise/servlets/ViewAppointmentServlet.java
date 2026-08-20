package com.sunrise.servlets;

import com.sunrise.facade.ClinicFacade;
import com.sunrise.models.Appointment;
import com.sunrise.validation.AuthHandler;
import com.sunrise.validation.Handler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ViewAppointmentServlet", urlPatterns = {"/ViewAppointmentServlet"})
public class ViewAppointmentServlet extends HttpServlet {

    private ClinicFacade facade = new ClinicFacade();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Handler authHandler = new AuthHandler();
        if (!authHandler.handle(request)) {
            response.sendRedirect("index.jsp?error=Unauthorized");
            return;
        }

        String apptNo = request.getParameter("appointmentNumber");
        Appointment appt = facade.getAppointment(apptNo);
        
        if (appt != null) {
            request.setAttribute("appointment", appt);
            request.getRequestDispatcher("view.jsp").forward(request, response);
        } else {
            response.sendRedirect("view.jsp?error=Appointment not found");
        }
    }
}
