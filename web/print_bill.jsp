<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Map<String, Object> bill = (Map<String, Object>) request.getAttribute("bill");
    if (bill == null) {
        response.sendRedirect(request.getContextPath() + "/adminBilling");
        return;
    }
    String qrData = "Invoice:" + bill.get("id") + "|Amt:" + bill.get("amount") + "|Patient:" + bill.get("patient");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice #INV-<%= bill.get("id") %> | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #38bdf8;
            --primary-dark: #0ea5e9;
            --navy: #0f172a;
            --text: #1e293b;
            --muted: #64748b;
            --border: #e2e8f0;
            --bg: #f8fafc;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); }

        /* ─── PRINT ACTION BAR (screen only) ─── */
        .action-bar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: var(--navy);
            padding: 0.875rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            z-index: 100;
            box-shadow: 0 4px 16px rgba(0,0,0,0.3);
        }
        .action-bar .brand { display: flex; align-items: center; gap: 0.5rem; color: var(--primary); font-weight: 700; font-size: 1rem; }
        .action-bar .actions { display: flex; gap: 0.75rem; }
        .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.6rem 1.25rem; border: none; border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .btn-print { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: #0a0f1e; }
        .btn-print:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(56,189,248,0.4); }
        .btn-back { background: rgba(255,255,255,0.1); color: rgba(255,255,255,0.85); border: 1px solid rgba(255,255,255,0.15); }
        .btn-back:hover { background: rgba(255,255,255,0.15); }

        /* ─── PAGE WRAPPER ─── */
        .page-wrapper { padding: 5rem 2rem 2rem; display: flex; justify-content: center; min-height: 100vh; }

        /* ─── INVOICE ─── */
        .invoice {
            background: white;
            width: 100%;
            max-width: 820px;
            border-radius: 1rem;
            box-shadow: 0 4px 24px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        /* Header gradient banner */
        .invoice-header {
            background: linear-gradient(135deg, var(--navy) 0%, #1e1b4b 100%);
            padding: 2.5rem;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .clinic-name { font-size: 2rem; font-weight: 800; color: var(--primary); letter-spacing: -0.02em; }
        .clinic-sub { font-size: 0.78rem; color: rgba(255,255,255,0.5); margin-top: 0.25rem; font-weight: 400; }
        .invoice-meta { text-align: right; }
        .inv-num { font-size: 1.1rem; font-weight: 700; color: white; }
        .inv-meta-row { font-size: 0.8rem; color: rgba(255,255,255,0.6); margin-top: 0.25rem; }
        .status-pill {
            display: inline-flex;
            align-items: center;
            padding: 0.2rem 0.75rem;
            border-radius: 2rem;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-top: 0.5rem;
        }
        .status-paid { background: rgba(74,222,128,0.2); color: #4ade80; border: 1px solid rgba(74,222,128,0.4); }
        .status-unpaid { background: rgba(248,113,113,0.2); color: #f87171; border: 1px solid rgba(248,113,113,0.4); }

        /* Info section */
        .invoice-parties {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            padding: 2rem 2.5rem;
            border-bottom: 1px solid var(--border);
        }
        .party-label { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); margin-bottom: 0.625rem; }
        .party-name { font-size: 1rem; font-weight: 700; color: var(--text); margin-bottom: 0.25rem; }
        .party-detail { font-size: 0.825rem; color: var(--muted); line-height: 1.6; }

        /* Items table */
        .invoice-items { padding: 0 2.5rem; }
        .items-table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; }
        .items-table th { padding: 0.75rem 0; text-align: left; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: var(--muted); border-bottom: 2px solid var(--border); }
        .items-table th:last-child { text-align: right; }
        .items-table td { padding: 0.875rem 0; border-bottom: 1px solid var(--border); font-size: 0.875rem; vertical-align: middle; }
        .items-table td:last-child { text-align: right; font-weight: 600; }
        .items-table tbody tr:last-child td { border-bottom: none; }
        .section-row td { background: #f8fafc; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: var(--muted); padding: 0.5rem 0; }
        .item-type { font-size: 0.7rem; color: var(--muted); }

        /* Total */
        .invoice-total { padding: 1.25rem 2.5rem 2rem; display: flex; justify-content: flex-end; }
        .total-box {
            background: linear-gradient(135deg, var(--navy), #1e1b4b);
            border-radius: 0.75rem;
            padding: 1.25rem 2rem;
            min-width: 240px;
        }
        .total-label { font-size: 0.72rem; color: rgba(255,255,255,0.5); text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 0.25rem; }
        .total-amount { font-size: 1.75rem; font-weight: 800; color: var(--primary); }

        /* Footer */
        .invoice-footer {
            padding: 1.5rem 2.5rem;
            background: #f8fafc;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .footer-note { font-size: 0.78rem; color: var(--muted); }
        .qr-section { text-align: center; }
        .qr-section img { border-radius: 0.5rem; border: 1px solid var(--border); }
        .qr-label { font-size: 0.7rem; color: var(--muted); margin-top: 0.25rem; }

        /* ─── PRINT STYLES ─── */
        @media print {
            body { background: white; }
            .action-bar { display: none; }
            .page-wrapper { padding: 0; }
            .invoice { box-shadow: none; border-radius: 0; max-width: 100%; }
        }
    </style>
</head>
<body>

    <!-- ACTION BAR (screen only) -->
    <div class="action-bar no-print">
        <div class="brand">🦷 Sunrise Dental — Invoice #INV-<%= bill.get("id") %></div>
        <div class="actions">
            <button onclick="history.back()" class="btn btn-back">← Back</button>
            <button onclick="window.print()" class="btn btn-print">🖨 Print Invoice</button>
        </div>
    </div>

    <div class="page-wrapper">
        <div class="invoice">

            <!-- HEADER -->
            <div class="invoice-header">
                <div>
                    <div class="clinic-name">🦷 Sunrise Dental</div>
                    <div class="clinic-sub">Colombo, Sri Lanka · Premium Dental Care</div>
                </div>
                <div class="invoice-meta">
                    <div class="inv-num">Invoice #INV-<%= bill.get("id") %></div>
                    <div class="inv-meta-row">Date: <%= bill.get("date") %></div>
                    <div>
                        <span class="status-pill <%= "PAID".equals(bill.get("status")) ? "status-paid" : "status-unpaid" %>">
                            <%= bill.get("status") %>
                        </span>
                    </div>
                </div>
            </div>

            <!-- PARTIES -->
            <div class="invoice-parties">
                <div>
                    <div class="party-label">From</div>
                    <div class="party-name">Sunrise Dental Clinic</div>
                    <div class="party-detail">
                        Colombo, Sri Lanka<br>
                        Phone: +94 11 234 5678<br>
                        sunrise.dental@example.com
                    </div>
                </div>
                <div>
                    <div class="party-label">Billed To</div>
                    <div class="party-name"><%= bill.get("patient") %></div>
                    <div class="party-detail">
                        Contact: <%= bill.get("contact") %><br>
                        Age: <%= bill.get("age") %><br>
                        Attending: Dr. <%= bill.get("doctor") %>
                    </div>
                </div>
            </div>

            <!-- LINE ITEMS -->
            <div class="invoice-items">
                <table class="items-table">
                    <thead>
                        <tr>
                            <th>Description</th>
                            <th>Type</th>
                            <th style="text-align:right;">Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List<Map<String, Object>> services = (java.util.List<Map<String, Object>>) request.getAttribute("services");
                            java.util.List<Map<String, Object>> medicines = (java.util.List<Map<String, Object>>) request.getAttribute("medicines");

                            if (services != null && !services.isEmpty()) {
                        %>
                        <tr class="section-row"><td colspan="3">Dental Services</td></tr>
                        <% for (Map<String, Object> svc : services) { %>
                        <tr>
                            <td><strong><%= svc.get("name") %></strong></td>
                            <td><span class="item-type">Service</span></td>
                            <td>LKR <%= String.format("%.2f", svc.get("cost")) %></td>
                        </tr>
                        <% }
                           }

                           if (medicines != null && !medicines.isEmpty()) {
                        %>
                        <tr class="section-row"><td colspan="3">Pharmacy Items</td></tr>
                        <% for (Map<String, Object> med : medicines) { %>
                        <tr>
                            <td><strong><%= med.get("name") %></strong></td>
                            <td><span class="item-type">Medication</span></td>
                            <td>LKR <%= String.format("%.2f", med.get("cost")) %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <!-- TOTAL -->
            <div class="invoice-total">
                <div class="total-box">
                    <div class="total-label">Total Due</div>
                    <div class="total-amount">LKR <%= String.format("%.2f", bill.get("amount")) %></div>
                </div>
            </div>

            <!-- FOOTER -->
            <div class="invoice-footer">
                <div class="footer-note">
                    <strong>Thank you for choosing Sunrise Dental!</strong><br>
                    This is a computer-generated invoice. Please retain for your records.
                </div>
                <div class="qr-section">
                    <img src="<%=request.getContextPath()%>/qrcode?text=<%= java.net.URLEncoder.encode(qrData, "UTF-8") %>" alt="QR Code" width="80" height="80">
                    <div class="qr-label">Scan to verify</div>
                </div>
            </div>

        </div>
    </div>

    <script>
        // Auto-print on load with a short delay for resources to load
        window.onload = function () {
            setTimeout(function () { window.print(); }, 600);
        };
    </script>
</body>
</html>
