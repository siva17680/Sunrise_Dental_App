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
    <title>Doctor Schedules | Sunrise Dental Admin</title>
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

        .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; margin-bottom: 0.75rem; }
        .field-group label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem; }
        .field-input { width: 100%; padding: 0.7rem 0.875rem; border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; color: var(--text); background: #f8fafc; transition: all 0.2s; }
        .field-input:focus { outline: none; border-color: var(--primary); background: white; box-shadow: 0 0 0 3px var(--primary-glow); }

        .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.7rem 1.5rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .btn-primary { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: #0a0f1e; box-shadow: 0 2px 8px var(--primary-glow); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 16px var(--primary-glow); }

        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        tbody tr:hover { background: #fafbfc; }
        tbody tr:last-child td { border-bottom: none; }

        .spec-badge { display: inline-flex; align-items: center; padding: 0.25rem 0.625rem; border-radius: 2rem; font-size: 0.72rem; font-weight: 600; background: #e0f2fe; color: #0369a1; }
        .time-pill { display: inline-flex; align-items: center; gap: 0.3rem; background: #f1f5f9; padding: 0.2rem 0.5rem; border-radius: 0.35rem; font-size: 0.8rem; font-weight: 500; color: var(--text); }

        .empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
        .empty-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }
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
            <a href="<%=request.getContextPath()%>/adminDoctors" class="nav-item active"><span class="nav-icon">👨‍⚕️</span> Doctor Schedules</a>
            <a href="<%=request.getContextPath()%>/adminAppointments" class="nav-item"><span class="nav-icon">📅</span> Appointments</a>
            <a href="<%=request.getContextPath()%>/adminBilling" class="nav-item"><span class="nav-icon">💳</span> Billing</a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=request.getContextPath()%>/api/logout" class="nav-item logout"><span class="nav-icon">🚪</span> Logout</a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h2>Doctor Management</h2>
                <div class="breadcrumb">Admin Dashboard › Doctor Schedules</div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "A" %></div>
                <span class="user-name"><%= user.getName() %></span>
            </div>
        </header>

        <div class="content">
            <!-- ADD DOCTOR FORM -->
            <div class="card">
                <div class="card-header">
                    <div class="card-header-accent"></div>
                    <div class="card-title">➕ Add New Doctor Account</div>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/adminDoctors" method="POST">
                        <div class="form-grid-2">
                            <div class="field-group">
                                <label>Doctor Full Name</label>
                                <input type="text" name="name" class="field-input" placeholder="Dr. Full Name" required>
                            </div>
                            <div class="field-group">
                                <label>Specialization</label>
                                <input type="text" name="specialization" class="field-input" placeholder="e.g. Orthodontist" required>
                            </div>
                        </div>
                        <div class="form-grid-2">
                            <div class="field-group">
                                <label>Login Username</label>
                                <input type="text" name="username" class="field-input" placeholder="Login username" required autocomplete="off">
                            </div>
                            <div class="field-group">
                                <label>Login Password</label>
                                <input type="password" name="password" class="field-input" placeholder="Secure password" required autocomplete="new-password">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary" style="margin-top:0.5rem;">👨‍⚕️ Create Doctor Account</button>
                    </form>
                </div>
            </div>

            <!-- DOCTOR SCHEDULES TABLE -->
            <div class="card">
                <div class="card-header">
                    <div class="card-header-accent"></div>
                    <div class="card-title">📅 Doctor Availability Schedules</div>
                </div>
                <div class="table-wrap">
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
                                <td style="font-weight:600;"><%= s.get("date") %></td>
                                <td><span class="time-pill">🕐 <%= s.get("start") %></span></td>
                                <td><span class="time-pill">🕓 <%= s.get("end") %></span></td>
                                <td style="font-weight:600;">Dr. <%= s.get("doctor") %></td>
                                <td><span class="spec-badge"><%= s.get("specialization") %></span></td>
                            </tr>
                            <%  } } else { %>
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <div class="empty-icon">📭</div>
                                        <p>No doctor schedules available yet.</p>
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
