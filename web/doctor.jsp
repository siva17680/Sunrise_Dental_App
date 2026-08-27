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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #052e16;
            --primary: #4ade80;
            --primary-dark: #22c55e;
            --primary-glow: rgba(74,222,128,0.25);
            --bg: #f0fdf4;
            --surface: #ffffff;
            --text: #14532d;
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
        .brand-role { font-size: 0.72rem; color: rgba(187,247,208,0.7); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em; }
        .sidebar-nav { flex: 1; padding: 1rem 0.75rem; display: flex; flex-direction: column; gap: 0.25rem; }
        .nav-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; color: rgba(187,247,208,0.8); text-decoration: none; border-radius: 0.625rem; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .nav-item:hover { background: rgba(74,222,128,0.1); color: #bbf7d0; border-left-color: rgba(74,222,128,0.5); }
        .nav-item.active { background: rgba(74,222,128,0.15); color: var(--primary); border-left-color: var(--primary); font-weight: 600; }
        .nav-item .nav-icon { font-size: 1.1rem; flex-shrink: 0; }
        .sidebar-footer { padding: 1rem 0.75rem; border-top: 1px solid rgba(255,255,255,0.08); }
        .nav-item.logout { color: rgba(248,113,113,0.8); }
        .nav-item.logout:hover { background: rgba(239,68,68,0.1); color: #f87171; border-left-color: #f87171; }

        /* DOCTOR AVATAR in sidebar */
        .doctor-profile { padding: 1.25rem 1.5rem; border-bottom: 1px solid rgba(255,255,255,0.08); display: flex; align-items: center; gap: 0.75rem; }
        .doc-avatar { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 1rem; font-weight: 700; color: #052e16; flex-shrink: 0; }
        .doc-info .doc-name { font-size: 0.85rem; font-weight: 600; color: #f0fdf4; }
        .doc-info .doc-label { font-size: 0.72rem; color: rgba(187,247,208,0.6); }

        .main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .topbar-left h2 { font-size: 1.4rem; font-weight: 700; color: var(--text); }
        .topbar-left .breadcrumb { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.15rem; }
        .user-badge { display: flex; align-items: center; gap: 0.625rem; background: var(--bg); padding: 0.5rem 0.875rem; border-radius: 2rem; border: 1px solid #bbf7d0; }
        .user-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; color: #052e16; }
        .user-name { font-size: 0.85rem; font-weight: 600; color: var(--text); }

        .content { padding: 2rem; flex: 1; }

        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); margin-bottom: 1.75rem; overflow: hidden; border-top: 4px solid var(--primary); }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); }
        .card-title { font-size: 1rem; font-weight: 700; color: var(--text); }
        .card-body { padding: 1.5rem; }

        /* AVAILABILITY FORM */
        .avail-form { display: flex; gap: 0.75rem; align-items: flex-end; flex-wrap: wrap; }
        .field-group { flex: 1; min-width: 140px; }
        .field-group label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem; }
        .field-input { width: 100%; padding: 0.7rem 0.875rem; border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; color: var(--text-body); background: #f8fafc; transition: all 0.2s; }
        .field-input:focus { outline: none; border-color: var(--primary); background: white; box-shadow: 0 0 0 3px var(--primary-glow); }

        /* TABLE */
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        tbody tr:hover { background: #f0fdf4; }
        tbody tr:last-child td { border-bottom: none; }

        /* BADGES */
        .type-guest { background: #fef3c7; color: #b45309; padding: 0.25rem 0.625rem; border-radius: 2rem; font-size: 0.72rem; font-weight: 600; }
        .type-registered { background: #dcfce7; color: #166534; padding: 0.25rem 0.625rem; border-radius: 2rem; font-size: 0.72rem; font-weight: 600; }
        .history-cell { max-width: 200px; font-size: 0.8rem; color: var(--text-muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.7rem 1.25rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; white-space: nowrap; }
        .btn-primary { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: #052e16; box-shadow: 0 2px 8px var(--primary-glow); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 16px var(--primary-glow); }
        .btn-prescribe { background: linear-gradient(135deg, #fbbf24, #f59e0b); color: #78350f; }
        .btn-prescribe:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(251,191,36,0.3); }

        .empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
        .empty-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }
        .date-main { font-weight: 600; }
        .time-sub { font-size: 0.75rem; color: var(--text-muted); }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo">🦷</div>
            <div class="brand-name">Dr. Portal</div>
            <div class="brand-role">Doctor Dashboard</div>
        </div>
        <div class="doctor-profile">
            <div class="doc-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "D" %></div>
            <div class="doc-info">
                <div class="doc-name">Dr. <%= user.getName() %></div>
                <div class="doc-label">Attending Physician</div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%=request.getContextPath()%>/doctorDashboard" class="nav-item active"><span class="nav-icon">🩺</span> My Patients</a>
            <a href="#availability-section" class="nav-item"><span class="nav-icon">📅</span> Set Availability</a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=request.getContextPath()%>/api/logout" class="nav-item logout"><span class="nav-icon">🚪</span> Logout</a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h2>Doctor Dashboard</h2>
                <div class="breadcrumb">Dr. Portal › My Patients &amp; Availability</div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "D" %></div>
                <span class="user-name">Dr. <%= user.getName() %></span>
            </div>
        </header>

        <div class="content">
            <!-- ADD AVAILABILITY -->
            <div class="card" id="availability-section">
                <div class="card-header">
                    <div class="card-title">📅 Add Availability Slot</div>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/api/secure/doctor/availability" method="POST" class="avail-form">
                        <div class="field-group">
                            <label>Date</label>
                            <input type="date" name="date" class="field-input" required>
                        </div>
                        <div class="field-group">
                            <label>Start Time</label>
                            <input type="time" name="start_time" class="field-input" required>
                        </div>
                        <div class="field-group">
                            <label>End Time</label>
                            <input type="time" name="end_time" class="field-input" required>
                        </div>
                        <div class="field-group" style="flex:0;">
                            <label>&nbsp;</label>
                            <button type="submit" class="btn btn-primary">Add Slot ➕</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- PATIENT APPOINTMENTS -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">🩺 My Patients — Appointments &amp; Guests</div>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Date &amp; Time</th>
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
                                <td>
                                    <div class="date-main"><%= a.get("date") %></div>
                                    <div class="time-sub"><%= a.get("time") %></div>
                                </td>
                                <td>
                                    <% if (isGuest) { %>
                                    <span class="type-guest">👤 Guest</span>
                                    <% } else { %>
                                    <span class="type-registered">✅ Registered</span>
                                    <% } %>
                                </td>
                                <td style="font-weight:600;"><%= a.get("patient_name") %></td>
                                <td class="history-cell" title="<%= a.get("history") %>"><%= a.get("history") %></td>
                                <td>
                                    <a href="<%= actionUrl %>" class="btn btn-prescribe">💊 Prescribe</a>
                                </td>
                            </tr>
                            <%  }
                               } else { %>
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <div class="empty-icon">🩺</div>
                                        <p>No appointments found for today.</p>
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
