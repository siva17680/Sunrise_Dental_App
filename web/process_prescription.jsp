<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"PHARMACIST".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    Map<String, Object> prescription = (Map<String, Object>) request.getAttribute("prescription");
    List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("items");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Process Prescription | Pharmacy</title>
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

        .content { padding: 2rem; flex: 1; max-width: 860px; }

        /* PRESCRIPTION INFO BANNER */
        .rx-info {
            background: linear-gradient(135deg, var(--sidebar-bg), #3b0764);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.75rem;
            color: white;
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
        }
        .rx-field-label { font-size: 0.72rem; color: rgba(233,213,255,0.6); text-transform: uppercase; letter-spacing: 0.08em; font-weight: 600; margin-bottom: 0.25rem; }
        .rx-field-value { font-size: 0.95rem; font-weight: 600; color: #f5f3ff; }
        .rx-field-value.inv-id { color: var(--primary); }

        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); overflow: hidden; border-top: 4px solid var(--primary); }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); }
        .card-title { font-size: 1rem; font-weight: 700; color: var(--text); }
        .card-body { padding: 1.5rem; }

        /* TABLE */
        .table-wrap { overflow-x: auto; margin-bottom: 1.5rem; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #faf5ff; }
        th { padding: 0.875rem 1rem; text-align: left; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid var(--border); white-space: nowrap; }
        td { padding: 1rem; font-size: 0.875rem; border-bottom: 1px solid #f3f0ff; vertical-align: middle; }
        tbody tr:last-child td { border-bottom: none; }

        .med-name { font-weight: 700; color: var(--text-body); }
        .dosage-text { font-size: 0.82rem; color: var(--text-muted); }

        /* PRICE INPUT */
        .price-wrap { display: flex; align-items: center; border: 1.5px solid var(--border); border-radius: 0.5rem; overflow: hidden; max-width: 160px; }
        .price-prefix { padding: 0.6rem 0.75rem; background: #faf5ff; color: var(--text-muted); font-size: 0.8rem; font-weight: 600; border-right: 1.5px solid var(--border); white-space: nowrap; }
        .price-input { border: none; padding: 0.6rem 0.75rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; color: var(--text-body); width: 100%; outline: none; }
        .price-input:focus { background: #faf5ff; }

        .submit-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: white; border: none; border-radius: 0.75rem; font-family: 'Inter', sans-serif; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.25s; box-shadow: 0 4px 16px var(--primary-glow); letter-spacing: 0.02em; }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 24px var(--primary-glow); }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo">💊</div>
            <div class="brand-name">Pharmacy</div>
            <div class="brand-role">Pharmacist Portal</div>
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
                <h2>Process Prescription</h2>
                <div class="breadcrumb">Pharmacy › Set Medication Prices</div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "P" %></div>
                <span class="user-name"><%= user.getName() %></span>
            </div>
        </header>

        <div class="content">
            <!-- PRESCRIPTION INFO -->
            <div class="rx-info">
                <div>
                    <div class="rx-field-label">Patient</div>
                    <div class="rx-field-value"><%= prescription.get("patient") %></div>
                </div>
                <div>
                    <div class="rx-field-label">Prescribed by</div>
                    <div class="rx-field-value">Dr. <%= prescription.get("doctor") %></div>
                </div>
                <div>
                    <div class="rx-field-label">Linked Invoice</div>
                    <div class="rx-field-value inv-id">#INV-<%= prescription.get("invoice_id") %></div>
                </div>
                <div>
                    <div class="rx-field-label">Date</div>
                    <div class="rx-field-value"><%= prescription.get("date") %></div>
                </div>
            </div>

            <!-- MEDICINE PRICING -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title">💊 Set Medicine Prices</div>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/pharmacistProcess" method="POST">
                        <input type="hidden" name="invoice_id" value="<%= prescription.get("invoice_id") %>">

                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Medicine</th>
                                        <th>Dosage</th>
                                        <th>Qty</th>
                                        <th>Unit Price (LKR)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (items != null) {
                                        int idx = 1;
                                        for (Map<String, Object> item : items) { %>
                                    <tr>
                                        <td style="color:var(--text-muted); font-weight:500;"><%= idx++ %></td>
                                        <td>
                                            <div class="med-name"><%= item.get("name") %></div>
                                            <input type="hidden" name="item_id[]" value="<%= item.get("item_id") %>">
                                        </td>
                                        <td class="dosage-text"><%= item.get("dosage") %></td>
                                        <td style="font-weight:600;">
                                            × <%= item.get("quantity") %>
                                            <input type="hidden" name="quantity[]" value="<%= item.get("quantity") %>">
                                        </td>
                                        <td>
                                            <div class="price-wrap">
                                                <span class="price-prefix">LKR</span>
                                                <input type="number" step="0.01" name="price[]" class="price-input" placeholder="0.00" required min="0">
                                            </div>
                                        </td>
                                    </tr>
                                    <%  } } %>
                                </tbody>
                            </table>
                        </div>

                        <button type="submit" class="submit-btn">🖨 Add Prices to Invoice &amp; Print Bill</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
