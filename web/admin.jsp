<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Ensure user is logged in and is ADMIN
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Map<String, Object>> services = (List<Map<String, Object>>) request.getAttribute("services");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Sunrise Dental</title>
    <meta name="description" content="Sunrise Dental admin dashboard — manage services and add-ons.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #0a0f1e;
            --sidebar-active: rgba(56,189,248,0.15);
            --sidebar-border: rgba(56,189,248,0.5);
            --primary: #38bdf8;
            --primary-dark: #0ea5e9;
            --primary-glow: rgba(56,189,248,0.25);
            --bg: #f1f5f9;
            --surface: #ffffff;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --danger: #ef4444;
            --success: #22c55e;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); display: flex; min-height: 100vh; }

        /* ─── SIDEBAR ─── */
        .sidebar {
            width: 260px;
            min-height: 100vh;
            background: var(--sidebar-bg);
            display: flex;
            flex-direction: column;
            padding: 0;
            position: sticky;
            top: 0;
            box-shadow: 4px 0 24px rgba(0,0,0,0.3);
            z-index: 100;
        }
        .sidebar-brand {
            padding: 1.75rem 1.5rem 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.06);
        }
        .brand-logo { font-size: 2rem; margin-bottom: 0.25rem; }
        .brand-name {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--primary);
            letter-spacing: -0.01em;
        }
        .brand-role {
            font-size: 0.72rem;
            color: rgba(148,163,184,0.8);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-top: 0.1rem;
        }
        .sidebar-nav {
            flex: 1;
            padding: 1rem 0.75rem;
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }
        .nav-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            color: rgba(203,213,225,0.8);
            text-decoration: none;
            border-radius: 0.625rem;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s cubic-bezier(0.4,0,0.2,1);
            border-left: 3px solid transparent;
        }
        .nav-item:hover {
            background: rgba(255,255,255,0.05);
            color: #f8fafc;
            border-left-color: rgba(56,189,248,0.4);
        }
        .nav-item.active {
            background: var(--sidebar-active);
            color: var(--primary);
            border-left-color: var(--primary);
            font-weight: 600;
        }
        .nav-item .nav-icon { font-size: 1.1rem; flex-shrink: 0; }
        .sidebar-footer {
            padding: 1rem 0.75rem;
            border-top: 1px solid rgba(255,255,255,0.06);
        }
        .nav-item.logout { color: rgba(248,113,113,0.8); }
        .nav-item.logout:hover { background: rgba(239,68,68,0.1); color: #f87171; border-left-color: #f87171; }

        /* ─── MAIN ─── */
        .main { flex: 1; display: flex; flex-direction: column; min-width: 0; }

        /* ─── TOP BAR ─── */
        .topbar {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 50;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .topbar-left h2 { font-size: 1.4rem; font-weight: 700; color: var(--text); }
        .topbar-left .breadcrumb { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.15rem; }
        .user-badge {
            display: flex;
            align-items: center;
            gap: 0.625rem;
            background: var(--bg);
            padding: 0.5rem 0.875rem;
            border-radius: 2rem;
            border: 1px solid var(--border);
        }
        .user-avatar {
            width: 32px; height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 700;
            color: white;
        }
        .user-name { font-size: 0.85rem; font-weight: 600; color: var(--text); }

        /* ─── CONTENT ─── */
        .content { padding: 2rem; flex: 1; }

        /* ─── CARDS ─── */
        .card {
            background: var(--surface);
            border-radius: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04);
            margin-bottom: 1.75rem;
            overflow: hidden;
        }
        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .card-body { padding: 1.5rem; }

        /* ─── ADD SERVICE FORM ─── */
        .form-grid {
            display: grid;
            grid-template-columns: 2fr 3fr 1fr 1.5fr auto;
            gap: 0.75rem;
            align-items: end;
        }
        .field-group label {
            display: block;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.4rem;
        }
        .field-input {
            width: 100%;
            padding: 0.7rem 0.875rem;
            border: 1.5px solid var(--border);
            border-radius: 0.5rem;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            color: var(--text);
            background: #f8fafc;
            transition: all 0.2s;
        }
        .field-input:focus {
            outline: none;
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px var(--primary-glow);
        }

        /* ─── TABLE ─── */
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; }
        th {
            padding: 0.875rem 1rem;
            text-align: left;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 1px solid var(--border);
            white-space: nowrap;
        }
        td {
            padding: 1rem;
            font-size: 0.875rem;
            border-bottom: 1px solid #f1f5f9;
            color: var(--text);
            vertical-align: middle;
        }
        tbody tr:hover { background: #fafbfc; }
        tbody tr:last-child td { border-bottom: none; }

        /* ─── BADGES ─── */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.3rem 0.75rem;
            border-radius: 2rem;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.02em;
        }
        .badge-addon { background: #e0f2fe; color: #0369a1; }
        .badge-base { background: #f1f5f9; color: #475569; }

        /* ─── BUTTONS ─── */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.7rem 1.25rem;
            border: none;
            border-radius: 0.5rem;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.4,0,0.2,1);
            text-decoration: none;
        }
        .btn-primary { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: #0a0f1e; box-shadow: 0 2px 8px var(--primary-glow); }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 16px var(--primary-glow); }
        .btn-sm { padding: 0.45rem 0.875rem; font-size: 0.8rem; }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-muted);
        }
        .empty-state .empty-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }
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
            <a href="<%=request.getContextPath()%>/adminDashboard" class="nav-item active" id="nav-services">
                <span class="nav-icon">⚙️</span> Services &amp; Add-ons
            </a>
            <a href="<%=request.getContextPath()%>/adminDoctors" class="nav-item" id="nav-doctors">
                <span class="nav-icon">👨‍⚕️</span> Doctor Schedules
            </a>
            <a href="<%=request.getContextPath()%>/adminAppointments" class="nav-item" id="nav-appointments">
                <span class="nav-icon">📅</span> Appointments
            </a>
            <a href="<%=request.getContextPath()%>/adminBilling" class="nav-item" id="nav-billing">
                <span class="nav-icon">💳</span> Billing
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=request.getContextPath()%>/api/logout" class="nav-item logout">
                <span class="nav-icon">🚪</span> Logout
            </a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h2>Services &amp; Add-ons</h2>
                <div class="breadcrumb">Admin Dashboard › Manage Services</div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "A" %></div>
                <span class="user-name"><%= user.getName() %></span>
            </div>
        </header>

        <div class="content">

            <!-- ADD SERVICE FORM -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">➕ Add New Service / Add-on</div>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/api/secure/admin/services" method="POST">
                        <div class="form-grid">
                            <div class="field-group">
                                <label>Service Name</label>
                                <input type="text" name="name" class="field-input" placeholder="e.g. Teeth Whitening" required>
                            </div>
                            <div class="field-group">
                                <label>Description</label>
                                <input type="text" name="description" class="field-input" placeholder="Short description" required>
                            </div>
                            <div class="field-group">
                                <label>Cost (LKR)</label>
                                <input type="number" name="cost" class="field-input" placeholder="0.00" step="0.01" min="0" required>
                            </div>
                            <div class="field-group">
                                <label>Category</label>
                                <select name="category" class="field-input">
                                    <option value="Base">Base Consultation</option>
                                    <option value="Add-on">Add-on Service</option>
                                </select>
                            </div>
                            <div class="field-group">
                                <label>&nbsp;</label>
                                <button type="submit" class="btn btn-primary">Add Service</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- SERVICES TABLE -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">📋 Available Services</div>
                    <span style="font-size:0.8rem; color:var(--text-muted);">
                        <%= services != null ? services.size() : 0 %> service(s) listed
                    </span>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Category</th>
                                <th>Cost</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (services != null && !services.isEmpty()) {
                                for (Map<String, Object> s : services) {
                                    boolean isAddon = "Add-on".equals(s.get("category"));
                            %>
                            <tr>
                                <td style="color:var(--text-muted); font-weight:500;">#<%= s.get("id") %></td>
                                <td style="font-weight:600;"><%= s.get("name") %></td>
                                <td style="color:var(--text-muted);"><%= s.get("description") %></td>
                                <td>
                                    <span class="badge <%= isAddon ? "badge-addon" : "badge-base" %>">
                                        <%= s.get("category") %>
                                    </span>
                                </td>
                                <td style="font-weight:600;">LKR <%= String.format("%.2f", s.get("cost")) %></td>
                            </tr>
                            <%  }
                               } else { %>
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <div class="empty-icon">📭</div>
                                        <p>No services available yet. Add one above.</p>
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
