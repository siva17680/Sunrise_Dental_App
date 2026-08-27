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
    <title>Manage Appointments | Sunrise Dental Admin</title>
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

        /* Stats */
        .stats-row { display: flex; gap: 1rem; margin-bottom: 1.75rem; }
        .stat-card { background: var(--surface); border-radius: 0.875rem; padding: 1.25rem 1.5rem; flex: 1; box-shadow: 0 1px 3px rgba(0,0,0,0.06); display: flex; align-items: center; gap: 1rem; }
        .stat-icon { font-size: 1.75rem; }
        .stat-value { font-size: 1.75rem; font-weight: 800; line-height: 1; }
        .stat-label { font-size: 0.78rem; color: var(--text-muted); font-weight: 500; margin-top: 0.2rem; }

        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); overflow: hidden; }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .card-title { font-size: 1rem; font-weight: 700; }

        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        tbody tr:hover { background: #fafbfc; }
        tbody tr:last-child td { border-bottom: none; }

        .badge { display: inline-flex; align-items: center; padding: 0.3rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600; }
        .badge-pending { background: #fef3c7; color: #d97706; }
        .badge-approved { background: #dcfce7; color: #16a34a; }
        .badge-rejected { background: #fee2e2; color: #dc2626; }
        .badge-completed { background: #e0f2fe; color: #0284c7; }

        .action-buttons { display: flex; gap: 0.5rem; }
        .btn { display: inline-flex; align-items: center; gap: 0.35rem; padding: 0.45rem 0.875rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.8rem; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .btn-approve { background: linear-gradient(135deg, #22c55e, #16a34a); color: white; }
        .btn-approve:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(34,197,94,0.3); }
        .btn-reject { background: linear-gradient(135deg, #f87171, #ef4444); color: white; }
        .btn-reject:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(239,68,68,0.3); }
        form { display: inline; }

        .empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
        .empty-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }

        .appt-id { font-weight: 600; color: var(--text-muted); }
        .patient-name { font-weight: 600; }
        .doctor-name { color: var(--text-muted); }
        .date-time .time-sub { font-size: 0.75rem; color: var(--text-muted); }
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
            <a href="<%=request.getContextPath()%>/adminAppointments" class="nav-item active"><span class="nav-icon">📅</span> Appointments</a>
            <a href="<%=request.getContextPath()%>/adminBilling" class="nav-item"><span class="nav-icon">💳</span> Billing</a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=request.getContextPath()%>/api/logout" class="nav-item logout"><span class="nav-icon">🚪</span> Logout</a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h2>Manage Appointments</h2>
                <div class="breadcrumb">Admin Dashboard › Appointments</div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "A" %></div>
                <span class="user-name"><%= user.getName() %></span>
            </div>
        </header>

        <div class="content">
            <%
                int total = appointments != null ? appointments.size() : 0;
                int pending = 0, approved = 0, rejected = 0;
                if (appointments != null) {
                    for (Map<String,Object> a : appointments) {
                        String s = (String) a.get("status");
                        if ("PENDING".equals(s)) pending++;
                        else if ("APPROVED".equals(s)) approved++;
                        else if ("REJECTED".equals(s)) rejected++;
                    }
                }
            %>
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon">📅</div>
                    <div>
                        <div class="stat-value"><%= total %></div>
                        <div class="stat-label">Total Appointments</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">⏳</div>
                    <div>
                        <div class="stat-value" style="color:#d97706;"><%= pending %></div>
                        <div class="stat-label">Pending Review</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div>
                        <div class="stat-value" style="color:#16a34a;"><%= approved %></div>
                        <div class="stat-label">Approved</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">❌</div>
                    <div>
                        <div class="stat-value" style="color:#dc2626;"><%= rejected %></div>
                        <div class="stat-label">Rejected</div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-title">📋 All Appointments</div>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date &amp; Time</th>
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
                                    String badgeClass = "PENDING".equals(status) ? "badge-pending" :
                                                        "APPROVED".equals(status) ? "badge-approved" :
                                                        "REJECTED".equals(status) ? "badge-rejected" : "badge-completed";
                            %>
                            <tr>
                                <td class="appt-id">#<%= a.get("id") %></td>
                                <td class="date-time">
                                    <%= a.get("date") %>
                                    <div class="time-sub"><%= a.get("time") %></div>
                                </td>
                                <td class="patient-name"><%= a.get("patient") %></td>
                                <td class="doctor-name"><%= a.get("doctor") %></td>
                                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                <td>
                                    <% if ("PENDING".equals(status)) { %>
                                    <div class="action-buttons">
                                        <form action="<%=request.getContextPath()%>/adminAppointments" method="POST">
                                            <input type="hidden" name="id" value="<%= a.get("id") %>">
                                            <button type="submit" name="action" value="approve" class="btn btn-approve">✓ Approve</button>
                                            <button type="submit" name="action" value="reject" class="btn btn-reject">✕ Reject</button>
                                        </form>
                                    </div>
                                    <% } else { %>
                                    <span style="color:var(--text-muted); font-size:0.85rem;">—</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%  } } else { %>
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <div class="empty-icon">📭</div>
                                        <p>No appointments found.</p>
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
