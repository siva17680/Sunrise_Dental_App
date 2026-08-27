<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("index.jsp?error=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Appointment | Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #38bdf8;
            --primary-dark: #0ea5e9;
            --primary-glow: rgba(56,189,248,0.25);
            --navy: #0f172a;
            --bg: #f1f5f9;
            --surface: #ffffff;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success: #22c55e;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem; }

        .page-wrap { width: 100%; max-width: 680px; }

        /* TOP NAV */
        .top-nav { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.75rem; }
        .brand { display: flex; align-items: center; gap: 0.5rem; font-weight: 700; font-size: 1.1rem; color: var(--navy); }
        .back-btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1rem; background: var(--surface); border: 1.5px solid var(--border); border-radius: 0.5rem; color: var(--text-muted); font-size: 0.85rem; font-weight: 500; text-decoration: none; transition: all 0.2s; }
        .back-btn:hover { border-color: var(--primary); color: var(--primary); }

        /* CARD */
        .card { background: var(--surface); border-radius: 1.25rem; box-shadow: 0 4px 24px rgba(0,0,0,0.08), 0 1px 3px rgba(0,0,0,0.05); overflow: hidden; }
        .card-header { padding: 2rem 2rem 0; }
        .card-header h1 { font-size: 1.5rem; font-weight: 800; color: var(--text); margin-bottom: 0.25rem; }
        .card-header p { font-size: 0.875rem; color: var(--text-muted); }
        .header-divider { height: 1px; background: var(--border); margin: 1.5rem 0 0; }
        .card-body { padding: 2rem; }

        /* FORM FIELDS */
        .form-section-label { font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: var(--text-muted); margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 1px solid var(--border); }
        .field-group { margin-bottom: 1.25rem; }
        .field-group label { display: block; font-size: 0.78rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem; }
        .field-input { width: 100%; padding: 0.8rem 1rem; border: 1.5px solid var(--border); border-radius: 0.625rem; font-family: 'Inter', sans-serif; font-size: 0.9rem; color: var(--text); background: #f8fafc; transition: all 0.2s cubic-bezier(0.4,0,0.2,1); }
        .field-input:focus { outline: none; border-color: var(--primary); background: white; box-shadow: 0 0 0 3px var(--primary-glow); }
        .field-input::placeholder { color: rgba(100,116,139,0.5); }
        select.field-input { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%2364748b' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 1rem center; padding-right: 2.5rem; }

        .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .form-grid-3 { display: grid; grid-template-columns: 2fr 1fr 1fr; gap: 1rem; }

        /* SUBMIT */
        .submit-btn { width: 100%; padding: 1rem; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: #0a0f1e; border: none; border-radius: 0.75rem; font-family: 'Inter', sans-serif; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.25s cubic-bezier(0.4,0,0.2,1); box-shadow: 0 4px 16px var(--primary-glow); letter-spacing: 0.02em; margin-top: 0.5rem; }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 24px var(--primary-glow); }
        .submit-btn:active { transform: translateY(0); }
    </style>
</head>
<body>
    <div class="page-wrap">
        <nav class="top-nav">
            <div class="brand">🦷 Sunrise Dental</div>
            <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
        </nav>

        <div class="card">
            <div class="card-header">
                <h1>Register New Appointment</h1>
                <p>Fill in all details below to schedule a patient appointment.</p>
                <div class="header-divider"></div>
            </div>
            <div class="card-body">
                <form action="RegisterServlet" method="POST">

                    <div class="form-section-label">Patient Information</div>
                    <div class="field-group">
                        <label for="appointmentNumber">Appointment Number (Unique)</label>
                        <input type="text" id="appointmentNumber" name="appointmentNumber" class="field-input" placeholder="e.g. APT-2024-001" required>
                    </div>
                    <div class="field-group">
                        <label for="patientName">Patient Full Name</label>
                        <input type="text" id="patientName" name="patientName" class="field-input" placeholder="Full name of the patient" required>
                    </div>
                    <div class="form-grid-2" style="margin-bottom:1.25rem;">
                        <div class="field-group" style="margin-bottom:0;">
                            <label for="address">Address</label>
                            <input type="text" id="address" name="address" class="field-input" placeholder="Patient's address" required>
                        </div>
                        <div class="field-group" style="margin-bottom:0;">
                            <label for="contactNumber">Contact Number</label>
                            <input type="text" id="contactNumber" name="contactNumber" class="field-input" placeholder="+94 77 123 4567" required>
                        </div>
                    </div>

                    <div class="form-section-label">Appointment Details</div>
                    <div class="field-group">
                        <label for="dentistName">Dentist Name</label>
                        <input type="text" id="dentistName" name="dentistName" class="field-input" placeholder="Attending dentist's name" required>
                    </div>
                    <div class="field-group">
                        <label for="treatmentType">Treatment Type</label>
                        <select id="treatmentType" name="treatmentType" class="field-input">
                            <option value="CLEANING">🪥 Teeth Cleaning</option>
                            <option value="FILLING">🦷 Cavity Filling</option>
                        </select>
                    </div>
                    <div class="form-grid-2" style="margin-bottom:1.25rem;">
                        <div class="field-group" style="margin-bottom:0;">
                            <label for="appointmentDate">Appointment Date</label>
                            <input type="date" id="appointmentDate" name="appointmentDate" class="field-input" required>
                        </div>
                        <div class="field-group" style="margin-bottom:0;">
                            <label for="appointmentTime">Appointment Time</label>
                            <input type="time" id="appointmentTime" name="appointmentTime" class="field-input" required>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn">📅 Register Appointment</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
