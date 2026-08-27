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
    <title>Billing | Sunrise Dental Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #0a0f1e;
            --primary: #38bdf8;
            --primary-dark: #0ea5e9;
            --primary-glow: rgba(56,189,248,0.25);
            --bg: #f1f5f9;
            --surface: #ffffff;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); display: flex; min-height: 100vh; }

        .sidebar { width: 260px; min-height: 100vh; background: var(--sidebar-bg); display: flex; flex-direction: column; position: sticky; top: 0; box-shadow: 4px 0 24px rgba(0,0,0,0.3); z-index: 100; }
        .sidebar-brand { padding: 1.75rem 1.5rem 1.5rem; border-bottom: 1px solid rgba(255,255,255,0.06); }
        .brand-logo { font-size: 2rem; margin-bottom: 0.25rem; }
        .brand-name { font-size: 1.1rem; font-weight: 700; color: var(--primary); }
        .brand-role { font-size: 0.72rem; color: rgba(148,163,184,0.8); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em; }
        .sidebar-nav { flex: 1; padding: 1rem 0.75rem; display: flex; flex-direction: column; gap: 0.25rem; }
        .nav-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; color: rgba(203,213,225,0.8); text-decoration: none; border-radius: 0.625rem; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .nav-item:hover { background: rgba(255,255,255,0.05); color: #f8fafc; border-left-color: rgba(56,189,248,0.4); }
        .nav-item.active { background: rgba(56,189,248,0.15); color: var(--primary); border-left-color: var(--primary); font-weight: 600; }
        .nav-item .nav-icon { font-size: 1.1rem; flex-shrink: 0; }
        .sidebar-footer { padding: 1rem 0.75rem; border-top: 1px solid rgba(255,255,255,0.06); }
        .nav-item.logout { color: rgba(248,113,113,0.8); }
        .nav-item.logout:hover { background: rgba(239,68,68,0.1); color: #f87171; border-left-color: #f87171; }

        .main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .topbar-left h2 { font-size: 1.4rem; font-weight: 700; }
        .topbar-left .breadcrumb { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.15rem; }
        .user-badge { display: flex; align-items: center; gap: 0.625rem; background: var(--bg); padding: 0.5rem 0.875rem; border-radius: 2rem; border: 1px solid var(--border); }
        .user-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; color: white; }
        .user-name { font-size: 0.85rem; font-weight: 600; }

        .content { padding: 2rem; flex: 1; }

        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); margin-bottom: 1.75rem; overflow: hidden; }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 0.75rem; }
        .card-header-accent { width: 4px; height: 1.5rem; border-radius: 2px; background: linear-gradient(180deg, var(--primary), var(--primary-dark)); }
        .card-title { font-size: 1rem; font-weight: 700; }
        .card-body { padding: 1.5rem; }

        /* FORM */
        .guest-form-grid { display: grid; grid-template-columns: 2fr 1fr 2fr 3fr; gap: 0.75rem; margin-bottom: 1rem; }
        .guest-form-row2 { display: grid; grid-template-columns: 2fr 1fr; gap: 0.75rem; margin-bottom: 1rem; }
        .field-group label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem; }
        .field-input { width: 100%; padding: 0.7rem 0.875rem; border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; color: var(--text); background: #f8fafc; transition: all 0.2s; }
        .field-input:focus { outline: none; border-color: var(--primary); background: white; box-shadow: 0 0 0 3px var(--primary-glow); }

        .services-title { font-size: 0.8rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.75rem; }
        .services-grid { display: flex; flex-wrap: wrap; gap: 0.625rem; margin-bottom: 1.25rem; }
        .service-check-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: #f8fafc;
            border: 1.5px solid var(--border);
            padding: 0.5rem 0.875rem;
            border-radius: 0.5rem;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.2s;
            font-weight: 500;
        }
        .service-check-label:hover { border-color: var(--primary); background: rgba(56,189,248,0.05); }
        .service-check-label input[type="checkbox"] { accent-color: var(--primary); width: 14px; height: 14px; }

        /* TABLE */
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        tbody tr:hover { background: #fafbfc; }
        tbody tr:last-child td { border-bottom: none; }

        .badge { display: inline-flex; align-items: center; padding: 0.3rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600; }
        .badge-paid { background: #dcfce7; color: #16a34a; }
        .badge-unpaid { background: #fee2e2; color: #dc2626; }

        .btn { display: inline-flex; align-items: center; gap: 0.35rem; padding: 0.45rem 0.875rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.8rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .btn-primary { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: #0a0f1e; }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 12px var(--primary-glow); }
        .btn-success { background: linear-gradient(135deg, #22c55e, #16a34a); color: white; }
        .btn-success:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(34,197,94,0.3); }
        .btn-ghost { background: transparent; border: 1.5px solid var(--border); color: var(--text-muted); }
        .btn-ghost:hover { border-color: var(--primary); color: var(--primary); }
        form.inline-form { display: inline; }

        .empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
        .empty-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }
        .actions-cell { display: flex; gap: 0.5rem; flex-wrap: wrap; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo">🦷</div>
            <div class="brand-name">Sunrise Dental</div>
            <div class="brand-role">Admin Portal</div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%=request.getContextPath()%>/adminDashboard" class="nav-item"><span class="nav-icon">⚙️</span> Services &amp; Add-ons</a>
            <a href="<%=request.getContextPath()%>/adminDoctors" class="nav-item"><span class="nav-icon">👨‍⚕️</span> Doctor Schedules</a>
            <a href="<%=request.getContextPath()%>/adminAppointments" class="nav-item"><span class="nav-icon">📅</span> Appointments</a>
            <a href="<%=request.getContextPath()%>/adminBilling" class="nav-item active"><span class="nav-icon">💳</span> Billing</a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=request.getContextPath()%>/api/logout" class="nav-item logout"><span class="nav-icon">🚪</span> Logout</a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h2>Patient Billing</h2>
                <div class="breadcrumb">Admin Dashboard › Billing</div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "A" %></div>
                <span class="user-name"><%= user.getName() %></span>
            </div>
        </header>

        <div class="content">
            <!-- GUEST BILL FORM -->
            <div class="card">
                <div class="card-header">
                    <div class="card-header-accent"></div>
                    <div class="card-title">🧾 Create Manual Bill — Guest Walk-in</div>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/adminBilling" method="POST">
                        <div class="guest-form-grid">
                            <div class="field-group">
                                <label>Guest Full Name</label>
                                <input type="text" name="guest_name" class="field-input" placeholder="e.g. Nimal Perera" required>
                            </div>
                            <div class="field-group">
                                <label>Age</label>
                                <input type="number" name="guest_age" class="field-input" placeholder="30" required min="1">
                            </div>
                            <div class="field-group">
                                <label>Contact Number</label>
                                <input type="text" name="guest_contact" class="field-input" placeholder="+94 77 123 4567" required>
                            </div>
                            <div class="field-group">
                                <label>Address</label>
                                <input type="text" name="guest_address" class="field-input" placeholder="City, Street" required>
                            </div>
                        </div>
                        <div class="guest-form-row2">
                            <div class="field-group">
                                <label>Attending Doctor</label>
                                <select name="doctor_id" class="field-input" required>
                                    <option value="" disabled selected>— Select Doctor —</option>
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
                        </div>

                        <div class="services-title">Select Services</div>
                        <div class="services-grid">
                            <%
                                List<Map<String, Object>> services2 = (List<Map<String, Object>>) request.getAttribute("services");
                                if (services2 != null && !services2.isEmpty()) {
                                    for (Map<String, Object> s : services2) {
                            %>
                            <label class="service-check-label">
                                <input type="checkbox" name="services" value="<%= s.get("id") %>">
                                <%= s.get("name") %> <span style="color:var(--primary); font-weight:600;">LKR <%= s.get("cost") %></span>
                            </label>
                            <%      }
                                } else { %>
                            <p style="color:#ef4444; font-size:0.85rem;">⚠ No services found! Add services in the 'Services &amp; Add-ons' tab first.</p>
                            <% } %>
                        </div>

                        <button type="submit" class="btn btn-primary" style="padding:0.75rem 2rem; font-size:0.9rem;">Generate Bill 🧾</button>
                    </form>
                </div>
            </div>

            <!-- INVOICE HISTORY -->
            <div class="card">
                <div class="card-header">
                    <div class="card-header-accent"></div>
                    <div class="card-title">📜 Invoice History</div>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Invoice</th>
                                <th>Date</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
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
                                <td style="font-weight:700; color:var(--primary);">#INV-<%= b.get("id") %></td>
                                <td style="color:var(--text-muted);"><%= b.get("date") %></td>
                                <td style="font-weight:600;"><%= b.get("patient") %></td>
                                <td style="color:var(--text-muted);"><%= b.get("doctor") %></td>
                                <td style="font-weight:700;">LKR <%= String.format("%.2f", b.get("amount")) %></td>
                                <td><span class="badge <%= "PAID".equals(status) ? "badge-paid" : "badge-unpaid" %>"><%= status %></span></td>
                                <td>
                                    <div class="actions-cell">
                                        <a href="<%=request.getContextPath()%>/printBill?id=<%= b.get("id") %>" class="btn btn-ghost">🖨 Print</a>
                                        <% if ("UNPAID".equals(status)) { %>
                                        <form class="inline-form" action="<%=request.getContextPath()%>/adminBilling" method="POST">
                                            <input type="hidden" name="action" value="mark_paid">
                                            <input type="hidden" name="invoice_id" value="<%= b.get("id") %>">
                                            <button type="submit" class="btn btn-success">✓ Mark Paid</button>
                                        </form>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <%  } } else { %>
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <div class="empty-icon">📭</div>
                                        <p>No invoices found.</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
