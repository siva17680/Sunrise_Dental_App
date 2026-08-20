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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #f8fafc;
            --sidebar-bg: #4c1d95;
            --text-main: #334155;
            --primary: #a78bfa;
            --card-bg: white;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-color); color: var(--text-main); display: flex; min-height: 100vh; }
        
        .sidebar { width: 250px; background: var(--sidebar-bg); color: white; padding: 2rem 1rem; }
        .sidebar h2 { font-size: 1.5rem; margin-bottom: 2rem; text-align: center; color: var(--primary); }
        .nav-link { display: block; padding: 1rem; color: #ede9fe; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: background 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(167, 139, 250, 0.2); color: white; }

        .main-content { flex: 1; padding: 2rem; max-width: 900px; margin: auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .header h1 { font-size: 2rem; color: #4c1d95; }
        
        .card { background: var(--card-bg); border-radius: 1rem; padding: 2rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); border-top: 4px solid var(--primary); }
        .card h3 { margin-bottom: 1rem; color: #4c1d95; border-bottom: 2px solid var(--border); padding-bottom: 0.5rem; }

        .btn { padding: 0.75rem 1.5rem; border: none; border-radius: 0.5rem; background: var(--primary); color: #4c1d95; font-weight: 600; cursor: pointer; transition: 0.2s; margin-top: 1rem; }
        .btn:hover { background: #8b5cf6; color: white; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; margin-bottom: 1.5rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); }
        th { font-weight: 600; color: #64748b; }
        
        .price-input { padding: 0.5rem; border: 1px solid var(--border); border-radius: 0.25rem; width: 120px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>💊 Pharmacy</h2>
        <a href="<%=request.getContextPath()%>/pharmacistDashboard" class="nav-link active">Prescriptions</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link" style="margin-top:auto; color: #f87171;">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Process Prescription</h1>
            <p><%= user.getName() %></p>
        </div>

        <div class="card">
            <h3>Patient: <%= prescription.get("patient") %></h3>
            <p style="color: #64748b; margin-bottom: 1.5rem;">
                Prescribed by: <%= prescription.get("doctor") %> <br>
                Date: <%= prescription.get("date") %> <br>
                Linked Invoice: #INV-<%= prescription.get("invoice_id") %>
            </p>
            
            <form action="<%=request.getContextPath()%>/pharmacistProcess" method="POST">
                <input type="hidden" name="invoice_id" value="<%= prescription.get("invoice_id") %>">
                
                <table>
                    <thead>
                        <tr>
                            <th>Medicine</th>
                            <th>Dosage</th>
                            <th>Qty</th>
                            <th>Unit Price (LKR)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (items != null) {
                            for (Map<String, Object> item : items) { %>
                        <tr>
                            <td>
                                <strong><%= item.get("name") %></strong>
                                <input type="hidden" name="item_id[]" value="<%= item.get("item_id") %>">
                            </td>
                            <td><%= item.get("dosage") %></td>
                            <td>
                                <%= item.get("quantity") %>
                                <input type="hidden" name="quantity[]" value="<%= item.get("quantity") %>">
                            </td>
                            <td>
                                <input type="number" step="0.01" name="price[]" class="price-input" placeholder="0.00" required>
                            </td>
                        </tr>
                        <%  } } %>
                    </tbody>
                </table>
                
                <button type="submit" class="btn" style="width: 100%;">Add Prices to Invoice & Print Bill</button>
            </form>
        </div>
    </div>
</body>
</html>
