<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic | Login</title>
    <meta name="description" content="Sign in to Sunrise Dental Clinic — Colombo's premium dental care portal for patients, doctors, and staff.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🦷</text></svg>">
    <style>
        :root {
            --navy: #0a0f1e;
            --navy-mid: #0f172a;
            --navy-card: rgba(15, 23, 42, 0.75);
            --sky: #38bdf8;
            --sky-dark: #0ea5e9;
            --indigo: #818cf8;
            --indigo-dark: #6366f1;
            --text: #f8fafc;
            --muted: #94a3b8;
            --border: rgba(255,255,255,0.1);
            --error: #f87171;
            --success: #4ade80;
            --input-bg: rgba(255,255,255,0.05);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            background: var(--navy);
            color: var(--text);
            overflow: hidden;
        }

        /* ─── LEFT PANEL ─────────────────────────────── */
        .hero-panel {
            flex: 1;
            background: linear-gradient(145deg, #0f172a 0%, #1e1b4b 50%, #0c2340 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 3rem;
            position: relative;
            overflow: hidden;
        }

        .hero-panel::before {
            content: '';
            position: absolute;
            width: 500px; height: 500px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(56,189,248,0.15) 0%, transparent 70%);
            top: -100px; left: -100px;
            animation: pulse 6s ease-in-out infinite;
        }
        .hero-panel::after {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(129,140,248,0.12) 0%, transparent 70%);
            bottom: -80px; right: -80px;
            animation: pulse 8s ease-in-out infinite reverse;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.6; }
            50% { transform: scale(1.1); opacity: 1; }
        }

        .floating-teeth {
            position: absolute;
            inset: 0;
            pointer-events: none;
        }
        .tooth {
            position: absolute;
            font-size: 2rem;
            opacity: 0.06;
            animation: float linear infinite;
        }
        .tooth:nth-child(1) { top: 10%; left: 15%; animation-duration: 18s; font-size: 3rem; }
        .tooth:nth-child(2) { top: 30%; right: 20%; animation-duration: 22s; animation-delay: -5s; }
        .tooth:nth-child(3) { bottom: 25%; left: 25%; animation-duration: 16s; animation-delay: -8s; font-size: 1.5rem; }
        .tooth:nth-child(4) { bottom: 10%; right: 15%; animation-duration: 20s; animation-delay: -12s; }
        .tooth:nth-child(5) { top: 55%; left: 5%; animation-duration: 14s; animation-delay: -3s; font-size: 1.2rem; }
        @keyframes float {
            0% { transform: translateY(0) rotate(0deg); }
            33% { transform: translateY(-30px) rotate(15deg); }
            66% { transform: translateY(15px) rotate(-10deg); }
            100% { transform: translateY(0) rotate(0deg); }
        }

        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            max-width: 400px;
        }
        .hero-logo {
            font-size: 4rem;
            margin-bottom: 1rem;
            filter: drop-shadow(0 0 30px rgba(56,189,248,0.5));
            animation: float 6s ease-in-out infinite;
        }
        .hero-title {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, #38bdf8, #818cf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.75rem;
            line-height: 1.2;
        }
        .hero-subtitle {
            color: var(--muted);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 2.5rem;
        }
        .hero-features {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            text-align: left;
        }
        .feature-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: #cbd5e1;
            font-size: 0.9rem;
        }
        .feature-dot {
            width: 8px; height: 8px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--sky), var(--indigo));
            flex-shrink: 0;
            box-shadow: 0 0 8px rgba(56,189,248,0.6);
        }

        /* ─── RIGHT PANEL ─────────────────────────────── */
        .auth-panel {
            width: 480px;
            min-height: 100vh;
            background: linear-gradient(180deg, #0f172a 0%, #111827 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .forms-wrapper {
            width: 100%;
            position: relative;
        }

        .auth-form-card {
            width: 100%;
            padding: 2.5rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border);
            border-radius: 1.5rem;
            backdrop-filter: blur(20px);
            box-shadow: 0 32px 64px rgba(0,0,0,0.4), inset 0 1px 0 rgba(255,255,255,0.08);
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .auth-form-card.hidden {
            display: none;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .form-header .logo-icon { font-size: 2rem; margin-bottom: 0.5rem; }
        .form-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.4rem;
        }
        .form-header p {
            color: var(--muted);
            font-size: 0.875rem;
        }

        /* ─── FORM ELEMENTS ─────────────────────────────── */
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-group label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }
        .input-wrapper {
            position: relative;
        }
        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 1rem;
            pointer-events: none;
        }
        .form-control {
            width: 100%;
            padding: 0.875rem 1rem 0.875rem 2.75rem;
            background: var(--input-bg);
            border: 1px solid var(--border);
            border-radius: 0.75rem;
            color: var(--text);
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .form-control:focus {
            outline: none;
            border-color: var(--sky);
            background: rgba(56,189,248,0.05);
            box-shadow: 0 0 0 3px rgba(56,189,248,0.15);
        }
        .form-control::placeholder { color: rgba(148,163,184,0.5); }

        .password-toggle {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--muted);
            cursor: pointer;
            font-size: 1rem;
            padding: 0;
            line-height: 1;
        }
        .password-toggle:hover { color: var(--sky); }
        .no-icon { padding-left: 1rem; }

        .form-row-2 {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 0.75rem;
        }

        .btn-primary {
            width: 100%;
            padding: 0.95rem;
            background: linear-gradient(135deg, var(--sky) 0%, var(--sky-dark) 100%);
            color: #0a0f1e;
            border: none;
            border-radius: 0.75rem;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 24px rgba(56,189,248,0.35);
            letter-spacing: 0.02em;
            margin-top: 0.5rem;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 32px rgba(56,189,248,0.5);
        }
        .btn-primary:active { transform: translateY(0); }

        .divider {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin: 1.5rem 0;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }
        .divider span {
            color: var(--muted);
            font-size: 0.8rem;
        }

        .toggle-link {
            text-align: center;
            font-size: 0.875rem;
            color: var(--muted);
        }
        .toggle-link a {
            color: var(--sky);
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: color 0.2s;
        }
        .toggle-link a:hover { color: var(--indigo); text-decoration: underline; }

        /* ─── ALERTS ─────────────────────────────── */
        .alert {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            border-radius: 0.625rem;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 1.25rem;
        }
        .alert-error {
            background: rgba(248,113,113,0.1);
            border: 1px solid rgba(248,113,113,0.3);
            color: var(--error);
        }
        .alert-success {
            background: rgba(74,222,128,0.1);
            border: 1px solid rgba(74,222,128,0.3);
            color: var(--success);
        }

        /* ─── RESPONSIVE ─────────────────────────────── */
        @media (max-width: 900px) {
            .hero-panel { display: none; }
            .auth-panel { width: 100%; }
        }
    </style>
</head>
<body>

    <!-- LEFT HERO PANEL -->
    <div class="hero-panel">
        <div class="floating-teeth">
            <span class="tooth">🦷</span>
            <span class="tooth">🦷</span>
            <span class="tooth">🦷</span>
            <span class="tooth">🦷</span>
            <span class="tooth">🦷</span>
        </div>
        <div class="hero-content">
            <div class="hero-logo">🦷</div>
            <h2 class="hero-title">Sunrise Dental Clinic</h2>
            <p class="hero-subtitle">Premium dental care management — seamlessly connecting patients, doctors, and staff across Colombo.</p>
            <div class="hero-features">
                <div class="feature-item"><div class="feature-dot"></div>Book & manage appointments online</div>
                <div class="feature-item"><div class="feature-dot"></div>Instant prescription & pharmacy workflow</div>
                <div class="feature-item"><div class="feature-dot"></div>Transparent digital billing &amp; invoices</div>
                <div class="feature-item"><div class="feature-dot"></div>Multi-role secure access portal</div>
            </div>
        </div>
    </div>

    <!-- RIGHT AUTH PANEL -->
    <div class="auth-panel">
        <div class="forms-wrapper">

            <!-- LOGIN FORM -->
            <div class="auth-form-card" id="loginCard">
                <div class="form-header">
                    <div class="logo-icon">🔐</div>
                    <h1>Welcome back</h1>
                    <p>Sign in to your Sunrise Dental account</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">⚠ <%= request.getAttribute("error") %></div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success">✓ <%= request.getAttribute("success") %></div>
                <% } %>

                <form action="<%=request.getContextPath()%>/api/login" method="POST">
                    <div class="form-group">
                        <label for="login-username">Username</label>
                        <div class="input-wrapper">
                            <span class="input-icon">👤</span>
                            <input type="text" id="login-username" name="username" class="form-control" placeholder="Enter your username" required autocomplete="username">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="login-password">Password</label>
                        <div class="input-wrapper">
                            <span class="input-icon">🔒</span>
                            <input type="password" id="login-password" name="password" class="form-control" placeholder="Enter your password" required autocomplete="current-password">
                            <button type="button" class="password-toggle" onclick="togglePassword('login-password', this)" title="Show/hide password">👁</button>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary">Sign In →</button>
                </form>

                <div class="divider"><span>New to Sunrise?</span></div>
                <div class="toggle-link">
                    Don't have an account? <a onclick="toggleForms()" id="goToRegister">Create one here</a>
                </div>
            </div>

            <!-- REGISTER FORM -->
            <div class="auth-form-card hidden" id="registerCard">
                <div class="form-header">
                    <div class="logo-icon">🌟</div>
                    <h1>Join Sunrise Dental</h1>
                    <p>Create your patient account today</p>
                </div>

                <form action="<%=request.getContextPath()%>/api/register" method="POST">
                    <div class="form-group">
                        <label for="reg-name">Full Name</label>
                        <div class="input-wrapper">
                            <span class="input-icon">👤</span>
                            <input type="text" id="reg-name" name="name" class="form-control" placeholder="Your full name" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="reg-contact">Contact Number</label>
                        <div class="input-wrapper">
                            <span class="input-icon">📞</span>
                            <input type="text" id="reg-contact" name="contactNumber" class="form-control" placeholder="+94 77 123 4567" required>
                        </div>
                    </div>
                    <div class="form-row-2">
                        <div class="form-group" style="margin-bottom:0;">
                            <label for="reg-address">Address</label>
                            <div class="input-wrapper">
                                <span class="input-icon">📍</span>
                                <input type="text" id="reg-address" name="address" class="form-control" placeholder="City, Street" required>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label for="reg-age">Age</label>
                            <div class="input-wrapper">
                                <span class="input-icon">🎂</span>
                                <input type="number" id="reg-age" name="age" class="form-control" placeholder="25" min="1" max="120" required>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" style="margin-top:1.25rem;">
                        <label for="reg-username">Username</label>
                        <div class="input-wrapper">
                            <span class="input-icon">🪪</span>
                            <input type="text" id="reg-username" name="username" class="form-control" placeholder="Choose a username" required autocomplete="username">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="reg-password">Password</label>
                        <div class="input-wrapper">
                            <span class="input-icon">🔒</span>
                            <input type="password" id="reg-password" name="password" class="form-control" placeholder="Create a strong password" required autocomplete="new-password">
                            <button type="button" class="password-toggle" onclick="togglePassword('reg-password', this)" title="Show/hide password">👁</button>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary">Create Account →</button>
                </form>

                <div class="divider"><span>Already registered?</span></div>
                <div class="toggle-link">
                    Already have an account? <a onclick="toggleForms()" id="goToLogin">Sign in here</a>
                </div>
            </div>

        </div>
    </div>

    <script>
        function toggleForms() {
            const login = document.getElementById('loginCard');
            const register = document.getElementById('registerCard');
            login.classList.toggle('hidden');
            register.classList.toggle('hidden');
        }
        function togglePassword(inputId, btn) {
            const input = document.getElementById(inputId);
            if (input.type === 'password') {
                input.type = 'text';
                btn.textContent = '🙈';
            } else {
                input.type = 'password';
                btn.textContent = '👁';
            }
        }
    </script>
</body>
</html>
