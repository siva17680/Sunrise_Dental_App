<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"PHARMACIST".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Map<String, Object>> prescriptions = (List<Map<String, Object>>) request.getAttribute("prescriptions");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacist Dashboard | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #f8fafc;
            --sidebar-bg: #4c1d95;
            --text-main: #334155;
            --primary: #a78bfa;
            --card-bg: white;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-color); color: var(--text-main); display: flex; min-height: 100vh; }
        
        .sidebar { width: 250px; background: var(--sidebar-bg); color: white; padding: 2rem 1rem; }
        .sidebar h2 { font-size: 1.5rem; margin-bottom: 2rem; text-align: center; color: var(--primary); }
        .nav-link { display: block; padding: 1rem; color: #ede9fe; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: background 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(167, 139, 250, 0.2); color: white; }

        .main-content { flex: 1; padding: 2rem; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .header h1 { font-size: 2rem; color: #4c1d95; }
        
        .card { background: var(--card-bg); border-radius: 1rem; padding: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); margin-bottom: 2rem; border-top: 4px solid var(--primary); }
        .card h3 { margin-bottom: 1rem; color: #4c1d95; border-bottom: 2px solid var(--border); padding-bottom: 0.5rem; }

        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); }
        th { font-weight: 600; color: #64748b; }

        .btn { padding: 0.5rem 1rem; border: none; border-radius: 0.5rem; background: var(--primary); color: #4c1d95; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn:hover { background: #8b5cf6; color: white; }
        
        .logout { margin-top: auto; color: #f87171; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>💊 Pharmacy</h2>
        <a href="<%=request.getContextPath()%>/pharmacistDashboard" class="nav-link active">Prescriptions</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link logout">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Pharmacy Dashboard</h1>
            <p>Welcome, <%= user.getName() %></p>
        </div>

        <div class="card">
            <h3>Recent Prescriptions</h3>
            <table>
                <thead>
                    <tr>
                        <th>Date Issued</th>
                        <th>Invoice ID</th>
                        <th>Patient Name</th>
                        <th>Doctor Name</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (prescriptions != null && !prescriptions.isEmpty()) {
                        for (Map<String, Object> p : prescriptions) { %>
                    <tr>
                        <td><%= p.get("date") %></td>
                        <td>#INV-<%= p.get("invoice_id") %></td>
                        <td><%= p.get("patient") %></td>
                        <td><%= p.get("doctor") %></td>
                        <td>
                            <a href="<%=request.getContextPath()%>/pharmacistProcess?id=<%= p.get("id") %>" class="btn" style="text-decoration:none; display:inline-block;">Process</a>
                        </td>
                    </tr>
                    <%  }
                       } else { %>
                    <tr><td colspan="5">No pending prescriptions found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
