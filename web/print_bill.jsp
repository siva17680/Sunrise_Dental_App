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
    <title>Invoice #INV-<%= bill.get("id") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; color: #333; margin: 0; padding: 2rem; background: #f8fafc; }
        .invoice-box { max-width: 800px; margin: auto; padding: 30px; border: 1px solid #eee; box-shadow: 0 0 10px rgba(0, 0, 0, 0.15); font-size: 16px; line-height: 24px; background: white; }
        .invoice-box table { width: 100%; line-height: inherit; text-align: left; border-collapse: collapse; }
        .invoice-box table td { padding: 5px; vertical-align: top; }
        .invoice-box table tr.top table td { padding-bottom: 20px; }
        .invoice-box table tr.top table td.title { font-size: 45px; line-height: 45px; color: #38bdf8; font-weight: bold; }
        .invoice-box table tr.information table td { padding-bottom: 40px; }
        .invoice-box table tr.heading td { background: #f1f5f9; border-bottom: 1px solid #ddd; font-weight: bold; }
        .invoice-box table tr.item td { border-bottom: 1px solid #eee; }
        .invoice-box table tr.total td:nth-child(2) { border-top: 2px solid #eee; font-weight: bold; font-size: 1.2rem; }
        .qr-code { text-align: right; }
        
        @media only screen and (max-width: 600px) {
            .invoice-box table tr.top table td { width: 100%; display: block; text-align: center; }
            .invoice-box table tr.information table td { width: 100%; display: block; text-align: center; }
        }
        @media print {
            body { background: white; padding: 0; }
            .invoice-box { box-shadow: none; border: none; max-width: 100%; }
            .no-print { display: none; }
        }
    </style>
</head>
<body>
    <div class="no-print" style="text-align: center; margin-bottom: 20px;">
        <button onclick="window.print()" style="padding: 10px 20px; background: #38bdf8; color: white; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; font-size: 16px;">🖨️ Print Invoice</button>
        <button onclick="history.back()" style="padding: 10px 20px; background: #94a3b8; color: white; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; font-size: 16px; margin-left: 10px;">⬅️ Back</button>
    </div>

    <div class="invoice-box">
        <table>
            <tr class="top">
                <td colspan="2">
                    <table>
                        <tr>
                            <td class="title">🦷 Sunrise</td>
                            <td style="text-align: right;">
                                Invoice #: <strong>INV-<%= bill.get("id") %></strong><br>
                                Created: <%= bill.get("date") %><br>
                                Status: <strong><%= bill.get("status") %></strong>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr class="information">
                <td colspan="2">
                    <table>
                        <tr>
                            <td>
                                Sunrise Dental Clinic<br>
                                Colombo,<br>
                                Sri Lanka
                            </td>
                            <td style="text-align: right;">
                                <strong>Patient Details:</strong><br>
                                <%= bill.get("patient") %><br>
                                Contact: <%= bill.get("contact") %><br>
                                Age: <%= bill.get("age") %><br><br>
                                <strong>Attending Doctor:</strong><br>
                                <%= bill.get("doctor") %>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr class="heading">
                <td>Item / Service</td>
                <td style="text-align: right;">Price</td>
            </tr>

            <% 
                java.util.List<Map<String, Object>> services = (java.util.List<Map<String, Object>>) request.getAttribute("services");
                java.util.List<Map<String, Object>> medicines = (java.util.List<Map<String, Object>>) request.getAttribute("medicines");
                
                if (services != null) {
                    for (Map<String, Object> svc : services) {
            %>
            <tr class="item">
                <td><%= svc.get("name") %> (Service)</td>
                <td style="text-align: right;">LKR <%= String.format("%.2f", svc.get("cost")) %></td>
            </tr>
            <%      } 
                } 
                
                if (medicines != null && !medicines.isEmpty()) {
            %>
            <tr class="heading">
                <td>Pharmacy Items</td>
                <td style="text-align: right;"></td>
            </tr>
            <%
                    for (Map<String, Object> med : medicines) {
            %>
            <tr class="item">
                <td><%= med.get("name") %></td>
                <td style="text-align: right;">LKR <%= String.format("%.2f", med.get("cost")) %></td>
            </tr>
            <%      }
                }
            %>

            <tr class="total">
                <td>
                    <div class="qr-code">
                        <img src="<%=request.getContextPath()%>/qrcode?text=<%= java.net.URLEncoder.encode(qrData, "UTF-8") %>" alt="QR Code" width="100" height="100">
                        <p style="font-size: 0.8rem; color: #64748b; margin-top: 5px;">Scan to verify</p>
                    </div>
                </td>
                <td style="text-align: right; vertical-align: bottom;">
                   Total: LKR <%= String.format("%.2f", bill.get("amount")) %>
                </td>
            </tr>
        </table>
    </div>
    
    <script>
        // Auto print when the page loads, but give images a second to load
        window.onload = function() {
            setTimeout(function() {
                window.print();
            }, 500);
        };
    </script>
</body>
</html>
