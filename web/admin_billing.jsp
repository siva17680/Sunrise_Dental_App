<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Map<String, Object>> bills = (List<Map<String, Object>>) request.getAttribute("bills");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing | Admin</title>
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
        .badge.UNPAID { background: #fee2e2; color: #dc2626; }
        .badge.PAID { background: #dcfce3; color: #16a34a; }

        .btn { padding: 0.4rem 0.8rem; border: none; border-radius: 0.3rem; font-weight: 600; cursor: pointer; color: white; background: #38bdf8; }
        .logout { margin-top: auto; color: #ef4444; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>🦷 Sunrise Admin</h2>
        <a href="<%=request.getContextPath()%>/adminDashboard" class="nav-link">Services & Add-ons</a>
        <a href="<%=request.getContextPath()%>/adminDoctors" class="nav-link">Doctor Schedules</a>
        <a href="<%=request.getContextPath()%>/adminAppointments" class="nav-link">Appointments</a>
        <a href="<%=request.getContextPath()%>/adminBilling" class="nav-link active">Billing</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link logout">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Patient Billing</h1>
        </div>

        <div class="card" style="margin-bottom: 2rem; border-top: 4px solid #38bdf8;">
            <h3>Create Manual Bill (Guest Walk-in)</h3>
            <form action="<%=request.getContextPath()%>/adminBilling" method="POST">
                <div style="display:flex; gap:1rem; margin-bottom:1rem; flex-wrap:wrap;">
                    <input type="text" name="guest_name" placeholder="Guest Full Name" required style="flex:2; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem; min-width:200px;">
                    <input type="number" name="guest_age" placeholder="Age" required style="flex:1; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem; min-width:80px;">
                    <input type="text" name="guest_contact" placeholder="Guest Contact" required style="flex:2; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem; min-width:150px;">
                    <input type="text" name="guest_address" placeholder="Address" required style="flex:3; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem; min-width:250px;">
                    <select name="doctor_id" required style="flex:2; padding:0.75rem; border:1px solid var(--border); border-radius:0.5rem; min-width:200px;">
                        <option value="" disabled selected>Select Doctor</option>
                        <% 
                            List<Map<String, Object>> doctors = (List<Map<String, Object>>) request.getAttribute("doctors");
                            if (doctors != null) {
                                for (Map<String, Object> d : doctors) { 
                        %>
                                <option value="<%= d.get("id") %>"><%= d.get("name") %></option>
                        <%      }
                            } 
                        %>
                    </select>
                </div>
                <h4 style="margin-bottom:0.5rem;">Select Services:</h4>
                <div style="display:flex; gap:1rem; flex-wrap:wrap; margin-bottom:1rem;">
                    <% 
                        List<Map<String, Object>> services = (List<Map<String, Object>>) request.getAttribute("services");
                        if (services != null && !services.isEmpty()) {
                            for (Map<String, Object> s : services) { 
                    %>
                            <label style="background:#f1f5f9; padding:0.5rem; border-radius:0.3rem;">
                                <input type="checkbox" name="services" value="<%= s.get("id") %>"> 
                                <%= s.get("name") %> (LKR <%= s.get("cost") %>)
                            </label>
                    <%      }
                        } else {
                    %>
                            <p style="color:#ef4444; font-size:0.9rem;">No services found! Please add services in the 'Services & Add-ons' tab first.</p>
                    <%  } %>
                </div>
                <button type="submit" class="btn">Generate Bill</button>
            </form>
        </div>

        <div class="card">
            <h3>Invoice History</h3>
            <table>
                <thead>
                    <tr>
                        <th>Invoice ID</th>
                        <th>Date</th>
                        <th>Patient Name</th>
                        <th>Doctor</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        bills = (List<Map<String, Object>>) request.getAttribute("bills");
                        if (bills != null && !bills.isEmpty()) {
                            for (Map<String, Object> b : bills) { 
                            String status = (String) b.get("status");
                    %>
                    <tr>
                        <td>#INV-<%= b.get("id") %></td>
                        <td><%= b.get("date") %></td>
                        <td><%= b.get("patient") %></td>
                        <td><%= b.get("doctor") %></td>
                        <td>LKR <%= String.format("%.2f", b.get("amount")) %></td>
                        <td><span class="badge <%= status %>"><%= status %></span></td>
                        <td>
                            <div style="display:flex; gap:0.5rem;">
                                <a href="<%=request.getContextPath()%>/printBill?id=<%= b.get("id") %>" class="btn" style="text-decoration:none; display:inline-block; text-align:center;">Print</a>
                                <% if ("UNPAID".equals(status)) { %>
                                <form action="<%=request.getContextPath()%>/adminBilling" method="POST" style="margin:0;">
                                    <input type="hidden" name="action" value="mark_paid">
                                    <input type="hidden" name="invoice_id" value="<%= b.get("id") %>">
                                    <button type="submit" class="btn" style="background:#22c55e;">Mark Paid</button>
                                </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%  } } else { %>
                    <tr><td colspan="7">No invoices found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
