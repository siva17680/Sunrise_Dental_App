<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Map<String, Object>> doctors = (List<Map<String, Object>>) request.getAttribute("doctors");
    List<Map<String, Object>> services = (List<Map<String, Object>>) request.getAttribute("services");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #f8fafc;
            --sidebar-bg: #1e1b4b;
            --text-main: #334155;
            --primary: #818cf8;
            --card-bg: white;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-color); color: var(--text-main); display: flex; min-height: 100vh; }
        
        .sidebar { width: 250px; background: var(--sidebar-bg); color: white; padding: 2rem 1rem; }
        .sidebar h2 { font-size: 1.5rem; margin-bottom: 2rem; text-align: center; color: var(--primary); }
        .nav-link { display: block; padding: 1rem; color: #cbd5e1; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: background 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(129, 140, 248, 0.2); color: white; }

        .main-content { flex: 1; padding: 2rem; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .header h1 { font-size: 2rem; color: #1e1b4b; }
        
        .card { background: var(--card-bg); border-radius: 1rem; padding: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); margin-bottom: 2rem; border-top: 4px solid var(--primary); }
        .card h3 { margin-bottom: 1rem; color: #1e1b4b; border-bottom: 2px solid var(--border); padding-bottom: 0.5rem; }

        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); }
        th { font-weight: 600; color: #64748b; }

        .btn { padding: 0.5rem 1rem; border: none; border-radius: 0.5rem; background: var(--primary); color: white; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn:hover { background: #6366f1; }
        
        .form-row { display: flex; gap: 1rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .form-row select, .form-row input { flex: 1; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; }
        
        .logout { margin-top: auto; color: #f87171; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>🦷 Sunrise Dental</h2>
        <a href="<%=request.getContextPath()%>/patientDashboard" class="nav-link active">Book Appointment</a>
        <a href="#my-appointments" class="nav-link">My Appointments</a>
        <a href="#my-invoices" class="nav-link">My Invoices</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link logout">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Patient Portal</h1>
            <p>Welcome, <%= user.getName() %></p>
        </div>

        <div class="card">
            <h3>Book an Appointment</h3>
            <form action="<%=request.getContextPath()%>/api/secure/patient/book" method="POST">
                <div class="form-row">
                    <select name="availability_id" required>
                        <option value="" disabled selected>Select Doctor & Time</option>
                        <% if (doctors != null) {
                            for (Map<String, Object> d : doctors) { %>
                                <option value="<%= d.get("avail_id") %>">
                                    <%= d.get("name") %> (<%= d.get("specialization") %>) - <%= d.get("date") %> [<%= d.get("start") %> to <%= d.get("end") %>]
                                </option>
                        <%  } } %>
                    </select>
                </div>
                
                <h4 style="margin: 1rem 0 0.5rem 0; color: #64748b;">Select Services (Optional Add-ons)</h4>
                <div style="display: flex; gap: 1rem; flex-wrap: wrap; margin-bottom: 1rem;">
                    <% if (services != null) {
                        for (Map<String, Object> s : services) { %>
                            <label style="display: flex; align-items: center; gap: 0.5rem; background: #f8fafc; padding: 0.5rem 1rem; border-radius: 0.5rem; border: 1px solid var(--border);">
                                <input type="checkbox" name="services" value="<%= s.get("id") %>">
                                <%= s.get("name") %> (LKR <%= s.get("cost") %>)
                            </label>
                    <%  } } %>
                </div>

                <button type="submit" class="btn">Confirm Booking</button>
            </form>
        </div>
        <div class="card" id="my-appointments" style="margin-top:2rem;">
            <h3>My Appointments</h3>
            <table>
                <thead>
                    <tr>
                        <th>Date & Time</th>
                        <th>Doctor</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Map<String, Object>> appointments = (List<Map<String, Object>>) request.getAttribute("appointments");
                        if (appointments != null && !appointments.isEmpty()) {
                            for (Map<String, Object> a : appointments) { 
                                String status = (String) a.get("status");
                    %>
                    <tr>
                        <td><%= a.get("date") %> at <%= a.get("time") %></td>
                        <td><%= a.get("doctor") %></td>
                        <td><span style="padding:4px 8px; border-radius:4px; font-size:0.85rem; font-weight:600; 
                            background:<%= "APPROVED".equals(status) ? "#dcfce7" : ("REJECTED".equals(status) ? "#fee2e2" : "#fef3c7") %>;
                            color:<%= "APPROVED".equals(status) ? "#166534" : ("REJECTED".equals(status) ? "#991b1b" : "#92400e") %>;">
                            <%= status %></span></td>
                    </tr>
                    <%      }
                        } else {
                    %>
                    <tr><td colspan="3">You have no appointment history.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="card" id="my-invoices">
            <h3>My Invoices</h3>
            <table>
                <thead>
                    <tr>
                        <th>Invoice ID</th>
                        <th>Date</th>
                        <th>Doctor</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Map<String, Object>> invoices = (List<Map<String, Object>>) request.getAttribute("invoices");
                        if (invoices != null && !invoices.isEmpty()) {
                            for (Map<String, Object> inv : invoices) { 
                                String status = (String) inv.get("status");
                    %>
                    <tr>
                        <td>#INV-<%= inv.get("id") %></td>
                        <td><%= inv.get("date") %></td>
                        <td><%= inv.get("doctor") %></td>
                        <td>LKR <%= String.format("%.2f", inv.get("amount")) %></td>
                        <td><span style="padding:4px 8px; border-radius:4px; font-size:0.85rem; font-weight:600; 
                            background:<%= "PAID".equals(status) ? "#dcfce7" : "#fee2e2" %>;
                            color:<%= "PAID".equals(status) ? "#166534" : "#991b1b" %>;">
                            <%= status %></span></td>
                        <td>
                            <a href="<%=request.getContextPath()%>/printBill?id=<%= inv.get("id") %>" class="btn" style="text-decoration:none;">View Bill</a>
                        </td>
                    </tr>
                    <%      }
                        } else {
                    %>
                    <tr><td colspan="6">You have no invoices.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
