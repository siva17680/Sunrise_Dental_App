<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Map<String, Object>> appointments = (List<Map<String, Object>>) request.getAttribute("appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #f8fafc;
            --sidebar-bg: #064e3b;
            --text-main: #334155;
            --primary: #34d399;
            --card-bg: white;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-color); color: var(--text-main); display: flex; min-height: 100vh; }
        
        .sidebar { width: 250px; background: var(--sidebar-bg); color: white; padding: 2rem 1rem; }
        .sidebar h2 { font-size: 1.5rem; margin-bottom: 2rem; text-align: center; color: var(--primary); }
        .nav-link { display: block; padding: 1rem; color: #d1fae5; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: background 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(52, 211, 153, 0.2); color: white; }

        .main-content { flex: 1; padding: 2rem; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .header h1 { font-size: 2rem; color: #064e3b; }
        
        .card { background: var(--card-bg); border-radius: 1rem; padding: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); margin-bottom: 2rem; border-top: 4px solid var(--primary); }
        .card h3 { margin-bottom: 1rem; color: #064e3b; border-bottom: 2px solid var(--border); padding-bottom: 0.5rem; }

        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); }
        th { font-weight: 600; color: #64748b; }

        .btn { padding: 0.5rem 1rem; border: none; border-radius: 0.5rem; background: var(--primary); color: #064e3b; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn:hover { background: #10b981; color: white; }
        
        .form-row { display: flex; gap: 1rem; margin-bottom: 1rem; }
        .form-row input { flex: 1; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; }
        
        .logout { margin-top: auto; color: #f87171; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>🦷 Dr. Portal</h2>
        <a href="<%=request.getContextPath()%>/doctorDashboard" class="nav-link active">My Patients</a>
        <a href="#" class="nav-link">Set Availability</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link logout">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Doctor Dashboard</h1>
            <p>Welcome, <%= user.getName() %></p>
        </div>

        <div class="card">
            <h3>Add Availability</h3>
            <form action="<%=request.getContextPath()%>/api/secure/doctor/availability" method="POST" class="form-row">
                <input type="date" name="date" required>
                <input type="time" name="start_time" required>
                <input type="time" name="end_time" required>
                <button type="submit" class="btn">Add Time Slot</button>
            </form>
        </div>

        <div class="card">
            <h3>My Patients (Appointments & Guests)</h3>
            <table>
                <thead>
                    <tr>
                        <th>Date & Time</th>
                        <th>Type</th>
                        <th>Patient Name</th>
                        <th>Medical History</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (appointments != null && !appointments.isEmpty()) {
                        for (Map<String, Object> a : appointments) { 
                            boolean isGuest = "GUEST".equals(a.get("type"));
                            String actionUrl = request.getContextPath() + "/doctorPrescribe?";
                            if (isGuest) {
                                actionUrl += "invoice_id=" + a.get("invoice_id");
                            } else {
                                actionUrl += "appt_id=" + a.get("appt_id");
                            }
                    %>
                    <tr>
                        <td><%= a.get("date") %> <br> <small><%= a.get("time") %></small></td>
                        <td>
                            <% if (isGuest) { %>
                                <span style="background: #fde68a; color: #b45309; padding: 0.2rem 0.5rem; border-radius: 0.25rem; font-size: 0.8rem;">Guest</span>
                            <% } else { %>
                                <span style="background: #d1fae5; color: #065f46; padding: 0.2rem 0.5rem; border-radius: 0.25rem; font-size: 0.8rem;">Registered</span>
                            <% } %>
                        </td>
                        <td><%= a.get("patient_name") %></td>
                        <td><%= a.get("history") %></td>
                        <td>
                            <a href="<%= actionUrl %>" class="btn" style="text-decoration:none; display:inline-block; background:#fbbf24; color:#78350f;">Prescribe Meds</a>
                        </td>
                    </tr>
                    <%  }
                       } else { %>
                    <tr><td colspan="4">No appointments found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
