<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Ensure user is logged in and is ADMIN
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Map<String, Object>> services = (List<Map<String, Object>>) request.getAttribute("services");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #f8fafc;
            --sidebar-bg: #0f172a;
            --text-main: #334155;
            --primary: #38bdf8;
            --card-bg: white;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-color); color: var(--text-main); display: flex; min-height: 100vh; }
        
        .sidebar { width: 250px; background: var(--sidebar-bg); color: white; padding: 2rem 1rem; }
        .sidebar h2 { font-size: 1.5rem; margin-bottom: 2rem; text-align: center; color: var(--primary); }
        .nav-link { display: block; padding: 1rem; color: #cbd5e1; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: background 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(56, 189, 248, 0.2); color: white; }

        .main-content { flex: 1; padding: 2rem; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .header h1 { font-size: 2rem; color: #0f172a; }
        
        .card { background: var(--card-bg); border-radius: 1rem; padding: 1.5rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); margin-bottom: 2rem; }
        .card h3 { margin-bottom: 1rem; color: #0f172a; border-bottom: 2px solid var(--border); padding-bottom: 0.5rem; }

        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); }
        th { font-weight: 600; color: #64748b; }

        .btn { padding: 0.5rem 1rem; border: none; border-radius: 0.5rem; background: var(--primary); color: #0f172a; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn:hover { background: #0ea5e9; color: white; }
        
        .form-row { display: flex; gap: 1rem; margin-bottom: 1rem; }
        .form-row input, .form-row select { flex: 1; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; }
        
        .logout { margin-top: auto; color: #ef4444; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>🦷 Sunrise Admin</h2>
        <a href="<%=request.getContextPath()%>/adminDashboard" class="nav-link active">Services & Add-ons</a>
        <a href="<%=request.getContextPath()%>/adminDoctors" class="nav-link">Doctor Schedules</a>
        <a href="<%=request.getContextPath()%>/adminAppointments" class="nav-link">Appointments</a>
        <a href="<%=request.getContextPath()%>/adminBilling" class="nav-link">Billing</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link logout">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Manage Services</h1>
            <p>Welcome, <%= user.getName() %></p>
        </div>

        <div class="card">
            <h3>Add New Service / Add-on</h3>
            <form action="<%=request.getContextPath()%>/api/secure/admin/services" method="POST" class="form-row">
                <input type="text" name="name" placeholder="Service Name" required>
                <input type="text" name="description" placeholder="Description" required>
                <input type="number" name="cost" placeholder="Cost ($)" step="0.01" required>
                <select name="category">
                    <option value="Base">Base Consultation</option>
                    <option value="Add-on">Add-on Service</option>
                </select>
                <button type="submit" class="btn">Add</button>
            </form>
        </div>

        <div class="card">
            <h3>Available Services</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Cost</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (services != null) {
                        for (Map<String, Object> s : services) {
                            String catColor = "Add-on".equals(s.get("category")) ? "#e0f2fe" : "#f1f5f9";
                            String textColor = "Add-on".equals(s.get("category")) ? "#0369a1" : "#475569";
                    %>
                    <tr>
                        <td><%= s.get("id") %></td>
                        <td><%= s.get("name") %></td>
                        <td><%= s.get("description") %></td>
                        <td><span style="padding: 4px 8px; border-radius: 12px; background: <%= catColor %>; color: <%= textColor %>; font-size: 0.8rem;"><%= s.get("category") %></span></td>
                        <td>LKR <%= String.format("%.2f", s.get("cost")) %></td>
                    </tr>
                    <%  }
                       } else { %>
                    <tr><td colspan="5">No services available or reload page.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
