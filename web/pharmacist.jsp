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
<html lang="en" data-theme="light">
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
        }
        [data-theme="dark"] {
            --bg: #120d1f;
            --surface: #1a1427;
            --text: #e9d5ff;
            --text-body: #d4d4d8;
            --text-muted: #71717a;
            --border: #2d2040;
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
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.05); transition: background 0.3s; }
        .topbar-actions { display: flex; align-items: center; gap: 0.75rem; }
        .dark-toggle { background: var(--bg); border: 1px solid var(--border); border-radius: 0.5rem; padding: 0.5rem 0.75rem; cursor: pointer; font-size: 1rem; transition: all 0.2s; }
        .dark-toggle:hover { border-color: var(--primary); }
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

        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); overflow: hidden; border-top: 4px solid var(--primary); transition: background 0.3s; }
        /* TABLE SEARCH */
        .table-search { padding: 0.75rem 1rem; border-bottom: 1px solid var(--border); }
        .search-input { width: 100%; padding: 0.6rem 1rem 0.6rem 2.25rem; background: var(--bg); border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; color: var(--text-body); background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Ccircle cx='11' cy='11' r='8'/%3E%3Cpath d='m21 21-4.35-4.35'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: 0.75rem center; transition: all 0.2s; }
        .search-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-glow); }
        /* TOAST */
        .toast-container { position: fixed; bottom: 1.5rem; right: 1.5rem; z-index: 9999; display: flex; flex-direction: column; gap: 0.625rem; pointer-events: none; }
        .toast { display: flex; align-items: flex-start; gap: 0.75rem; background: #1e293b; border: 1px solid rgba(255,255,255,0.1); border-radius: 0.75rem; padding: 1rem 1.25rem; min-width: 280px; max-width: 360px; box-shadow: 0 8px 32px rgba(0,0,0,0.4); pointer-events: all; animation: toastIn 0.35s cubic-bezier(0.34,1.56,0.64,1); position: relative; overflow: hidden; }
        .toast.removing { animation: toastOut 0.3s ease forwards; }
        @keyframes toastIn { from { opacity: 0; transform: translateX(100%); } to { opacity: 1; transform: translateX(0); } }
        @keyframes toastOut { from { opacity: 1; } to { opacity: 0; transform: translateX(120%); } }
        .toast-icon { font-size: 1.25rem; flex-shrink: 0; }
        .toast-title { font-size: 0.875rem; font-weight: 700; color: #f8fafc; }
        .toast-msg { font-size: 0.78rem; color: #94a3b8; }
        .toast-close { position: absolute; top: 0.5rem; right: 0.5rem; background: none; border: none; color: #94a3b8; cursor: pointer; font-size: 0.8rem; padding: 0.1rem 0.3rem; }
        .toast-progress { position: absolute; bottom: 0; left: 0; height: 3px; border-radius: 0 0 0.75rem 0.75rem; animation: toastProg 4s linear forwards; }
        .toast-info .toast-progress { background: var(--primary); }
        @keyframes toastProg { from { width: 100%; } to { width: 0%; } }
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
            body { transition: background 0.3s; }
        td { color: var(--text-body); }
        thead tr { background: var(--bg); }
        tbody tr:hover { background: rgba(192,132,252,0.03); }
        th { color: var(--text-muted); border-bottom: 1px solid var(--border); }
        td { border-bottom: 1px solid var(--border); }
    </style>
</head>
<body>
    <div class="toast-container" id="toastContainer"></div>
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
            <div class="topbar-actions">
                <button class="dark-toggle" id="darkToggle" onclick="toggleDark()">🌙</button>
                <div class="user-badge">
                    <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "P" %></div>
                    <span class="user-name"><%= user.getName() %></span>
                </div>
            </div>
        </header>

        <div class="content">
            <div class="stat-banner">
                <div class="stat-banner-left">

                    <div class="label">Pending Prescriptions</div>

                    <div class="count" id="pendingCount" data-target="<%= prescriptions != null ? prescriptions.size() : 0 %>">0</div>
                </div>
                <div class="stat-banner-right">💊</div>
            </div>

            <div class="card">
                <div class="table-search">
                    <input type="text" class="search-input" placeholder="Search by patient, doctor or invoice..." oninput="filterTable(this.value)">
                </div>
                <div class="card-header">
                    <div class="card-title">📋 Recent Prescriptions</div>
                </div>
                <div class="table-wrap">
                    <table id="pharmTable">
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
    <script>
        (function() {
            const saved = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', saved);
            document.getElementById('darkToggle').textContent = saved === 'dark' ? '☀️' : '🌙';
        })();
        function toggleDark() {
            const curr = document.documentElement.getAttribute('data-theme');
            const next = curr === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            document.getElementById('darkToggle').textContent = next === 'dark' ? '☀️' : '🌙';
        }
        function filterTable(q) {
            q = q.toLowerCase();
            document.querySelectorAll('#pharmTable tbody tr').forEach(row => {
                row.style.display = !q || row.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        }
        function animateCounter(el, target) {
            const start = performance.now();
            function step(now) {
                const p = Math.min((now - start) / 1200, 1);
                el.textContent = Math.round((1 - Math.pow(1 - p, 3)) * target);
                if (p < 1) requestAnimationFrame(step);
            }
            requestAnimationFrame(step);
        }
        window.addEventListener('DOMContentLoaded', () => {
            const el = document.getElementById('pendingCount');
            if (el) animateCounter(el, parseInt(el.dataset.target));
        });
    </script>
</body>
</html>
