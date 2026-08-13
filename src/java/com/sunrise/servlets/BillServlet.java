package com.sunrise.servlets;

import com.sunrise.facade.ClinicFacade;
import com.sunrise.models.*;
import com.sunrise.validation.AuthHandler;
import com.sunrise.validation.Handler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Base64;
// Note: QR code generation requires ZXing library
import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import java.io.ByteArrayOutputStream;

@WebServlet(name = "BillServlet", urlPatterns = {"/BillServlet"})
public class BillServlet extends HttpServlet {

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
            // Using Factory Pattern
            Treatment treatment = TreatmentFactory.getTreatment(appt.getTreatmentType());
            if (treatment == null) {
                 // Fallback if treatment type is missing or simple
                 treatment = new CleaningTreatment(); 
            }

            // Using Decorator Pattern
            BillComponent baseBill = new BaseBill(treatment);
            BillComponent finalBill = new TaxDecorator(baseBill);

            request.setAttribute("appointment", appt);
            request.setAttribute("billDescription", finalBill.getDescription());
            request.setAttribute("billTotal", finalBill.getCost());
            
            // Generate QR Code
            try {
                String qrText = "Bill for: " + appt.getPatientName() + "\nTotal: LKR " + finalBill.getCost();
                QRCodeWriter qrCodeWriter = new QRCodeWriter();
                BitMatrix bitMatrix = qrCodeWriter.encode(qrText, BarcodeFormat.QR_CODE, 200, 200);
                
                ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
                MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);
                byte[] pngData = pngOutputStream.toByteArray();
                String qrBase64 = Base64.getEncoder().encodeToString(pngData);
                
                request.setAttribute("qrCodeImage", "data:image/png;base64," + qrBase64);
            } catch (Exception e) {
                e.printStackTrace();
            }

            request.getRequestDispatcher("bill.jsp").forward(request, response);
        } else {
            response.sendRedirect("dashboard.jsp?error=Appointment not found for billing");
        }
    }
}
