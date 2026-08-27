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
            --sky: #38bdf8;
            --sky-dark: #0ea5e9;
            --indigo: #818cf8;
            --text: #f8fafc;
            --muted: #94a3b8;
            --border: rgba(255,255,255,0.1);
            --error: #f87171;
            --success: #4ade80;
            --warning: #fbbf24;
            --input-bg: rgba(255,255,255,0.05);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; min-height: 100vh; display: flex; background: var(--navy); color: var(--text); overflow: hidden; }

        /* ─── HERO PANEL ─── */
        .hero-panel {
            flex: 1;
            background: linear-gradient(145deg, #0f172a 0%, #1e1b4b 50%, #0c2340 100%);
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            padding: 3rem; position: relative; overflow: hidden;
        }
        .hero-panel::before {
            content: ''; position: absolute; width: 500px; height: 500px; border-radius: 50%;
            background: radial-gradient(circle, rgba(56,189,248,0.15) 0%, transparent 70%);
            top: -100px; left: -100px; animation: pulse 6s ease-in-out infinite;
        }
        .hero-panel::after {
            content: ''; position: absolute; width: 400px; height: 400px; border-radius: 50%;
            background: radial-gradient(circle, rgba(129,140,248,0.12) 0%, transparent 70%);
            bottom: -80px; right: -80px; animation: pulse 8s ease-in-out infinite reverse;
        }
        @keyframes pulse { 0%, 100% { transform: scale(1); opacity: 0.6; } 50% { transform: scale(1.1); opacity: 1; } }

        /* Floating particles */
        .particles { position: absolute; inset: 0; pointer-events: none; overflow: hidden; }
        .particle {
            position: absolute; width: 4px; height: 4px; border-radius: 50%;
            background: var(--sky); opacity: 0;
            animation: particleFloat 8s ease-in-out infinite;
        }
        .particle:nth-child(1)  { left: 10%; animation-delay: 0s;   animation-duration: 10s; }
        .particle:nth-child(2)  { left: 20%; animation-delay: 1.5s; animation-duration: 8s;  background: var(--indigo); }
        .particle:nth-child(3)  { left: 35%; animation-delay: 3s;   animation-duration: 12s; }
        .particle:nth-child(4)  { left: 55%; animation-delay: 0.5s; animation-duration: 9s;  background: var(--indigo); }
        .particle:nth-child(5)  { left: 70%; animation-delay: 2s;   animation-duration: 11s; }
        .particle:nth-child(6)  { left: 85%; animation-delay: 4s;   animation-duration: 7s;  background: var(--indigo); }
        .particle:nth-child(7)  { left: 45%; animation-delay: 5s;   animation-duration: 13s; }
        .particle:nth-child(8)  { left: 92%; animation-delay: 3.5s; animation-duration: 8.5s; }
        @keyframes particleFloat {
            0% { transform: translateY(100vh) scale(0); opacity: 0; }
            10% { opacity: 0.4; }
            90% { opacity: 0.2; }
            100% { transform: translateY(-20vh) scale(1.5); opacity: 0; }
        }

        .hero-content { position: relative; z-index: 2; text-align: center; max-width: 420px; }
        .hero-logo {
            font-size: 4.5rem; margin-bottom: 1rem;
            filter: drop-shadow(0 0 30px rgba(56,189,248,0.5));
            animation: heroFloat 4s ease-in-out infinite;
        }
        @keyframes heroFloat { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-12px); } }
        .hero-title {
            font-size: 2.5rem; font-weight: 800;
            background: linear-gradient(135deg, #38bdf8, #818cf8);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
            margin-bottom: 0.75rem; line-height: 1.2;
        }
        .hero-subtitle { color: var(--muted); font-size: 0.95rem; line-height: 1.6; margin-bottom: 2.5rem; }

        .hero-features { display: flex; flex-direction: column; gap: 0.875rem; text-align: left; }
        .feature-item {
            display: flex; align-items: center; gap: 0.875rem;
            color: #cbd5e1; font-size: 0.875rem;
            background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
            padding: 0.75rem 1rem; border-radius: 0.625rem;
            transition: all 0.3s ease;
        }
        .feature-item:hover { background: rgba(56,189,248,0.05); border-color: rgba(56,189,248,0.2); transform: translateX(4px); }
        .feature-icon { font-size: 1.2rem; flex-shrink: 0; }

        /* Stats strip */
        .stats-strip { display: flex; gap: 1.5rem; margin-top: 2.5rem; justify-content: center; }
        .stat-item { text-align: center; }
        .stat-num { font-size: 1.5rem; font-weight: 800; color: var(--sky); }
        .stat-lbl { font-size: 0.65rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.08em; }
        .stat-divider { width: 1px; background: rgba(255,255,255,0.1); }

        /* ─── AUTH PANEL ─── */
        .auth-panel {
            width: 500px; min-height: 100vh;
            background: linear-gradient(180deg, #0f172a 0%, #111827 100%);
            display: flex; align-items: center; justify-content: center;
            padding: 2rem; position: relative; overflow: hidden;
        }
        .forms-wrapper { width: 100%; position: relative; }

        /* ─── TAB SWITCHER ─── */
        .tab-switcher {
            display: flex; background: rgba(255,255,255,0.05);
            border: 1px solid var(--border); border-radius: 0.75rem;
            padding: 4px; margin-bottom: 1.75rem; gap: 4px;
        }
        .tab-btn {
            flex: 1; padding: 0.625rem; border: none; border-radius: 0.5rem;
            font-family: 'Inter', sans-serif; font-size: 0.875rem; font-weight: 600;
            cursor: pointer; transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
            color: var(--muted); background: transparent;
        }
        .tab-btn.active { background: linear-gradient(135deg, var(--sky), var(--sky-dark)); color: #0a0f1e; box-shadow: 0 2px 8px rgba(56,189,248,0.35); }

        /* ─── FORM CARDS ─── */
        .auth-form-card {
            display: none;
            animation: slideIn 0.35s cubic-bezier(0.4,0,0.2,1);
        }
        .auth-form-card.active { display: block; }
        @keyframes slideIn { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        .form-header { text-align: center; margin-bottom: 1.75rem; }
        .form-header .logo-icon { font-size: 2rem; margin-bottom: 0.4rem; }
        .form-header h1 { font-size: 1.6rem; font-weight: 700; margin-bottom: 0.3rem; }
        .form-header p { color: var(--muted); font-size: 0.83rem; }

        /* ─── FORM ELEMENTS ─── */
        .form-group { margin-bottom: 1.1rem; }
        .form-group label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.4rem; }
        .input-wrapper { position: relative; }
        .input-icon { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--muted); font-size: 1rem; pointer-events: none; transition: color 0.2s; }
        .form-control {
            width: 100%; padding: 0.875rem 1rem 0.875rem 2.75rem;
            background: var(--input-bg); border: 1.5px solid var(--border);
            border-radius: 0.75rem; color: var(--text); font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.25s cubic-bezier(0.4,0,0.2,1);
        }
        .form-control:focus { outline: none; border-color: var(--sky); background: rgba(56,189,248,0.05); box-shadow: 0 0 0 3px rgba(56,189,248,0.15); }
        .form-control:focus ~ .input-icon { color: var(--sky); }
        .form-control.valid { border-color: var(--success); }
        .form-control.invalid { border-color: var(--error); }
        .form-control::placeholder { color: rgba(148,163,184,0.4); }

        .validation-msg { font-size: 0.72rem; margin-top: 0.3rem; display: flex; align-items: center; gap: 0.3rem; }
        .validation-msg.ok { color: var(--success); }
        .validation-msg.err { color: var(--error); }

        .pw-toggle { position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--muted); cursor: pointer; font-size: 1rem; padding: 0; line-height: 1; transition: color 0.2s; }
        .pw-toggle:hover { color: var(--sky); }

        .form-row-2 { display: grid; grid-template-columns: 2fr 1fr; gap: 0.75rem; }

        /* ─── PASSWORD STRENGTH ─── */
        .strength-wrap { margin-top: 0.5rem; }
        .strength-bar { display: flex; gap: 3px; height: 4px; border-radius: 2px; overflow: hidden; }
        .strength-seg { flex: 1; border-radius: 2px; background: rgba(255,255,255,0.1); transition: background 0.3s ease; }
        .strength-label { font-size: 0.7rem; color: var(--muted); margin-top: 0.3rem; transition: color 0.3s; }
        .strength-rules { display: grid; grid-template-columns: 1fr 1fr; gap: 0.2rem 1rem; margin-top: 0.5rem; }
        .s-rule { font-size: 0.68rem; color: var(--muted); display: flex; align-items: center; gap: 0.3rem; transition: color 0.3s; }
        .s-rule.met { color: var(--success); }
        .s-rule .dot { width: 6px; height: 6px; border-radius: 50%; background: rgba(255,255,255,0.2); flex-shrink: 0; transition: background 0.3s; }
        .s-rule.met .dot { background: var(--success); }

        /* ─── SUBMIT BUTTON ─── */
        .btn-primary {
            width: 100%; padding: 0.95rem;
            background: linear-gradient(135deg, var(--sky), var(--sky-dark));
            color: #0a0f1e; border: none; border-radius: 0.75rem;
            font-size: 0.95rem; font-weight: 700; cursor: pointer;
            transition: all 0.25s cubic-bezier(0.4,0,0.2,1);
            box-shadow: 0 4px 24px rgba(56,189,248,0.35);
            letter-spacing: 0.02em; margin-top: 0.75rem;
            display: flex; align-items: center; justify-content: center; gap: 0.5rem;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 32px rgba(56,189,248,0.5); }
        .btn-primary:active { transform: translateY(0); }
        .btn-primary.loading { opacity: 0.7; pointer-events: none; }
        .spinner { width: 16px; height: 16px; border: 2px solid rgba(0,0,0,0.3); border-top-color: #0a0f1e; border-radius: 50%; animation: spin 0.6s linear infinite; display: none; }
        .btn-primary.loading .spinner { display: block; }
        .btn-primary.loading .btn-text { opacity: 0.7; }
        @keyframes spin { to { transform: rotate(360deg); } }

        /* ─── ALERTS ─── */
        .alert { display: flex; align-items: center; gap: 0.5rem; padding: 0.75rem 1rem; border-radius: 0.625rem; font-size: 0.83rem; font-weight: 500; margin-bottom: 1.25rem; }
        .alert-error { background: rgba(248,113,113,0.1); border: 1px solid rgba(248,113,113,0.3); color: var(--error); }
        .alert-success { background: rgba(74,222,128,0.1); border: 1px solid rgba(74,222,128,0.3); color: var(--success); }

        /* ─── RESPONSIVE ─── */
        @media (max-width: 900px) { .hero-panel { display: none; } .auth-panel { width: 100%; } }

        /* ─── TOAST SYSTEM ─── */
        .toast-container { position: fixed; bottom: 1.5rem; right: 1.5rem; z-index: 9999; display: flex; flex-direction: column; gap: 0.625rem; pointer-events: none; }
        .toast {
            display: flex; align-items: flex-start; gap: 0.75rem;
            background: #1e293b; border: 1px solid rgba(255,255,255,0.1);
            border-radius: 0.75rem; padding: 1rem 1.25rem;
            min-width: 280px; max-width: 360px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.4);
            pointer-events: all;
            animation: toastIn 0.35s cubic-bezier(0.34,1.56,0.64,1);
            position: relative; overflow: hidden;
        }
        .toast.removing { animation: toastOut 0.3s ease forwards; }
        @keyframes toastIn { from { opacity: 0; transform: translateX(100%); } to { opacity: 1; transform: translateX(0); } }
        @keyframes toastOut { from { opacity: 1; transform: translateX(0); } to { opacity: 0; transform: translateX(120%); } }
        .toast-icon { font-size: 1.25rem; flex-shrink: 0; margin-top: 1px; }
        .toast-body .toast-title { font-size: 0.875rem; font-weight: 700; color: #f8fafc; margin-bottom: 0.15rem; }
        .toast-body .toast-msg { font-size: 0.78rem; color: var(--muted); line-height: 1.4; }
        .toast-close { position: absolute; top: 0.5rem; right: 0.5rem; background: none; border: none; color: var(--muted); cursor: pointer; font-size: 0.8rem; padding: 0.1rem 0.3rem; border-radius: 0.25rem; line-height: 1; }
        .toast-close:hover { background: rgba(255,255,255,0.08); color: white; }
        .toast-progress { position: absolute; bottom: 0; left: 0; height: 3px; background: var(--sky); border-radius: 0 0 0.75rem 0.75rem; animation: toastProgress 4s linear forwards; }
        .toast.toast-success .toast-progress { background: var(--success); }
        .toast.toast-error .toast-progress { background: var(--error); }
        .toast.toast-warning .toast-progress { background: var(--warning); }
        @keyframes toastProgress { from { width: 100%; } to { width: 0%; } }
    </style>
</head>
<body>

    <!-- TOAST CONTAINER -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- LEFT HERO PANEL -->
    <div class="hero-panel">
        <div class="particles">
            <div class="particle"></div><div class="particle"></div>
            <div class="particle"></div><div class="particle"></div>
            <div class="particle"></div><div class="particle"></div>
            <div class="particle"></div><div class="particle"></div>
        </div>
        <div class="hero-content">
            <div class="hero-logo">🦷</div>
            <h2 class="hero-title">Sunrise Dental Clinic</h2>
            <p class="hero-subtitle">Premium dental care management — connecting patients, doctors, and staff across Colombo seamlessly.</p>

            <div class="stats-strip">
                <div class="stat-item">
                    <div class="stat-num" id="statPatients">0</div>
                    <div class="stat-lbl">Patients</div>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                    <div class="stat-num" id="statDoctors">0</div>
                    <div class="stat-lbl">Doctors</div>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item">
                    <div class="stat-num" id="statYears">0</div>
                    <div class="stat-lbl">Years</div>
                </div>
            </div>
        </div>
    </div>

    <!-- RIGHT AUTH PANEL -->
    <div class="auth-panel">
        <div class="forms-wrapper">

            <!-- TAB SWITCHER -->
            <div class="tab-switcher">
                <button class="tab-btn active" id="tabLogin" onclick="switchTab('login')">Sign In</button>
                <button class="tab-btn" id="tabRegister" onclick="switchTab('register')">Create Account</button>
            </div>

            <!-- ─ LOGIN FORM ─ -->
            <div class="auth-form-card active" id="loginCard">
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

                <form id="loginForm" action="<%=request.getContextPath()%>/api/login" method="POST" onsubmit="handleSubmit(this)">
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
                            <button type="button" class="pw-toggle" onclick="togglePw('login-password', this)">👁</button>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary" id="loginBtn">
                        <div class="spinner"></div>
                        <span class="btn-text">Sign In →</span>
                    </button>
                </form>
            </div>

            <!-- ─ REGISTER FORM ─ -->
            <div class="auth-form-card" id="registerCard">
                <div class="form-header">
                    <div class="logo-icon">🌟</div>
                    <h1>Join Sunrise Dental</h1>
                    <p>Create your free patient account today</p>
                </div>

                <form id="registerForm" action="<%=request.getContextPath()%>/api/register" method="POST" onsubmit="handleSubmit(this)" novalidate>
                    <div class="form-group">
                        <label for="reg-name">Full Name</label>
                        <div class="input-wrapper">
                            <span class="input-icon">👤</span>
                            <input type="text" id="reg-name" name="name" class="form-control" placeholder="Your full name" required oninput="validateName(this)">
                        </div>
                        <div class="validation-msg" id="nameMsg"></div>
                    </div>
                    <div class="form-group">
                        <label for="reg-contact">Contact Number</label>
                        <div class="input-wrapper">
                            <span class="input-icon">📞</span>
                            <input type="text" id="reg-contact" name="contactNumber" class="form-control" placeholder="+94 77 123 4567" required oninput="validateContact(this)">
                        </div>
                        <div class="validation-msg" id="contactMsg"></div>
                    </div>
                    <div class="form-row-2" style="margin-bottom:1.1rem;">
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
                                <input type="number" id="reg-age" name="age" class="form-control" placeholder="25" min="1" max="120" required oninput="validateAge(this)">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="reg-username">Username</label>
                        <div class="input-wrapper">
                            <span class="input-icon">🪪</span>
                            <input type="text" id="reg-username" name="username" class="form-control" placeholder="Choose a unique username" required autocomplete="off" oninput="validateUsername(this)">
                        </div>
                        <div class="validation-msg" id="usernameMsg"></div>
                    </div>
                    <div class="form-group">
                        <label for="reg-password">Password</label>
                        <div class="input-wrapper">
                            <span class="input-icon">🔒</span>
                            <input type="password" id="reg-password" name="password" class="form-control" placeholder="Create a strong password" required autocomplete="new-password" oninput="updateStrength(this.value)">
                            <button type="button" class="pw-toggle" onclick="togglePw('reg-password', this)">👁</button>
                        </div>
                        <!-- PASSWORD STRENGTH METER -->
                        <div class="strength-wrap" id="strengthWrap" style="display:none;">
                            <div class="strength-bar">
                                <div class="strength-seg" id="seg1"></div>
                                <div class="strength-seg" id="seg2"></div>
                                <div class="strength-seg" id="seg3"></div>
                                <div class="strength-seg" id="seg4"></div>
                            </div>
                            <div class="strength-label" id="strengthLabel">Enter a password</div>
                            <div class="strength-rules">
                                <div class="s-rule" id="rule-len"><div class="dot"></div>At least 8 characters</div>
                                <div class="s-rule" id="rule-upper"><div class="dot"></div>Uppercase letter</div>
                                <div class="s-rule" id="rule-num"><div class="dot"></div>A number</div>
                                <div class="s-rule" id="rule-special"><div class="dot"></div>Special character</div>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary" id="registerBtn">
                        <div class="spinner"></div>
                        <span class="btn-text">Create Account →</span>
                    </button>
                </form>
            </div>

        </div>
    </div>

    <script>
        /* ═══════════════════════════════════════════════════
           TAB SWITCHER
        ═══════════════════════════════════════════════════ */
        function switchTab(tab) {
            const loginCard = document.getElementById('loginCard');
            const registerCard = document.getElementById('registerCard');
            const tabLogin = document.getElementById('tabLogin');
            const tabRegister = document.getElementById('tabRegister');
            if (tab === 'login') {
                loginCard.classList.add('active');
                registerCard.classList.remove('active');
                tabLogin.classList.add('active');
                tabRegister.classList.remove('active');
            } else {
                registerCard.classList.add('active');
                loginCard.classList.remove('active');
                tabRegister.classList.add('active');
                tabLogin.classList.remove('active');
            }
        }

        /* ═══════════════════════════════════════════════════
           PASSWORD SHOW/HIDE
        ═══════════════════════════════════════════════════ */
        function togglePw(inputId, btn) {
            const input = document.getElementById(inputId);
            input.type = input.type === 'password' ? 'text' : 'password';
            btn.textContent = input.type === 'password' ? '👁' : '🙈';
        }

        /* ═══════════════════════════════════════════════════
           FORM LOADING STATE
        ═══════════════════════════════════════════════════ */
        function handleSubmit(form) {
            const btn = form.querySelector('.btn-primary');
            btn.classList.add('loading');
            btn.querySelector('.btn-text').textContent = 'Please wait...';
        }

        /* ═══════════════════════════════════════════════════
           PASSWORD STRENGTH METER
        ═══════════════════════════════════════════════════ */
        const strengthColors = ['#ef4444','#f97316','#eab308','#22c55e'];
        const strengthLabels = ['Weak','Fair','Good','Strong'];

        function updateStrength(pw) {
            const wrap = document.getElementById('strengthWrap');
            if (!pw) { wrap.style.display = 'none'; return; }
            wrap.style.display = 'block';

            const rules = {
                len:     pw.length >= 8,
                upper:   /[A-Z]/.test(pw),
                num:     /[0-9]/.test(pw),
                special: /[^A-Za-z0-9]/.test(pw)
            };
            const score = Object.values(rules).filter(Boolean).length;

            // Colour segments
            ['seg1','seg2','seg3','seg4'].forEach((id, i) => {
                const seg = document.getElementById(id);
                seg.style.background = i < score ? strengthColors[score - 1] : 'rgba(255,255,255,0.1)';
            });

            // Label
            const lbl = document.getElementById('strengthLabel');
            lbl.textContent = score > 0 ? strengthLabels[score - 1] : 'Too short';
            lbl.style.color = score > 0 ? strengthColors[score - 1] : 'var(--muted)';

            // Rules
            document.getElementById('rule-len').classList.toggle('met', rules.len);
            document.getElementById('rule-upper').classList.toggle('met', rules.upper);
            document.getElementById('rule-num').classList.toggle('met', rules.num);
            document.getElementById('rule-special').classList.toggle('met', rules.special);
        }

        /* ═══════════════════════════════════════════════════
           REAL-TIME FIELD VALIDATION
        ═══════════════════════════════════════════════════ */
        function setMsg(id, text, ok) {
            const el = document.getElementById(id);
            if (!text) { el.innerHTML = ''; return; }
            el.innerHTML = '<span>' + (ok ? '✓' : '⚠') + '</span>' + text;
            el.className = 'validation-msg ' + (ok ? 'ok' : 'err');
        }
        function validateName(input) {
            const ok = input.value.trim().length >= 2;
            input.className = 'form-control ' + (ok ? 'valid' : (input.value ? 'invalid' : ''));
            setMsg('nameMsg', input.value ? (ok ? 'Looks good!' : 'Name must be at least 2 characters') : '', ok);
        }
        function validateContact(input) {
            const ok = /^[\d\s\+\-]{7,15}$/.test(input.value.trim());
            input.className = 'form-control ' + (input.value ? (ok ? 'valid' : 'invalid') : '');
            setMsg('contactMsg', input.value ? (ok ? 'Valid number' : 'Enter a valid contact number') : '', ok);
        }
        function validateAge(input) {
            const v = parseInt(input.value);
            const ok = v >= 1 && v <= 120;
            input.className = 'form-control ' + (input.value ? (ok ? 'valid' : 'invalid') : '');
        }
        function validateUsername(input) {
            const ok = /^[a-zA-Z0-9_]{3,20}$/.test(input.value);
            input.className = 'form-control ' + (input.value ? (ok ? 'valid' : 'invalid') : '');
            setMsg('usernameMsg', input.value ? (ok ? 'Username available (format valid)' : '3–20 chars, letters/numbers/_') : '', ok);
        }

        /* ═══════════════════════════════════════════════════
           TOAST NOTIFICATION SYSTEM
        ═══════════════════════════════════════════════════ */
        function showToast(title, msg, type = 'info') {
            const icons = { success: '✅', error: '❌', warning: '⚠️', info: 'ℹ️' };
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = 'toast toast-' + type;
            toast.innerHTML = 
                '<div class="toast-icon">' + icons[type] + '</div>' +
                '<div class="toast-body">' +
                    '<div class="toast-title">' + title + '</div>' +
                    '<div class="toast-msg">' + msg + '</div>' +
                '</div>' +
                '<button class="toast-close" onclick="removeToast(this.parentElement)">✕</button>' +
                '<div class="toast-progress"></div>';
            container.appendChild(toast);
            setTimeout(() => removeToast(toast), 4200);
        }
        function removeToast(toast) {
            toast.classList.add('removing');
            setTimeout(() => toast.remove(), 300);
        }

        /* ═══════════════════════════════════════════════════
           ANIMATED STAT COUNTERS
        ═══════════════════════════════════════════════════ */
        function animateCounter(el, target, suffix = '') {
            let start = 0;
            const duration = 1800;
            const startTime = performance.now();
            function step(now) {
                const elapsed = now - startTime;
                const progress = Math.min(elapsed / duration, 1);
                const eased = 1 - Math.pow(1 - progress, 3);
                el.textContent = Math.round(eased * target) + suffix;
                if (progress < 1) requestAnimationFrame(step);
            }
            requestAnimationFrame(step);
        }

        /* ═══════════════════════════════════════════════════
           INIT
        ═══════════════════════════════════════════════════ */
        window.addEventListener('DOMContentLoaded', () => {
            // Animate hero stats
            setTimeout(() => {
                animateCounter(document.getElementById('statPatients'), 1200, '+');
                animateCounter(document.getElementById('statDoctors'), 24);
                animateCounter(document.getElementById('statYears'), 12);
            }, 600);

            // Show success toast if registration succeeded
            <% if (request.getAttribute("success") != null) { %>
            switchTab('login');
            showToast('Account Created!', 'Welcome to Sunrise Dental. Please sign in.', 'success');
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
            showToast('Login Failed', '<%= request.getAttribute("error") %>', 'error');
            <% } %>
        });
    </script>
</body>
</html>
