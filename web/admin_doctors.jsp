<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Map<String, Object>> schedules = (List<Map<String, Object>>) request.getAttribute("schedules");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Schedules | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --bg-color: #f8fafc; --sidebar-bg: #0f172a; --text-main: #334155; --primary: #38bdf8; --card-bg: white; --border: #e2e8f0; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-color); color: var(--text-main); display: flex; min-height: 100vh; }
        
        .sidebar { width: 250px; background: var(--sidebar-bg); color: white; padding: 2rem 1rem; }
        .sidebar h2 { font-size: 1.5rem; margin-bottom: 2rem; text-align: center; color: var(--primary); }
        .nav-link { display: block; padding: 1rem; color: #cbd5e1; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: background 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(56, 189, 248, 0.2); color: white; }

        .main-content { flex: 1; padding: 2rem; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .header h1 { font-size: 2rem; color: #0f172a; }
        
        .card { background: var(--card-bg); border-radius: 1rem; padding: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); }
        th { font-weight: 600; color: #64748b; }
        
        .logout { margin-top: auto; color: #ef4444; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>🦷 Sunrise Admin</h2>
        <a href="<%=request.getContextPath()%>/adminDashboard" class="nav-link">Services & Add-ons</a>
        <a href="<%=request.getContextPath()%>/adminDoctors" class="nav-link active">Doctor Schedules</a>
        <a href="<%=request.getContextPath()%>/adminAppointments" class="nav-link">Appointments</a>
        <a href="<%=request.getContextPath()%>/adminBilling" class="nav-link">Billing</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link logout">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Doctor Management</h1>
        </div>

        <div class="card" style="margin-bottom: 2rem; border-top: 4px solid #38bdf8;">
            <h3>Add New Doctor Account</h3>
            <form action="<%=request.getContextPath()%>/adminDoctors" method="POST">
                <div style="display:flex; gap:1rem; margin-bottom:1rem;">
                    <input type="text" name="name" placeholder="Doctor Full Name" required style="flex:1; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem;">
                    <input type="text" name="specialization" placeholder="Specialization (e.g. Orthodontist)" required style="flex:1; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem;">
                </div>
                <div style="display:flex; gap:1rem; margin-bottom:1rem;">
                    <input type="text" name="username" placeholder="Login Username" required style="flex:1; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem;">
                    <input type="password" name="password" placeholder="Login Password" required style="flex:1; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem;">
                </div>
                <button type="submit" class="btn" style="background:#38bdf8; color:white; padding: 0.5rem 1rem; border:none; border-radius:0.3rem; font-weight:bold; cursor:pointer;">Create Doctor Account</button>
            </form>
        </div>

        <div class="card">
            <h3>Doctor Availability Schedules</h3>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Doctor</th>
                        <th>Specialization</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (schedules != null && !schedules.isEmpty()) {
                        for (Map<String, Object> s : schedules) { %>
                    <tr>
                        <td><%= s.get("date") %></td>
                        <td><%= s.get("start") %></td>
                        <td><%= s.get("end") %></td>
                        <td style="font-weight:600;"><%= s.get("doctor") %></td>
                        <td><%= s.get("specialization") %></td>
                    </tr>
                    <%  } } else { %>
                    <tr><td colspan="5">No schedules found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
