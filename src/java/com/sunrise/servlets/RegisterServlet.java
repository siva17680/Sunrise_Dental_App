package com.sunrise.servlets;

import com.sunrise.facade.ClinicFacade;
import com.sunrise.models.Appointment;
import com.sunrise.validation.AuthHandler;
import com.sunrise.validation.DataHandler;
import com.sunrise.validation.Handler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private ClinicFacade facade = new ClinicFacade();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Chain of Responsibility for validation
        Handler authHandler = new AuthHandler();
        Handler dataHandler = new DataHandler();
        authHandler.setNext(dataHandler);
        
        if (!authHandler.handle(request)) {
            response.sendRedirect("index.jsp?error=Unauthorized or Invalid Data");
            return;
        }

        try {
            // Using Builder pattern
            Appointment appt = new Appointment.AppointmentBuilder(
                    request.getParameter("appointmentNumber"),
                    request.getParameter("patientName"))
                    .address(request.getParameter("address"))
                    .contactNumber(request.getParameter("contactNumber"))
                    .dentistName(request.getParameter("dentistName"))
                    .treatmentType(request.getParameter("treatmentType"))
                    .appointmentDate(Date.valueOf(request.getParameter("appointmentDate")))
                    .appointmentTime(Time.valueOf(request.getParameter("appointmentTime") + ":00"))
                    .build();
            
            if (facade.registerAppointment(appt)) {
                response.sendRedirect("dashboard.jsp?msg=Appointment Registered Successfully");
            } else {
                response.sendRedirect("register.jsp?error=Failed to register");
            }
        } catch (Exception e) {
            response.sendRedirect("register.jsp?error=Invalid input format");
        }
    }
}
