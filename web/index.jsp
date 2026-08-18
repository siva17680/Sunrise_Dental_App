<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic | Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🦷</text></svg>">
    <style>
        :root {
            --bg-color: #0f172a;
            --glass-bg: rgba(30, 41, 59, 0.7);
            --glass-border: rgba(255, 255, 255, 0.1);
            --primary: #38bdf8;
            --primary-hover: #0ea5e9;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, var(--bg-color) 0%, #1e1b4b 100%);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        body::before, body::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            border-radius: 50%;
            filter: blur(100px);
            z-index: -1;
            opacity: 0.5;
        }
        body::before { background: #38bdf8; top: -100px; left: -100px; }
        body::after { background: #818cf8; bottom: -100px; right: -100px; }

        .container {
            width: 100%;
            max-width: 420px;
            padding: 2rem;
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 1.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header { text-align: center; margin-bottom: 2rem; }
        .header h1 { font-size: 1.8rem; font-weight: 700; margin-bottom: 0.5rem; }
        .header p { color: var(--text-muted); font-size: 0.9rem; }
        
        .address {
            text-align: center;
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-top: -1.5rem;
            margin-bottom: 2rem;
        }

        .form-group { margin-bottom: 1.5rem; }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
            color: var(--text-muted);
            font-weight: 600;
        }
        
        .form-control {
            width: 100%;
            padding: 0.875rem 1rem;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid var(--glass-border);
            border-radius: 0.75rem;
            color: white;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.2);
        }

        .btn {
            width: 100%;
            padding: 0.875rem;
            border: none;
            border-radius: 0.75rem;
            background: var(--primary);
            color: #0f172a;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px -1px rgba(56, 189, 248, 0.3);
        }
        .btn:hover { background: var(--primary-hover); transform: translateY(-2px); }

        .toggle-text {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: var(--text-muted);
        }
        .toggle-text a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            cursor: pointer;
        }
        .toggle-text a:hover { text-decoration: underline; }

        .error { color: #ef4444; text-align: center; margin-bottom: 1rem; font-size: 0.85rem; }
        .success { color: #22c55e; text-align: center; margin-bottom: 1rem; font-size: 0.85rem; }
        .hidden { display: none; }
    </style>
</head>
<body>

    <div class="container" id="loginFormContainer">
        <div class="header">
            <h1>🦷 Sunrise Dental</h1>
            <p>Welcome back to your premium dental care.</p>
        </div>
        <div class="address">Colombo, Sri Lanka</div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="success"><%= request.getAttribute("success") %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/api/login" method="POST">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn">Sign In</button>
        </form>

        <div class="toggle-text">
            New patient? <a onclick="toggleForms()">Register here</a>
        </div>
    </div>

    <!-- Registration Form -->
    <div class="container hidden" id="registerFormContainer">
        <div class="header">
            <h1>🦷 Join Sunrise</h1>
            <p>Create your patient account.</p>
        </div>

        <form action="<%=request.getContextPath()%>/api/register" method="POST">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Contact Number</label>
                <input type="text" name="contactNumber" class="form-control" required>
            </div>
            <div class="form-group" style="display: flex; gap: 1rem;">
                <div style="flex: 2;">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control" required>
                </div>
                <div style="flex: 1;">
                    <label>Age</label>
                    <input type="number" name="age" class="form-control" required>
                </div>
            </div>
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" class="form-control" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn">Sign Up</button>
        </form>

        <div class="toggle-text">
            Already have an account? <a onclick="toggleForms()">Sign In</a>
        </div>
    </div>

    <script>
        function toggleForms() {
            document.getElementById('loginFormContainer').classList.toggle('hidden');
            document.getElementById('registerFormContainer').classList.toggle('hidden');
        }
    </script>
</body>
</html>
