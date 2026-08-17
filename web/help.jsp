<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Help & Instructions</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; }
        h3 { color: #34495e; margin-top: 25px; }
        p, li { line-height: 1.6; color: #555; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <a href="dashboard.jsp" class="back-link">&larr; Back to Dashboard</a>
        <h2>System Instructions for Staff</h2>
        
        <h3>1. Login</h3>
        <p>Access the system by entering your authorized username and password (default: admin / admin123). If you are unauthorized, you cannot access other pages.</p>
        
        <h3>2. Registering an Appointment</h3>
        <ul>
            <li>Click on "Register New Appointment" from the dashboard.</li>
            <li>Fill in all patient details including the Unique Appointment Number.</li>
            <li>Select the Treatment Type to ensure accurate bill calculation later.</li>
            <li>Click "Register". A success message will appear if the data is saved in the database.</li>
        </ul>
        
        <h3>3. Searching & Viewing Appointments</h3>
        <ul>
            <li>Click on "Search / View Appointment" from the dashboard.</li>
            <li>Enter the Appointment Number.</li>
            <li>The system will retrieve and display the full details from the database.</li>
        </ul>
        
        <h3>4. Billing & Receipt</h3>
        <ul>
            <li>After searching for an appointment, click the "Generate Bill / Receipt" button.</li>
            <li>The system automatically calculates the cost based on a base consultation fee + the specific treatment fee, and adds a 10% tax (using Decorator pattern logic).</li>
            <li>A QR code is generated dynamically containing the bill details.</li>
            <li>Click "Print Receipt" to print a hardcopy.</li>
        </ul>
        
        <h3>5. Exiting</h3>
        <p>Always click the "Logout" button on the Dashboard when you are done to safely close your session.</p>
    </div>
</body>
</html>
