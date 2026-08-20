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
    <title>Register Appointment</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        input, select { width: 100%; padding: 10px; margin: 8px 0 20px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { background-color: #2ecc71; color: white; padding: 14px 20px; border: none; border-radius: 4px; cursor: pointer; width: 100%; font-size: 16px; }
        button:hover { background-color: #27ae60; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <a href="dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
        <h2>Register New Appointment</h2>
        
        <form action="RegisterServlet" method="POST">
            <label>Appointment Number (Unique):</label>
            <input type="text" name="appointmentNumber" required>
            
            <label>Patient Name:</label>
            <input type="text" name="patientName" required>
            
            <label>Address:</label>
            <input type="text" name="address" required>
            
            <label>Contact Number:</label>
            <input type="text" name="contactNumber" required>
            
            <label>Dentist Name:</label>
            <input type="text" name="dentistName" required>
            
            <label>Treatment Type:</label>
            <select name="treatmentType">
                <option value="CLEANING">Teeth Cleaning</option>
                <option value="FILLING">Cavity Filling</option>
            </select>
            
            <label>Date:</label>
            <input type="date" name="appointmentDate" required>
            
            <label>Time:</label>
            <input type="time" name="appointmentTime" required>
            
            <button type="submit">Register</button>
        </form>
    </div>
</body>
</html>
