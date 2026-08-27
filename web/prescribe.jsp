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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #052e16;
            --primary: #4ade80;
            --primary-dark: #22c55e;
            --primary-glow: rgba(74,222,128,0.25);
            --bg: #f0fdf4;
            --surface: #ffffff;
            --text: #14532d;
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
        .brand-role { font-size: 0.72rem; color: rgba(187,247,208,0.7); font-weight: 500; text-transform: uppercase; letter-spacing: 0.1em; }
        .sidebar-nav { flex: 1; padding: 1rem 0.75rem; display: flex; flex-direction: column; gap: 0.25rem; }
        .nav-item { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; color: rgba(187,247,208,0.8); text-decoration: none; border-radius: 0.625rem; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .nav-item:hover { background: rgba(74,222,128,0.1); color: #bbf7d0; border-left-color: rgba(74,222,128,0.5); }
        .nav-item .nav-icon { font-size: 1.1rem; flex-shrink: 0; }
        .sidebar-footer { padding: 1rem 0.75rem; border-top: 1px solid rgba(255,255,255,0.08); }
        .nav-item.logout { color: rgba(248,113,113,0.8); }
        .nav-item.logout:hover { background: rgba(239,68,68,0.1); color: #f87171; border-left-color: #f87171; }

        .main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .topbar { background: var(--surface); border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 50; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .topbar-left h2 { font-size: 1.4rem; font-weight: 700; color: var(--text); }
        .topbar-left .breadcrumb { font-size: 0.78rem; color: var(--text-muted); margin-top: 0.15rem; }
        .user-badge { display: flex; align-items: center; gap: 0.625rem; background: var(--bg); padding: 0.5rem 0.875rem; border-radius: 2rem; border: 1px solid #bbf7d0; }
        .user-avatar { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); display: flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: 700; color: #052e16; }
        .user-name { font-size: 0.85rem; font-weight: 600; color: var(--text); }

        .content { padding: 2rem; flex: 1; max-width: 820px; }

        .patient-info-bar {
            background: linear-gradient(135deg, var(--sidebar-bg), #064e3b);
            border-radius: 1rem;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.75rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            color: white;
        }
        .patient-icon { font-size: 2rem; }
        .patient-bar-label { font-size: 0.72rem; color: rgba(187,247,208,0.7); text-transform: uppercase; letter-spacing: 0.08em; font-weight: 600; }
        .patient-bar-name { font-size: 1.25rem; font-weight: 700; color: var(--primary); }

        .card { background: var(--surface); border-radius: 1rem; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04); overflow: hidden; border-top: 4px solid var(--primary); }
        .card-header { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
        .card-title { font-size: 1rem; font-weight: 700; color: var(--text); }
        .card-body { padding: 1.5rem; }

        /* MED ROWS */
        #med-list { display: flex; flex-direction: column; gap: 0.75rem; margin-bottom: 1rem; }
        .med-row {
            display: grid;
            grid-template-columns: 2fr 2fr 0.8fr auto;
            gap: 0.625rem;
            align-items: center;
            background: #f8fafc;
            border: 1.5px solid var(--border);
            border-radius: 0.625rem;
            padding: 0.75rem;
            transition: border-color 0.2s;
        }
        .med-row:focus-within { border-color: var(--primary); background: white; }
        .med-row .row-num {
            grid-column: 1 / -1;
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.25rem;
        }
        .field-input { width: 100%; padding: 0.65rem 0.875rem; border: 1.5px solid var(--border); border-radius: 0.5rem; font-family: 'Inter', sans-serif; font-size: 0.875rem; color: var(--text-body); background: white; transition: all 0.2s; }
        .field-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px var(--primary-glow); }
        .field-input::placeholder { color: rgba(100,116,139,0.5); }

        .add-med-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            width: 100%;
            padding: 0.75rem;
            background: transparent;
            border: 2px dashed #d1fae5;
            border-radius: 0.625rem;
            color: var(--primary-dark);
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin-bottom: 1.5rem;
        }
        .add-med-btn:hover { border-color: var(--primary); background: rgba(74,222,128,0.05); }

        .remove-btn { background: #fee2e2; color: #dc2626; border: none; border-radius: 0.375rem; padding: 0.5rem 0.625rem; cursor: pointer; font-size: 0.8rem; font-weight: 700; transition: all 0.2s; }
        .remove-btn:hover { background: #dc2626; color: white; }

        .submit-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: #052e16;
            border: none;
            border-radius: 0.75rem;
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s;
            box-shadow: 0 4px 16px var(--primary-glow);
            letter-spacing: 0.02em;
        }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 24px var(--primary-glow); }

        .med-count-badge { background: var(--primary); color: #052e16; font-size: 0.72rem; font-weight: 700; padding: 0.15rem 0.5rem; border-radius: 2rem; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo">🦷</div>
            <div class="brand-name">Dr. Portal</div>
            <div class="brand-role">Doctor Dashboard</div>
        </div>
        <nav class="sidebar-nav">
            <a href="<%=request.getContextPath()%>/doctorDashboard" class="nav-item"><span class="nav-icon">🩺</span> My Patients</a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%=request.getContextPath()%>/api/logout" class="nav-item logout"><span class="nav-icon">🚪</span> Logout</a>
        </div>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="topbar-left">
                <h2>Prescribe Medication</h2>
                <div class="breadcrumb">Dr. Portal › Prescribe</div>
            </div>
            <div class="user-badge">
                <div class="user-avatar"><%= user.getName() != null && user.getName().length() > 0 ? String.valueOf(user.getName().charAt(0)).toUpperCase() : "D" %></div>
                <span class="user-name">Dr. <%= user.getName() %></span>
            </div>
        </header>

        <div class="content">
            <div class="patient-info-bar">
                <div class="patient-icon">🧑‍⚕️</div>
                <div>
                    <div class="patient-bar-label">Prescribing for patient</div>
                    <div class="patient-bar-name"><%= request.getAttribute("patient_name") %></div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-title">💊 Medication List</div>
                    <span class="med-count-badge" id="med-count">1 item</span>
                </div>
                <div class="card-body">
                    <form action="<%=request.getContextPath()%>/doctorPrescribe" method="POST">
                        <% if (request.getAttribute("appt_id") != null) { %>
                            <input type="hidden" name="appt_id" value="<%= request.getAttribute("appt_id") %>">
                        <% } else if (request.getAttribute("invoice_id") != null) { %>
                            <input type="hidden" name="invoice_id" value="<%= request.getAttribute("invoice_id") %>">
                        <% } %>
                        <input type="hidden" name="patient_id" value="<%= request.getAttribute("patient_id") %>">
                        <input type="hidden" name="action" id="form-action" value="submit">

                        <div id="med-list">
                            <div class="med-row" id="med-row-1">
                                <div class="row-num">Medicine #1</div>
                                <input type="text" name="medicine_name[]" class="field-input" placeholder="Medicine name (e.g. Amoxicillin)" required>
                                <input type="text" name="dosage[]" class="field-input" placeholder="Dosage (e.g. 500mg 2x daily)" required>
                                <input type="number" name="quantity[]" class="field-input" placeholder="Qty" required min="1">
                                <div></div><!-- spacer for remove button column on first row -->
                            </div>
                        </div>

                        <button type="button" class="add-med-btn" onclick="addMedRow()">
                            ➕ Add Another Medicine
                        </button>

                        <button type="submit" class="submit-btn">Submit Prescription to Pharmacy 💊</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        let medCount = 1;
        function addMedRow() {
            medCount++;
            const list = document.getElementById('med-list');
            const row = document.createElement('div');
            row.className = 'med-row';
            row.id = 'med-row-' + medCount;
            row.innerHTML = `
                <div class="row-num">Medicine #${medCount}</div>
                <input type="text" name="medicine_name[]" class="field-input" placeholder="Medicine name" required>
                <input type="text" name="dosage[]" class="field-input" placeholder="Dosage" required>
                <input type="number" name="quantity[]" class="field-input" placeholder="Qty" required min="1">
                <button type="button" class="remove-btn" onclick="removeRow(this, ${medCount})">✕</button>
            `;
            list.appendChild(row);
            updateCount();
        }
        function removeRow(btn, num) {
            document.getElementById('med-row-' + num).remove();
            medCount = Math.max(1, medCount - 1);
            updateCount();
            // Renumber labels
            document.querySelectorAll('.row-num').forEach((el, i) => {
                el.textContent = 'Medicine #' + (i + 1);
            });
        }
        function updateCount() {
            const count = document.querySelectorAll('.med-row').length;
            document.getElementById('med-count').textContent = count + ' item' + (count > 1 ? 's' : '');
        }
    </script>
</body>
</html>
