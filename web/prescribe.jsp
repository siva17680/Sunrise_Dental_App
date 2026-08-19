<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    com.sunrise.model.User user = (com.sunrise.model.User) session.getAttribute("user");
    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prescribe Medication | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #f8fafc;
            --sidebar-bg: #064e3b;
            --text-main: #334155;
            --primary: #34d399;
            --card-bg: white;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-color); color: var(--text-main); display: flex; min-height: 100vh; }
        
        .sidebar { width: 250px; background: var(--sidebar-bg); color: white; padding: 2rem 1rem; }
        .sidebar h2 { font-size: 1.5rem; margin-bottom: 2rem; text-align: center; color: var(--primary); }
        .nav-link { display: block; padding: 1rem; color: #d1fae5; text-decoration: none; border-radius: 0.5rem; margin-bottom: 0.5rem; transition: background 0.3s; }
        .nav-link:hover, .nav-link.active { background: rgba(52, 211, 153, 0.2); color: white; }

        .main-content { flex: 1; padding: 2rem; max-width: 900px; margin: auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .header h1 { font-size: 2rem; color: #064e3b; }
        
        .card { background: var(--card-bg); border-radius: 1rem; padding: 2rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); border-top: 4px solid var(--primary); }
        .card h3 { margin-bottom: 1rem; color: #064e3b; border-bottom: 2px solid var(--border); padding-bottom: 0.5rem; }

        .btn { padding: 0.75rem 1.5rem; border: none; border-radius: 0.5rem; background: var(--primary); color: #064e3b; font-weight: 600; cursor: pointer; transition: 0.2s; margin-top: 1rem; }
        .btn:hover { background: #10b981; color: white; }
        
        .med-row { display: flex; gap: 1rem; margin-bottom: 1rem; align-items: center; }
        .med-row input { flex: 1; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; }
        
        .add-btn { background: #e2e8f0; color: #334155; border: none; padding: 0.5rem 1rem; border-radius: 0.3rem; cursor: pointer; font-weight: 600; margin-bottom: 1rem; }
        .add-btn:hover { background: #cbd5e1; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>🦷 Dr. Portal</h2>
        <a href="<%=request.getContextPath()%>/doctorDashboard" class="nav-link">My Patients</a>
        <a href="<%=request.getContextPath()%>/index.jsp" class="nav-link" style="margin-top:auto; color: #f87171;">Logout</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Prescribe Medication</h1>
            <p>Dr. <%= user.getName() %></p>
        </div>

        <div class="card">
            <h3>Patient: <%= request.getAttribute("patient_name") %></h3>
            
            <form action="<%=request.getContextPath()%>/doctorPrescribe" method="POST">
                <% if (request.getAttribute("appt_id") != null) { %>
                    <input type="hidden" name="appt_id" value="<%= request.getAttribute("appt_id") %>">
                <% } else if (request.getAttribute("invoice_id") != null) { %>
                    <input type="hidden" name="invoice_id" value="<%= request.getAttribute("invoice_id") %>">
                <% } %>
                <input type="hidden" name="patient_id" value="<%= request.getAttribute("patient_id") %>">
                <input type="hidden" name="action" id="form-action" value="submit">
                
                <div id="med-list">
                    <div class="med-row">
                        <input type="text" name="medicine_name[]" placeholder="Medicine Name (e.g. Amoxicillin)" required>
                        <input type="text" name="dosage[]" placeholder="Dosage (e.g. 500mg, 2x daily)" required>
                        <input type="number" name="quantity[]" placeholder="Qty" required style="flex:0.5;">
                    </div>
                </div>
                
                <button type="button" class="add-btn" onclick="addMedRow()">+ Add Another Medicine</button>
                <br>
                
                <button type="submit" class="btn" style="width: 100%;">Submit Prescription to Pharmacy</button>
            </form>
        </div>
    </div>
    
    <script>
        function addMedRow() {
            const row = document.createElement('div');
            row.className = 'med-row';
            row.innerHTML = `
                <input type="text" name="medicine_name[]" placeholder="Medicine Name" required>
                <input type="text" name="dosage[]" placeholder="Dosage" required>
                <input type="number" name="quantity[]" placeholder="Qty" required style="flex:0.5;">
                <button type="button" style="background:#f87171; color:white; border:none; padding:0.75rem; border-radius:0.5rem; cursor:pointer;" onclick="this.parentElement.remove()">X</button>
            `;
            document.getElementById('med-list').appendChild(row);
        }
    </script>
</body>
</html>
