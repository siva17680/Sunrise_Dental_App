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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #2e1065;
            --primary: #c084fc;
            --primary-dark: #a855f7;
            --primary-glow: rgba(192,132,252,0.25);
            --bg: #faf5ff;
            --surface: #ffffff;
            --text: #2e1065;
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
        .brand-role { font-size: 0.72rem; color: rgba(233,213,255,0.7); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em; }
        .pharm-profile { padding: 1.25rem 1.5rem; border-bottom: 1px solid rgba(255,255,255,0.08); display: flex; align-items: center; gap: 0.75rem; }
        .ph-avatar { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 1rem; font-weight: 700; color: white; flex-shrink: 0; }
        .ph-info .ph-name { font-size: 0.85rem; font-weight: 600; color: #faf5ff; }
        .ph-info .ph-label { font-size: 0.72rem; color: rgba(233,213,255,0.6); }
        .sidebar-nav { flex: 1; padding: 1rem 0.75rem; display: flex; flex-direction: column; gap: 0.25rem; }
        .nav-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; color: rgba(233,213,255,0.8); text-decoration: none; border-radius: 0.625rem; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .nav-item:hover { background: rgba(192,132,252,0.1); color: #e9d5ff; border-left-color: rgba(192,132,252,0.5); }
        .nav-item.active { background: rgba(192,132,252,0.18); color: var(--primary); border-left-color: var(--primary); font-weight: 600; }
        .nav-item .nav-icon { font-size: 1.1rem; flex-shrink: 0; }
        .sidebar-footer { padding: 1rem 0.75rem; border-top: 1px solid rgba(255,255,255,0.08); }
        .nav-item.logout { color: rgba(248,113,113,0.8); }
        .nav-item.logout:hover { background: rgba(239,68,68,0.1); color: #f87171; border-left-color: #f87171; }

        .main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .topbar-left h2 { font-size: 1.4rem; font-weight: 700; color: var(--text); }
        .topbar-left .breadcrumb { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.15rem; }
        .user-badge { display: flex; align-items: center; gap: 0.625rem; background: var(--bg); padding: 0.5rem 0.875rem; border-radius: 2rem; border: 1px solid #e9d5ff; }
        .user-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; color: white; }
        .user-name { font-size: 0.85rem; font-weight: 600; color: var(--text); }

        .content { padding: 2rem; flex: 1; }

        /* STAT BANNER */
        .stat-banner { background: linear-gradient(135deg, var(--sidebar-bg), var(--text)); border-radius: 1rem; padding: 1.5rem 2rem; margin-bottom: 1.75rem; display: flex; align-items: center; justify-content: space-between; color: white; }
        .stat-banner-left .label { font-size: 0.78rem; color: rgba(255,255,255,0.6); text-transform: uppercase; letter-spacing: 0.08em; font-weight: 600; margin-bottom: 0.25rem; }
        .stat-banner-left .count { font-size: 2.5rem; font-weight: 800; color: var(--primary); line-height: 1; }
        .stat-banner-right { font-size: 3rem; opacity: 0.5; }

        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); overflow: hidden; border-top: 4px solid var(--primary); }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); }
        .card-title { font-size: 1rem; font-weight: 700; color: var(--text); }

        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #faf5ff; }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid #f3f0ff; vertical-align: middle; }
        tbody tr:hover { background: #faf5ff; }
        tbody tr:last-child td { border-bottom: none; }

        .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.8rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .btn-process { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; }
        .btn-process:hover { transform: translateY(-1px); box-shadow: 0 4px 12px var(--primary-glow); }

        .empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
        .empty-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }
        .inv-id { font-weight: 700; color: var(--primary); }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo">💊</div>
            <div class="brand-name">Pharmacy</div>
            <div class="brand-role">Pharmacist Portal</div>
        </div>
        <div class="pharm-profile">
            <div class="ph-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "P" %></div>
            <div class="ph-info">
                <div class="ph-name"><%= user.getName() %></div>
                <div class="ph-label">Pharmacist</div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%=request.getContextPath()%>/pharmacistDashboard" class="nav-item active"><span class="nav-icon">💊</span> Prescriptions</a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=request.getContextPath()%>/api/logout" class="nav-item logout"><span class="nav-icon">🚪</span> Logout</a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h2>Pharmacy Dashboard</h2>
                <div class="breadcrumb">Pharmacist Portal › Pending Prescriptions</div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "P" %></div>
                <span class="user-name"><%= user.getName() %></span>
            </div>
        </header>

        <div class="content">
            <div class="stat-banner">
                <div class="stat-banner-left">
                    <div class="label">Pending Prescriptions</div>
                    <div class="count"><%= prescriptions != null ? prescriptions.size() : 0 %></div>
                </div>
                <div class="stat-banner-right">💊</div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-title">📋 Recent Prescriptions</div>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Date Issued</th>
                                <th>Invoice</th>
                                <th>Patient Name</th>
                                <th>Doctor</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (prescriptions != null && !prescriptions.isEmpty()) {
                                for (Map<String, Object> p : prescriptions) { %>
                            <tr>
                                <td style="color:var(--text-muted);"><%= p.get("date") %></td>
                                <td class="inv-id">#INV-<%= p.get("invoice_id") %></td>
                                <td style="font-weight:600;"><%= p.get("patient") %></td>
                                <td style="color:var(--text-muted);">Dr. <%= p.get("doctor") %></td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/pharmacistProcess?id=<%= p.get("id") %>" class="btn btn-process">💊 Process</a>
                                </td>
                            </tr>
                            <%  }
                               } else { %>
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <div class="empty-icon">✅</div>
                                        <p>No pending prescriptions — all clear!</p>
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
