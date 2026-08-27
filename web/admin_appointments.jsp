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
    int total = appointments != null ? appointments.size() : 0;
    int pending = 0, approved = 0, rejected = 0;
    if (appointments != null) {
        for (Map<String, Object> a : appointments) {
            String s = (String) a.get("status");
            if ("PENDING".equals(s)) pending++;
            else if ("APPROVED".equals(s)) approved++;
            else if ("REJECTED".equals(s)) rejected++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments | Sunrise Dental Admin</title>
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
            --text-body: #1e293b;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        [data-theme="dark"] {
            --bg: #0b0f1a;
            --surface: #131929;
            --text: #e2e8f0;
            --text-body: #cbd5e1;
            --text-muted: #64748b;
            --border: #1e293b;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text-body); display: flex; min-height: 100vh; transition: background 0.3s; }

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
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.05); transition: background 0.3s; }
        .topbar-left h2 { font-size: 1.4rem; font-weight: 700; color: var(--text); }
        .topbar-left .breadcrumb { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.15rem; }
        .topbar-actions { display: flex; align-items: center; gap: 0.75rem; }
        .user-badge { display: flex; align-items: center; gap: 0.625rem; background: var(--bg); padding: 0.5rem 0.875rem; border-radius: 2rem; border: 1px solid var(--border); }
        .user-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; color: white; }
        .user-name { font-size: 0.85rem; font-weight: 600; color: var(--text); }
        .dark-toggle { background: var(--bg); border: 1px solid var(--border); border-radius: 0.5rem; padding: 0.5rem 0.75rem; cursor: pointer; font-size: 1rem; transition: all 0.2s; }
        .dark-toggle:hover { border-color: var(--primary); }

        .content { padding: 2rem; flex: 1; }

        /* ─── STAT CARDS ─── */
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 1.75rem; }
        .stat-card { background: var(--surface); border-radius: 0.875rem; padding: 1.25rem 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06); position: relative; overflow: hidden; transition: background 0.3s, transform 0.2s; border-left: 4px solid; }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-card-total { border-color: var(--primary); }
        .stat-card-pending { border-color: #f59e0b; }
        .stat-card-approved { border-color: #22c55e; }
        .stat-card-rejected { border-color: #ef4444; }
        .stat-label { font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: var(--text-muted); margin-bottom: 0.5rem; }
        .stat-num { font-size: 2rem; font-weight: 800; color: var(--text); line-height: 1; }
        .stat-card-total .stat-num { color: var(--primary); }
        .stat-card-pending .stat-num { color: #f59e0b; }
        .stat-card-approved .stat-num { color: #22c55e; }
        .stat-card-rejected .stat-num { color: #ef4444; }
        .stat-icon { position: absolute; right: 1rem; top: 1rem; font-size: 1.75rem; opacity: 0.15; }

        /* ─── FILTER ROW ─── */
        .filter-toolbar { display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap; padding: 0.75rem 1rem; border-bottom: 1px solid var(--border); }
        .search-input { flex: 1; min-width: 200px; padding: 0.6rem 1rem 0.6rem 2.25rem; background: var(--bg); border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; color: var(--text-body); background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Ccircle cx='11' cy='11' r='8'/%3E%3Cpath d='m21 21-4.35-4.35'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: 0.75rem center; transition: all 0.2s; }
        .search-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-glow); }
        .status-filter-btn { padding: 0.45rem 0.875rem; border: 1.5px solid var(--border); border-radius: 2rem; font-family: 'Inter', sans-serif; font-size: 0.775rem; font-weight: 600; cursor: pointer; transition: all 0.2s; background: var(--surface); color: var(--text-muted); }
        .status-filter-btn:hover { border-color: var(--primary); color: var(--primary); }
        .status-filter-btn.active { color: white; }
        .filter-all.active { background: var(--primary); border-color: var(--primary); }
        .filter-pending.active { background: #f59e0b; border-color: #f59e0b; }
        .filter-approved.active { background: #22c55e; border-color: #22c55e; }
        .filter-rejected.active { background: #ef4444; border-color: #ef4444; }

        /* ─── TABLE ─── */
        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); margin-bottom: 1.75rem; overflow: hidden; transition: background 0.3s; }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 0.75rem; }
        .card-header-accent { width: 4px; height: 1.5rem; border-radius: 2px; background: linear-gradient(180deg, var(--primary), var(--primary-dark)); }
        .card-title { font-size: 1rem; font-weight: 700; color: var(--text); }
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: var(--bg); }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid var(--border); vertical-align: middle; color: var(--text-body); }
        tbody tr:hover { background: rgba(56,189,248,0.03); }
        tbody tr:last-child td { border-bottom: none; }
        tr.hidden-row { display: none; }

        .badge { display: inline-flex; align-items: center; padding: 0.3rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600; }
        .badge-pending { background: #fef3c7; color: #d97706; }
        .badge-approved { background: #dcfce7; color: #16a34a; }
        .badge-rejected { background: #fee2e2; color: #dc2626; }

        .actions-cell { display: flex; gap: 0.5rem; }
        .btn { display: inline-flex; align-items: center; gap: 0.35rem; padding: 0.45rem 0.875rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.8rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .btn-approve { background: linear-gradient(135deg, #22c55e, #16a34a); color: white; }
        .btn-approve:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(34,197,94,0.3); }
        .btn-reject { background: linear-gradient(135deg, #f87171, #ef4444); color: white; }
        .btn-reject:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(239,68,68,0.3); }

        .empty-state { text-align: center; padding: 3rem; color: var(--text-muted); }
        .empty-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }
        .date-main { font-weight: 600; }
        .time-sub { font-size: 0.75rem; color: var(--text-muted); }

        /* ─── TOAST ─── */
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
        .toast-success .toast-progress { background: #22c55e; }
        .toast-info .toast-progress { background: var(--primary); }
        @keyframes toastProg { from { width: 100%; } to { width: 0%; } }
    </style>
</head>
<body>
    <div class="toast-container" id="toastContainer"></div>

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
                <h2>Appointments</h2>
                <div class="breadcrumb">Admin Dashboard › Manage Appointments</div>
            </div>
            <div class="topbar-actions">
                <button class="dark-toggle" id="darkToggle" onclick="toggleDark()">🌙</button>
                <div class="user-badge">
                    <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "A" %></div>
                    <span class="user-name"><%= user.getName() %></span>
                </div>
            </div>
        </header>

        <div class="content">

            <!-- ANIMATED STAT CARDS -->
            <div class="stats-row">
                <div class="stat-card stat-card-total">
                    <div class="stat-label">Total</div>
                    <div class="stat-num" data-target="<%= total %>">0</div>
                    <div class="stat-icon">📊</div>
                </div>
                <div class="stat-card stat-card-pending">
                    <div class="stat-label">Pending</div>
                    <div class="stat-num" data-target="<%= pending %>">0</div>
                    <div class="stat-icon">⏳</div>
                </div>
                <div class="stat-card stat-card-approved">
                    <div class="stat-label">Approved</div>
                    <div class="stat-num" data-target="<%= approved %>">0</div>
                    <div class="stat-icon">✅</div>
                </div>
                <div class="stat-card stat-card-rejected">
                    <div class="stat-label">Rejected</div>
                    <div class="stat-num" data-target="<%= rejected %>">0</div>
                    <div class="stat-icon">❌</div>
                </div>
            </div>

            <!-- TABLE -->
            <div class="card">
                <div class="card-header">
                    <div class="card-header-accent"></div>
                    <div class="card-title">All Appointments</div>
                </div>
                <div class="filter-toolbar">
                    <input type="text" class="search-input" id="tableSearch" placeholder="Search patient or doctor..." oninput="applyFilters()">
                    <button class="status-filter-btn filter-all active" onclick="setFilter('ALL')">All</button>
                    <button class="status-filter-btn filter-pending" onclick="setFilter('PENDING')">⏳ Pending</button>
                    <button class="status-filter-btn filter-approved" onclick="setFilter('APPROVED')">✅ Approved</button>
                    <button class="status-filter-btn filter-rejected" onclick="setFilter('REJECTED')">❌ Rejected</button>
                </div>
                <div class="table-wrap">
                    <table id="apptTable">
                        <thead>
                            <tr>
                                <th>Date &amp; Time</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (appointments != null && !appointments.isEmpty()) {
                                for (Map<String, Object> a : appointments) {
                                    String status = (String) a.get("status");
                                    String badgeClass = "APPROVED".equals(status) ? "badge-approved" :
                                                        "REJECTED".equals(status) ? "badge-rejected" : "badge-pending";
                            %>
                            <tr data-status="<%= status %>">
                                <td>
                                    <div class="date-main"><%= a.get("date") %></div>
                                    <div class="time-sub"><%= a.get("time") %></div>
                                </td>
                                <td style="font-weight:600;"><%= a.get("patient") %></td>
                                <td style="color:var(--text-muted);">Dr. <%= a.get("doctor") %></td>
                                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                <td>
                                    <div class="actions-cell">
                                        <% if ("PENDING".equals(status)) { %>
                                        <form action="<%=request.getContextPath()%>/adminAppointments" method="POST" style="display:inline;">
                                            <input type="hidden" name="id" value="<%= a.get("id") %>">
                                            <input type="hidden" name="action" value="approve">
                                            <button type="submit" class="btn btn-approve">✓ Approve</button>
                                        </form>
                                        <form action="<%=request.getContextPath()%>/adminAppointments" method="POST" style="display:inline;">
                                            <input type="hidden" name="id" value="<%= a.get("id") %>">
                                            <input type="hidden" name="action" value="reject">
                                            <button type="submit" class="btn btn-reject">✕ Reject</button>
                                        </form>
                                        <% } else { %>
                                        <span style="color:var(--text-muted); font-size:0.8rem; font-style:italic;">No action</span>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="5"><div class="empty-state"><div class="empty-icon">📭</div><p>No appointments found.</p></div></td></tr>
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
            const curr = document.documentElement.getAttribute('data-theme');
            const next = curr === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            document.getElementById('darkToggle').textContent = next === 'dark' ? '☀️' : '🌙';
        }

        /* ─── ANIMATED COUNTERS ─── */
        function animateCounter(el, target, duration = 1200) {
            const start = performance.now();
            function step(now) {
                const p = Math.min((now - start) / duration, 1);
                const eased = 1 - Math.pow(1 - p, 3);
                el.textContent = Math.round(eased * target);
                if (p < 1) requestAnimationFrame(step);
            }
            requestAnimationFrame(step);
        }

        /* ─── FILTER SYSTEM ─── */
        let currentFilter = 'ALL';
        function setFilter(status) {
            currentFilter = status;
            document.querySelectorAll('.status-filter-btn').forEach(b => b.classList.remove('active'));
            const btnClass = { ALL: '.filter-all', PENDING: '.filter-pending', APPROVED: '.filter-approved', REJECTED: '.filter-rejected' }[status];
            document.querySelector(btnClass).classList.add('active');
            applyFilters();
        }
        function applyFilters() {
            const query = document.getElementById('tableSearch').value.toLowerCase().trim();
            document.querySelectorAll('#apptTable tbody tr[data-status]').forEach(row => {
                const status = row.dataset.status;
                const text = row.textContent.toLowerCase();
                const matchStatus = currentFilter === 'ALL' || status === currentFilter;
                const matchSearch = !query || text.includes(query);
                row.style.display = matchStatus && matchSearch ? '' : 'none';
            });
        }

        /* ─── TOAST ─── */
        function showToast(title, msg, type = 'info') {
            const icons = { success: '✅', info: 'ℹ️', error: '❌' };
            const c = document.getElementById('toastContainer');
            const t = document.createElement('div');
            t.className = 'toast toast-' + type;
            t.innerHTML = '<div class="toast-icon">' + icons[type] + '</div><div><div class="toast-title">' + title + '</div><div class="toast-msg">' + msg + '</div></div><button class="toast-close" onclick="this.parentElement.classList.add(\'removing\');setTimeout(()=>this.parentElement.remove(),300)">✕</button><div class="toast-progress"></div>';
            c.appendChild(t);
            setTimeout(() => { t.classList.add('removing'); setTimeout(() => t.remove(), 300); }, 4200);
        }

        /* ─── INIT ─── */
        window.addEventListener('DOMContentLoaded', () => {
            // Animate stat counters
            setTimeout(() => {
                document.querySelectorAll('.stat-num[data-target]').forEach(el => {
                    animateCounter(el, parseInt(el.dataset.target));
                });
            }, 300);
        });
    </script>
</body>
</html>
