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
    <title>View Appointment</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .search-box { display: flex; gap: 10px; margin-bottom: 20px; }
        input[type="text"] { flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        button { background-color: #3498db; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #2980b9; }
        .details { margin-top: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 4px; background: #fafafa; }
        .details p { margin: 8px 0; }
        .error { color: #e74c3c; margin-bottom: 10px; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #3498db; text-decoration: none; }
        .btn-bill { background-color: #f1c40f; color: #333; display: block; text-align: center; margin-top: 15px; padding: 10px; text-decoration: none; border-radius: 4px; font-weight: bold; }
        .btn-bill:hover { background-color: #f39c12; }
    </style>
</head>
<body>
    <div class="container">
        <a href="dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
        <h2>Search Appointment</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="error"><%= request.getParameter("error") %></div>
        <% } %>

        <form action="ViewAppointmentServlet" method="GET" class="search-box">
            <input type="text" name="appointmentNumber" placeholder="Enter Appointment Number" required>
            <button type="submit">Search</button>
        </form>
        
        <% 
            Appointment appt = (Appointment) request.getAttribute("appointment");
            if (appt != null) {
        %>
        <div class="details">
            <h3>Appointment Details</h3>
            <p><strong>Appt No:</strong> <%= appt.getAppointmentNumber() %></p>
            <p><strong>Patient Name:</strong> <%= appt.getPatientName() %></p>
            <p><strong>Address:</strong> <%= appt.getAddress() %></p>
            <p><strong>Contact:</strong> <%= appt.getContactNumber() %></p>
            <p><strong>Dentist:</strong> <%= appt.getDentistName() %></p>
            <p><strong>Treatment:</strong> <%= appt.getTreatmentType() %></p>
            <p><strong>Date:</strong> <%= appt.getAppointmentDate() %></p>
            <p><strong>Time:</strong> <%= appt.getAppointmentTime() %></p>
            
            <a href="BillServlet?appointmentNumber=<%= appt.getAppointmentNumber() %>" class="btn-bill">Generate Bill / Receipt</a>
        </div>
        <% } %>
    </div>
</body>
</html>
