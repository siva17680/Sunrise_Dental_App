<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
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
    <title>Manage Appointments | Admin</title>
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
        
        .badge { padding: 4px 8px; border-radius: 12px; font-size: 0.8rem; font-weight: 600; }
        .badge.PENDING { background: #fef3c7; color: #d97706; }
        .badge.APPROVED { background: #dcfce3; color: #16a34a; }
        .badge.REJECTED { background: #fee2e2; color: #dc2626; }
        .badge.COMPLETED { background: #e0f2fe; color: #0284c7; }

        .btn { padding: 0.4rem 0.8rem; border: none; border-radius: 0.3rem; font-weight: 600; cursor: pointer; color: white; margin-right: 0.5rem;}
        .btn-approve { background: #22c55e; }
        .btn-reject { background: #ef4444; }
        form { display: inline; }
        
        .logout { margin-top: auto; color: #ef4444; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>🦷 Sunrise Admin</h2>
        <a href="<%=request.getContextPath()%>/adminDashboard" class="nav-link">Services & Add-ons</a>
        <a href="<%=request.getContextPath()%>/adminDoctors" class="nav-link">Doctor Schedules</a>
        <a href="<%=request.getContextPath()%>/adminAppointments" class="nav-link active">Appointments</a>
        <a href="<%=request.getContextPath()%>/adminBilling" class="nav-link">Billing</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link logout">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Manage Appointments</h1>
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date & Time</th>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (appointments != null && !appointments.isEmpty()) {
                        for (Map<String, Object> a : appointments) { 
                            String status = (String) a.get("status");
                    %>
                    <tr>
                        <td>#<%= a.get("id") %></td>
                        <td><%= a.get("date") %> <%= a.get("time") %></td>
                        <td><%= a.get("patient") %></td>
                        <td><%= a.get("doctor") %></td>
                        <td><span class="badge <%= status %>"><%= status %></span></td>
                        <td>
                            <% if ("PENDING".equals(status)) { %>
                            <form action="<%=request.getContextPath()%>/adminAppointments" method="POST">
                                <input type="hidden" name="id" value="<%= a.get("id") %>">
                                <button type="submit" name="action" value="approve" class="btn btn-approve">Approve</button>
                                <button type="submit" name="action" value="reject" class="btn btn-reject">Reject</button>
                            </form>
                            <% } else { %>
                                -
                            <% } %>
                        </td>
                    </tr>
                    <%  } } else { %>
                    <tr><td colspan="6">No appointments found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
