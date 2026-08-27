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
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Portal | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* ─── THEME VARIABLES ─── */
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
        [data-theme="dark"] {
            --bg: #0f0e1a;
            --surface: #1a1827;
            --text: #c7d2fe;
            --text-body: #e2e8f0;
            --text-muted: #94a3b8;
            --border: #2d2b3f;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text-body); display: flex; min-height: 100vh; transition: background 0.3s, color 0.3s; }

        /* ─── SIDEBAR ─── */
        .sidebar { width: 260px; min-height: 100vh; background: var(--sidebar-bg); display: flex; flex-direction: column; position: sticky; top: 0; box-shadow: 4px 0 24px rgba(0,0,0,0.3); z-index: 100; }
        .sidebar-brand { padding: 1.75rem 1.5rem 1.5rem; border-bottom: 1px solid rgba(255,255,255,0.08); }
        .brand-logo { font-size: 2rem; margin-bottom: 0.25rem; }
        .brand-name { font-size: 1.1rem; font-weight: 700; color: var(--primary); }
        .brand-role { font-size: 0.72rem; color: rgba(199,210,254,0.7); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em; }
        .patient-profile { padding: 1.25rem 1.5rem; border-bottom: 1px solid rgba(255,255,255,0.08); display: flex; align-items: center; gap: 0.75rem; }
        .pat-avatar { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 1rem; font-weight: 700; color: white; flex-shrink: 0; }
        .pat-name { font-size: 0.85rem; font-weight: 600; color: #f0f4ff; }
        .pat-label { font-size: 0.72rem; color: rgba(199,210,254,0.6); }
        .sidebar-nav { flex: 1; padding: 1rem 0.75rem; display: flex; flex-direction: column; gap: 0.25rem; }
        .nav-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; color: rgba(199,210,254,0.8); text-decoration: none; border-radius: 0.625rem; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .nav-item:hover { background: rgba(129,140,248,0.1); color: #c7d2fe; border-left-color: rgba(129,140,248,0.5); }
        .nav-item.active { background: rgba(129,140,248,0.18); color: var(--primary); border-left-color: var(--primary); font-weight: 600; }
        .nav-item .nav-icon { font-size: 1.1rem; flex-shrink: 0; }
        .sidebar-footer { padding: 1rem 0.75rem; border-top: 1px solid rgba(255,255,255,0.08); }
        .nav-item.logout { color: rgba(248,113,113,0.8); }
        .nav-item.logout:hover { background: rgba(239,68,68,0.1); color: #f87171; border-left-color: #f87171; }

        /* ─── MAIN ─── */
        .main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.05); transition: background 0.3s; }
        .topbar-left h2 { font-size: 1.4rem; font-weight: 700; color: var(--text); }
        .topbar-left .breadcrumb { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.15rem; }
        .topbar-actions { display: flex; align-items: center; gap: 0.75rem; }
        .user-badge { display: flex; align-items: center; gap: 0.625rem; background: var(--bg); padding: 0.5rem 0.875rem; border-radius: 2rem; border: 1px solid #c7d2fe; }
        .user-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; color: white; }
        .user-name { font-size: 0.85rem; font-weight: 600; color: var(--text); }
        .dark-toggle { background: var(--bg); border: 1px solid var(--border); border-radius: 0.5rem; padding: 0.5rem 0.75rem; cursor: pointer; font-size: 1rem; transition: all 0.2s; }
        .dark-toggle:hover { border-color: var(--primary); }

        .content { padding: 2rem; flex: 1; }

        /* ─── TOAST ─── */
        .toast-container { position: fixed; bottom: 1.5rem; right: 1.5rem; z-index: 9999; display: flex; flex-direction: column; gap: 0.625rem; pointer-events: none; }
        .toast { display: flex; align-items: flex-start; gap: 0.75rem; background: #1e293b; border: 1px solid rgba(255,255,255,0.1); border-radius: 0.75rem; padding: 1rem 1.25rem; min-width: 280px; max-width: 360px; box-shadow: 0 8px 32px rgba(0,0,0,0.4); pointer-events: all; animation: toastIn 0.35s cubic-bezier(0.34,1.56,0.64,1); position: relative; overflow: hidden; }
        .toast.removing { animation: toastOut 0.3s ease forwards; }
        @keyframes toastIn { from { opacity: 0; transform: translateX(100%); } to { opacity: 1; transform: translateX(0); } }
        @keyframes toastOut { from { opacity: 1; } to { opacity: 0; transform: translateX(120%); } }
        .toast-icon { font-size: 1.25rem; flex-shrink: 0; margin-top: 1px; }
        .toast-body .toast-title { font-size: 0.875rem; font-weight: 700; color: #f8fafc; margin-bottom: 0.15rem; }
        .toast-body .toast-msg { font-size: 0.78rem; color: #94a3b8; line-height: 1.4; }
        .toast-close { position: absolute; top: 0.5rem; right: 0.5rem; background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 0.8rem; padding: 0.1rem 0.3rem; }
        .toast-progress { position: absolute; bottom: 0; left: 0; height: 3px; border-radius: 0 0 0.75rem 0.75rem; animation: toastProg 4s linear forwards; }
        .toast-success .toast-progress { background: #22c55e; }
        .toast-error .toast-progress { background: #ef4444; }
        .toast-info .toast-progress { background: #818cf8; }
        @keyframes toastProg { from { width: 100%; } to { width: 0%; } }

        /* ─── CARDS ─── */
        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); margin-bottom: 1.75rem; overflow: hidden; border-top: 4px solid var(--primary); transition: background 0.3s; }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .card-title { font-size: 1rem; font-weight: 700; color: var(--text); }
        .card-body { padding: 1.5rem; }

        /* ─── BOOKING FORM ─── */
        .field-group { margin-bottom: 1.25rem; }
        .field-group label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem; }
        .field-input { width: 100%; padding: 0.8rem 1rem; border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.9rem; color: var(--text-body); background: var(--bg); transition: all 0.2s; }
        .field-input:focus { outline: none; border-color: var(--primary); background: var(--surface); box-shadow: 0 0 0 3px var(--primary-glow); }

        /* ─── SERVICE CARDS ─── */
        .services-label { font-size: 0.8rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.75rem; }
        .services-grid { display: flex; flex-wrap: wrap; gap: 0.625rem; margin-bottom: 1.25rem; }
        .service-card-label {
            display: flex; align-items: center; gap: 0.625rem;
            background: var(--bg); border: 2px solid var(--border);
            padding: 0.625rem 1rem; border-radius: 0.625rem;
            font-size: 0.825rem; cursor: pointer;
            transition: all 0.2s cubic-bezier(0.4,0,0.2,1);
            font-weight: 500; user-select: none;
        }
        .service-card-label:hover { border-color: var(--primary); background: rgba(129,140,248,0.05); }
        .service-card-label input[type="checkbox"] { display: none; }
        .check-icon { width: 18px; height: 18px; border: 2px solid var(--border); border-radius: 4px; display: flex; align-items: center; justify-content: center; transition: all 0.2s; flex-shrink: 0; font-size: 0.7rem; color: transparent; }
        .service-card-label:has(input:checked) .check-icon { background: var(--primary); border-color: var(--primary); color: white; }
        .service-card-label:has(input:checked) { border-color: var(--primary); background: rgba(129,140,248,0.08); }

        /* ─── LIVE COST CALCULATOR ─── */
        .cost-calculator {
            background: linear-gradient(135deg, var(--sidebar-bg), #2e1b6b);
            border-radius: 0.875rem; padding: 1.25rem 1.5rem; margin-bottom: 1.25rem;
            transition: all 0.3s ease;
        }
        .cost-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.75rem; }
        .cost-header-title { font-size: 0.78rem; font-weight: 700; color: rgba(199,210,254,0.7); text-transform: uppercase; letter-spacing: 0.08em; }
        .cost-total { font-size: 1.5rem; font-weight: 800; color: var(--primary); transition: transform 0.3s ease; }
        .cost-total.bump { animation: bump 0.3s ease; }
        @keyframes bump { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.15); } }
        .cost-items { display: flex; flex-direction: column; gap: 0.375rem; }
        .cost-item { display: flex; justify-content: space-between; font-size: 0.8rem; }
        .cost-item-name { color: rgba(199,210,254,0.75); }
        .cost-item-price { color: rgba(199,210,254,0.9); font-weight: 600; }
        .cost-empty { font-size: 0.8rem; color: rgba(199,210,254,0.4); font-style: italic; }
        .cost-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 0.75rem 0; }

        /* ─── SUBMIT BUTTON ─── */
        .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.7rem 1.25rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .btn-primary { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; width: 100%; justify-content: center; font-size: 0.95rem; padding: 0.875rem; box-shadow: 0 2px 12px var(--primary-glow); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 20px var(--primary-glow); }
        .btn-view { background: transparent; border: 1.5px solid var(--primary); color: var(--primary); font-size: 0.8rem; padding: 0.4rem 0.875rem; }
        .btn-view:hover { background: var(--primary); color: white; }

        /* ─── TABLE ─── */
        .table-wrap { overflow-x: auto; }
        .table-search { padding: 0.75rem 1rem; border-bottom: 1px solid var(--border); }
        .search-input { width: 100%; padding: 0.6rem 1rem 0.6rem 2.25rem; background: var(--bg); border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; color: var(--text-body); background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Ccircle cx='11' cy='11' r='8'/%3E%3Cpath d='m21 21-4.35-4.35'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: 0.75rem center; transition: all 0.2s; }
        .search-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-glow); }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: var(--bg); }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid var(--border); vertical-align: middle; color: var(--text-body); }
        tbody tr:hover { background: rgba(129,140,248,0.03); }
        tbody tr:last-child td { border-bottom: none; }

        /* ─── BADGES ─── */
        .badge { display: inline-flex; align-items: center; gap: 0.3rem; padding: 0.3rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600; }
        .badge-pending { background: #fef3c7; color: #d97706; }
        .badge-approved { background: #dcfce7; color: #16a34a; }
        .badge-rejected { background: #fee2e2; color: #dc2626; }
        .badge-paid { background: #dcfce7; color: #16a34a; }
        .badge-unpaid { background: #fee2e2; color: #dc2626; }

        /* ─── COUNTDOWN BADGE ─── */
        .countdown-badge { display: inline-flex; align-items: center; gap: 0.25rem; font-size: 0.7rem; font-weight: 600; padding: 0.2rem 0.5rem; border-radius: 0.375rem; margin-top: 0.25rem; }
        .countdown-today { background: #fef3c7; color: #d97706; }
        .countdown-soon { background: #dcfce7; color: #16a34a; }
        .countdown-past { background: #f1f5f9; color: #94a3b8; }
        .countdown-upcoming { background: #e0f2fe; color: #0369a1; }

        .empty-state { text-align: center; padding: 2.5rem; color: var(--text-muted); }
        .empty-icon { font-size: 2.5rem; margin-bottom: 0.75rem; opacity: 0.4; }
        .inv-id { font-weight: 700; color: var(--primary); }
        .date-main { font-weight: 600; }
        .time-sub { font-size: 0.75rem; color: var(--text-muted); }
    </style>
</head>
<body>

    <!-- TOAST CONTAINER -->
    <div class="toast-container" id="toastContainer"></div>

    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo">🦷</div>
            <div class="brand-name">Sunrise Dental</div>
            <div class="brand-role">Patient Portal</div>
        </div>
        <div class="patient-profile">
            <div class="pat-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "P" %></div>
            <div>
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
            <div class="topbar-actions">
                <button class="dark-toggle" id="darkToggle" onclick="toggleDark()" title="Toggle dark mode">🌙</button>
                <div class="user-badge">
                    <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "P" %></div>
                    <span class="user-name"><%= user.getName() %></span>
                </div>
            </div>
        </header>

        <div class="content">

            <!-- FLASH MESSAGES -->
            <%
                String qSuccess = request.getParameter("success");
                String qError = request.getParameter("error");
            %>

            <!-- BOOK APPOINTMENT -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">📅 Book an Appointment</div>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/api/secure/patient/book" method="POST" id="bookingForm">
                        <div class="field-group">
                            <label>Select Doctor &amp; Time Slot</label>
                            <select name="availability_id" class="field-input" required id="doctorSelect" onchange="updateCost()">
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
                        <div class="services-grid" id="servicesGrid">
                            <% if (services != null) {
                                for (Map<String, Object> s : services) { %>
                            <label class="service-card-label">
                                <input type="checkbox" name="services" value="<%= s.get("id") %>"
                                    data-name="<%= s.get("name") %>"
                                    data-cost="<%= s.get("cost") %>"
                                    onchange="updateCost()">
                                <span class="check-icon">✓</span>
                                <span><%= s.get("name") %> <strong style="color:var(--primary);">LKR <%= s.get("cost") %></strong></span>
                            </label>
                            <%  } } %>
                        </div>

                        <!-- LIVE COST CALCULATOR -->
                        <div class="cost-calculator">
                            <div class="cost-header">
                                <div class="cost-header-title">💰 Estimated Total</div>
                                <div class="cost-total" id="costTotal">LKR 0.00</div>
                            </div>
                            <div class="cost-items" id="costItems">
                                <div class="cost-empty">Select services to see price breakdown</div>
                            </div>
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
                <div class="table-search">
                    <input type="text" class="search-input" placeholder="Search by doctor name or status..." oninput="filterTable('apptTable', this.value, [1,2])">
                </div>
                <div class="table-wrap">
                    <table id="apptTable">
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
                                    <% if ("APPROVED".equals(status)) { %>
                                    <span class="countdown-badge" data-date="<%= a.get("date") %>">⏳ calculating...</span>
                                    <% } %>
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
                                        <p>No appointments yet. Book one above!</p>
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
                <div class="table-search">
                    <input type="text" class="search-input" placeholder="Search by doctor or invoice ID..." oninput="filterTable('invTable', this.value, [0,1,2])">
                </div>
                <div class="table-wrap">
                    <table id="invTable">
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
                                <td><a href="<%=request.getContextPath()%>/printBill?id=<%= inv.get("id") %>" class="btn btn-view">🖨 View Bill</a></td>
                            </tr>
                            <%      }
                                } else { %>
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state"><div class="empty-icon">🧾</div><p>No invoices yet.</p></div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        /* ─── DARK MODE ─── */
        (function() {
            const saved = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', saved);
            document.getElementById('darkToggle').textContent = saved === 'dark' ? '☀️' : '🌙';
        })();
        function toggleDark() {
            const current = document.documentElement.getAttribute('data-theme');
            const next = current === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            document.getElementById('darkToggle').textContent = next === 'dark' ? '☀️' : '🌙';
            showToast(next === 'dark' ? 'Dark Mode On' : 'Light Mode On', 'Theme saved to preferences.', 'info');
        }

        /* ─── LIVE COST CALCULATOR ─── */
        function updateCost() {
            const checkboxes = document.querySelectorAll('#servicesGrid input[type="checkbox"]:checked');
            const itemsEl = document.getElementById('costItems');
            const totalEl = document.getElementById('costTotal');
            let total = 0;
            const lines = [];
            checkboxes.forEach(cb => {
                const cost = parseFloat(cb.dataset.cost) || 0;
                total += cost;
                lines.push({ name: cb.dataset.name, cost });
            });
            // Animate total
            const prevVal = parseFloat(totalEl.textContent.replace('LKR ', '').replace(',', '')) || 0;
            animateValue(totalEl, prevVal, total, 400);
            totalEl.classList.add('bump');
            setTimeout(() => totalEl.classList.remove('bump'), 350);

            // Render line items
            if (lines.length === 0) {
                itemsEl.innerHTML = '<div class="cost-empty">Select services to see price breakdown</div>';
            } else {
                itemsEl.innerHTML = lines.map(l =>
                    '<div class="cost-item"><span class="cost-item-name">' + l.name + '</span><span class="cost-item-price">LKR ' + l.cost.toFixed(2) + '</span></div>'
                ).join('') + '<div class="cost-divider"></div>';
            }
        }
        function animateValue(el, from, to, duration) {
            const start = performance.now();
            function step(now) {
                const p = Math.min((now - start) / duration, 1);
                const eased = 1 - Math.pow(1 - p, 3);
                el.textContent = 'LKR ' + (from + (to - from) * eased).toFixed(2);
                if (p < 1) requestAnimationFrame(step);
                else el.textContent = 'LKR ' + to.toFixed(2);
            }
            requestAnimationFrame(step);
        }

        /* ─── TABLE SEARCH / FILTER ─── */
        function filterTable(tableId, query, colIndexes) {
            const q = query.toLowerCase().trim();
            const rows = document.querySelectorAll('#' + tableId + ' tbody tr');
            rows.forEach(row => {
                const text = colIndexes.map(i => (row.cells[i] ? row.cells[i].textContent : '')).join(' ').toLowerCase();
                row.style.display = !q || text.includes(q) ? '' : 'none';
            });
        }

        /* ─── APPOINTMENT COUNTDOWN ─── */
        function renderCountdowns() {
            document.querySelectorAll('[data-date]').forEach(el => {
                const dateStr = el.dataset.date;
                if (!dateStr) return;
                const apptDate = new Date(dateStr);
                const today = new Date();
                today.setHours(0,0,0,0);
                apptDate.setHours(0,0,0,0);
                const diff = Math.round((apptDate - today) / 86400000);
                if (diff === 0) {
                    el.className = 'countdown-badge countdown-today';
                    el.textContent = '🌟 Today!';
                } else if (diff > 0 && diff <= 7) {
                    el.className = 'countdown-badge countdown-soon';
                    el.textContent = '✅ In ' + diff + ' day' + (diff > 1 ? 's' : '');
                } else if (diff > 7) {
                    el.className = 'countdown-badge countdown-upcoming';
                    el.textContent = '📅 In ' + diff + ' days';
                } else {
                    el.className = 'countdown-badge countdown-past';
                    el.textContent = Math.abs(diff) + ' day' + (Math.abs(diff) > 1 ? 's' : '') + ' ago';
                }
            });
        }

        /* ─── TOAST ─── */
        function showToast(title, msg, type = 'info') {
            const icons = { success: '✅', error: '❌', info: 'ℹ️' };
            const c = document.getElementById('toastContainer');
            const t = document.createElement('div');
            t.className = 'toast toast-' + type;
            t.innerHTML = '<div class="toast-icon">' + (icons[type]||'ℹ️') + '</div><div class="toast-body"><div class="toast-title">' + title + '</div><div class="toast-msg">' + msg + '</div></div><button class="toast-close" onclick="this.parentElement.classList.add(\'removing\');setTimeout(()=>this.parentElement.remove(),300)">✕</button><div class="toast-progress"></div>';
            c.appendChild(t);
            setTimeout(() => { t.classList.add('removing'); setTimeout(() => t.remove(), 300); }, 4200);
        }

        /* ─── INIT ─── */
        window.addEventListener('DOMContentLoaded', () => {
            renderCountdowns();
            <% if ("true".equals(qSuccess)) { %>
            showToast('Appointment Booked!', 'Your appointment has been submitted for approval.', 'success');
            <% } %>
            <% if (qError != null) { %>
            showToast('Booking Failed', 'There was an issue booking your appointment. Please try again.', 'error');
            <% } %>
        });
    </script>
</body>
</html>
