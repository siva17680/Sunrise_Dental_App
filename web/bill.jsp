<%@page import="com.sunrise.models.Appointment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("index.jsp?error=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill / Receipt</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .receipt { max-width: 500px; margin: 0 auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-top: 5px solid #2c3e50; }
        h1 { text-align: center; color: #2c3e50; margin-bottom: 5px; }
        .subtitle { text-align: center; color: #7f8c8d; margin-top: 0; margin-bottom: 30px; font-size: 14px; }
        .row { display: flex; justify-content: space-between; margin-bottom: 10px; border-bottom: 1px dotted #ccc; padding-bottom: 5px; }
        .total { font-size: 20px; font-weight: bold; border-top: 2px solid #2c3e50; padding-top: 10px; margin-top: 20px; border-bottom: none; }
        .qr-section { text-align: center; margin-top: 30px; }
        .qr-section img { border: 1px solid #eee; padding: 10px; border-radius: 4px; }
        .print-btn { display: block; width: 100%; background: #2c3e50; color: white; border: none; padding: 15px; margin-top: 20px; font-size: 16px; cursor: pointer; border-radius: 4px; }
        @media print {
            .print-btn, .back-link { display: none; }
            body { background: white; }
            .receipt { box-shadow: none; border: none; }
        }
        .back-link { display: inline-block; margin-bottom: 20px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div style="max-width: 500px; margin: 0 auto;">
        <a href="view.jsp" class="back-link">&larr; Back to Search</a>
    </div>
    
    <div class="receipt">
        <h1>Sunrise Dental</h1>
        <p class="subtitle">Colombo | +94 11 123 4567</p>
        
        <% 
            Appointment appt = (Appointment) request.getAttribute("appointment");
            if (appt != null) {
        %>
        
        <div class="row"><span>Patient:</span> <span><%= appt.getPatientName() %></span></div>
        <div class="row"><span>Appt No:</span> <span><%= appt.getAppointmentNumber() %></span></div>
        <div class="row"><span>Date:</span> <span><%= appt.getAppointmentDate() %></span></div>
        <div class="row"><span>Doctor:</span> <span><%= appt.getDentistName() %></span></div>
        
        <div style="margin-top: 30px;">
            <div class="row">
                <span><strong>Description</strong></span>
                <span><strong>Amount</strong></span>
            </div>
            <div class="row">
                <span><%= request.getAttribute("billDescription") %></span>
                <span>LKR <%= request.getAttribute("billTotal") %></span>
            </div>
            <div class="row total">
                <span>Total Amount:</span>
                <span>LKR <%= request.getAttribute("billTotal") %></span>
            </div>
        </div>
        
        <div class="qr-section">
            <p>Scan to verify bill</p>
            <img src="<%= request.getAttribute("qrCodeImage") %>" alt="QR Code">
        </div>
        
        <button class="print-btn" onclick="window.print()">Print Receipt</button>
        <% } else { %>
            <p style="color: red; text-align: center;">Error generating bill.</p>
        <% } %>
    </div>
</body>
</html>
