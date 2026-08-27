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
    <title>Patient Portal | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #1e1b4b;
            --primary: #818cf8;
            --primary-dark: #6366f1;
            --primary-glow: rgba(129,140,248,0.25);
            --bg: #f5f3ff;
            --surface: #ffffff;
            --text: #1e1b4b;
            --text-body: #1e293b;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text-body); display: flex; min-height: 100vh; }

        .sidebar { width: 260px; min-height: 100vh; background: var(--sidebar-bg); display: flex; flex-direction: column; position: sticky; top: 0; box-shadow: 4px 0 24px rgba(0,0,0,0.3); z-index: 100; }
        .sidebar-brand { padding: 1.75rem 1.5rem 1.5rem; border-bottom: 1px solid rgba(255,255,255,0.08); }
        .brand-logo { font-size: 2rem; margin-bottom: 0.25rem; }
        .brand-name { font-size: 1.1rem; font-weight: 700; color: var(--primary); }
        .brand-role { font-size: 0.72rem; color: rgba(199,210,254,0.7); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em; }
        .patient-profile { padding: 1.25rem 1.5rem; border-bottom: 1px solid rgba(255,255,255,0.08); display: flex; align-items: center; gap: 0.75rem; }
        .pat-avatar { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 1rem; font-weight: 700; color: white; flex-shrink: 0; }
        .pat-info .pat-name { font-size: 0.85rem; font-weight: 600; color: #f0f4ff; }
        .pat-info .pat-label { font-size: 0.72rem; color: rgba(199,210,254,0.6); }
        .sidebar-nav { flex: 1; padding: 1rem 0.75rem; display: flex; flex-direction: column; gap: 0.25rem; }
        .nav-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; color: rgba(199,210,254,0.8); text-decoration: none; border-radius: 0.625rem; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .nav-item:hover { background: rgba(129,140,248,0.1); color: #c7d2fe; border-left-color: rgba(129,140,248,0.5); }
        .nav-item.active { background: rgba(129,140,248,0.18); color: var(--primary); border-left-color: var(--primary); font-weight: 600; }
        .nav-item .nav-icon { font-size: 1.1rem; flex-shrink: 0; }
        .sidebar-footer { padding: 1rem 0.75rem; border-top: 1px solid rgba(255,255,255,0.08); }
        .nav-item.logout { color: rgba(248,113,113,0.8); }
        .nav-item.logout:hover { background: rgba(239,68,68,0.1); color: #f87171; border-left-color: #f87171; }

        .main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .topbar-left h2 { font-size: 1.4rem; font-weight: 700; color: var(--text); }
        .topbar-left .breadcrumb { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.15rem; }
        .user-badge { display: flex; align-items: center; gap: 0.625rem; background: var(--bg); padding: 0.5rem 0.875rem; border-radius: 2rem; border: 1px solid #c7d2fe; }
        .user-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; color: white; }
        .user-name { font-size: 0.85rem; font-weight: 600; color: var(--text); }

        .content { padding: 2rem; flex: 1; }

        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); margin-bottom: 1.75rem; overflow: hidden; border-top: 4px solid var(--primary); }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); }
        .card-title { font-size: 1rem; font-weight: 700; color: var(--text); }
        .card-body { padding: 1.5rem; }

        /* BOOKING FORM */
        .field-group { margin-bottom: 1.25rem; }
        .field-group label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem; }
        .field-input { width: 100%; padding: 0.8rem 1rem; border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.9rem; color: var(--text-body); background: #f8fafc; transition: all 0.2s; }
        .field-input:focus { outline: none; border-color: var(--primary); background: white; box-shadow: 0 0 0 3px var(--primary-glow); }

        .services-label { font-size: 0.8rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.75rem; }
        .services-grid { display: flex; flex-wrap: wrap; gap: 0.625rem; margin-bottom: 1.25rem; }
        .service-card-label {
            display: flex;
            align-items: center;
            gap: 0.625rem;
            background: #f8fafc;
            border: 2px solid var(--border);
            padding: 0.625rem 1rem;
            border-radius: 0.625rem;
            font-size: 0.825rem;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.4,0,0.2,1);
            font-weight: 500;
            user-select: none;
        }
        .service-card-label:hover { border-color: var(--primary); background: rgba(129,140,248,0.05); }
        .service-card-label input[type="checkbox"] { display: none; }
        .service-card-label .check-icon { width: 18px; height: 18px; border: 2px solid var(--border); border-radius: 4px; display: flex; align-items: center; justify-content: center; transition: all 0.2s; flex-shrink: 0; font-size: 0.7rem; }
        .service-card-label input:checked + .check-icon { background: var(--primary); border-color: var(--primary); color: white; }
        .service-card-label:has(input:checked) { border-color: var(--primary); background: rgba(129,140,248,0.08); }

        /* TABLE */
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        tbody tr:hover { background: #faf9ff; }
        tbody tr:last-child td { border-bottom: none; }

        .badge { display: inline-flex; align-items: center; padding: 0.3rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600; }
        .badge-pending { background: #fef3c7; color: #d97706; }
        .badge-approved { background: #dcfce7; color: #16a34a; }
        .badge-rejected { background: #fee2e2; color: #dc2626; }
        .badge-paid { background: #dcfce7; color: #16a34a; }
        .badge-unpaid { background: #fee2e2; color: #dc2626; }

        .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.7rem 1.25rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .btn-primary { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; box-shadow: 0 2px 8px var(--primary-glow); width: 100%; justify-content: center; font-size: 0.95rem; padding: 0.875rem; }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 16px var(--primary-glow); }
        .btn-view { background: transparent; border: 1.5px solid var(--primary); color: var(--primary); font-size: 0.8rem; padding: 0.4rem 0.875rem; }
        .btn-view:hover { background: var(--primary); color: white; }

        .empty-state { text-align: center; padding: 2.5rem; color: var(--text-muted); }
        .empty-icon { font-size: 2.5rem; margin-bottom: 0.75rem; opacity: 0.4; }
        .inv-id { font-weight: 700; color: var(--primary); }
        .date-main { font-weight: 600; }
        .time-sub { font-size: 0.75rem; color: var(--text-muted); }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo">🦷</div>
            <div class="brand-name">Sunrise Dental</div>
            <div class="brand-role">Patient Portal</div>
        </div>
        <div class="patient-profile">
            <div class="pat-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "P" %></div>
            <div class="pat-info">
                <div class="pat-name"><%= user.getName() %></div>
                <div class="pat-label">Patient</div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%=request.getContextPath()%>/patientDashboard" class="nav-item active"><span class="nav-icon">📅</span> Book Appointment</a>
            <a href="#my-appointments" class="nav-item"><span class="nav-icon">🩺</span> My Appointments</a>
            <a href="#my-invoices" class="nav-item"><span class="nav-icon">🧾</span> My Invoices</a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=request.getContextPath()%>/api/logout" class="nav-item logout"><span class="nav-icon">🚪</span> Logout</a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h2>Patient Portal</h2>
                <div class="breadcrumb">Welcome back, <%= user.getName() %></div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "P" %></div>
                <span class="user-name"><%= user.getName() %></span>
            </div>
        </header>

        <div class="content">
            <!-- BOOK APPOINTMENT -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">📅 Book an Appointment</div>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/api/secure/patient/book" method="POST">
                        <div class="field-group">
                            <label>Select Doctor &amp; Time Slot</label>
                            <select name="availability_id" class="field-input" required>
                                <option value="" disabled selected>— Choose a doctor and available slot —</option>
                                <% if (doctors != null) {
                                    for (Map<String, Object> d : doctors) { %>
                                <option value="<%= d.get("avail_id") %>">
                                    Dr. <%= d.get("name") %> (<%= d.get("specialization") %>) — <%= d.get("date") %> [<%= d.get("start") %> to <%= d.get("end") %>]
                                </option>
                                <%  } } %>
                            </select>
                        </div>

                        <div class="services-label">Optional Add-on Services</div>
                        <div class="services-grid">
                            <% if (services != null) {
                                for (Map<String, Object> s : services) { %>
                            <label class="service-card-label">
                                <input type="checkbox" name="services" value="<%= s.get("id") %>">
                                <span class="check-icon">✓</span>
                                <span><%= s.get("name") %> <strong style="color:var(--primary);">LKR <%= s.get("cost") %></strong></span>
                            </label>
                            <%  } } %>
                        </div>

                        <button type="submit" class="btn btn-primary">Confirm Booking 📅</button>
                    </form>
                </div>
            </div>

            <!-- MY APPOINTMENTS -->
            <div class="card" id="my-appointments">
                <div class="card-header">
                    <div class="card-title">🩺 My Appointments</div>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Date &amp; Time</th>
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
                                        String badgeClass = "APPROVED".equals(status) ? "badge-approved" :
                                                            "REJECTED".equals(status) ? "badge-rejected" : "badge-pending";
                            %>
                            <tr>
                                <td>
                                    <div class="date-main"><%= a.get("date") %></div>
                                    <div class="time-sub"><%= a.get("time") %></div>
                                </td>
                                <td style="font-weight:600;">Dr. <%= a.get("doctor") %></td>
                                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                            </tr>
                            <%      }
                                } else { %>
                            <tr>
                                <td colspan="3">
                                    <div class="empty-state">
                                        <div class="empty-icon">📅</div>
                                        <p>You have no appointments yet. Book one above!</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- MY INVOICES -->
            <div class="card" id="my-invoices">
                <div class="card-header">
                    <div class="card-title">🧾 My Invoices</div>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Invoice</th>
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
                                <td class="inv-id">#INV-<%= inv.get("id") %></td>
                                <td style="color:var(--text-muted);"><%= inv.get("date") %></td>
                                <td style="font-weight:600;">Dr. <%= inv.get("doctor") %></td>
                                <td style="font-weight:700;">LKR <%= String.format("%.2f", inv.get("amount")) %></td>
                                <td><span class="badge <%= "PAID".equals(status) ? "badge-paid" : "badge-unpaid" %>"><%= status %></span></td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/printBill?id=<%= inv.get("id") %>" class="btn btn-view">🖨 View Bill</a>
                                </td>
                            </tr>
                            <%      }
                                } else { %>
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <div class="empty-icon">🧾</div>
                                        <p>You have no invoices yet.</p>
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
