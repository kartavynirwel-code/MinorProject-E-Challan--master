<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment - FineSnap</title>

    <!-- ⚡ CRITICAL: Apply saved theme IMMEDIATELY (before CSS loads) -->
    <script>
        (function() {
            const theme = localStorage.getItem('theme') || 'dark';
            if (theme === 'light') {
                document.documentElement.setAttribute('data-theme', 'light');
            }
        })();
    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        /* ========== IMPORTS ========== */
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

        /* ========== ROOT VARIABLES (DARK THEME - DEFAULT) ========== */
        :root {
            --bg-primary: #0a0e27;
            --bg-secondary: #141b2d;
            --bg-card: #1a2035;
            --bg-card-hover: #1f2742;
            --accent-primary: #3b82f6;
            --accent-secondary: #06b6d4;
            --accent-success: #10b981;
            --accent-warning: #f59e0b;
            --accent-danger: #ef4444;
            --text-primary: #ffffff;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            --border-color: #2d3548;
            --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.4);
            --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.5);
            --shadow-xl: 0 12px 48px rgba(0, 0, 0, 0.6);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* ========== LIGHT THEME VARIABLES ========== */
        [data-theme="light"] {
            --bg-primary: #f5f7fa;
            --bg-secondary: #ffffff;
            --bg-card: #ffffff;
            --bg-card-hover: #f8fafc;
            --accent-primary: #2563eb;
            --accent-secondary: #0891b2;
            --accent-success: #059669;
            --accent-warning: #d97706;
            --accent-danger: #dc2626;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.08);
            --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.12);
            --shadow-xl: 0 12px 48px rgba(0, 0, 0, 0.15);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
            overflow-x: hidden;
            transition: background 0.3s ease, color 0.3s ease;
        }

        /* ========== HEADER ========== */
        header {
            background: var(--bg-secondary);
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: var(--shadow-md);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 1.2rem;
        }

        .header-logo {
            height: 50px;
            width: auto;
            filter: drop-shadow(0 2px 8px rgba(59, 130, 246, 0.4));
            transition: var(--transition);
        }

        .header-logo:hover {
            transform: scale(1.05);
        }

        .header-title h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            letter-spacing: -0.5px;
            margin-bottom: 0.1rem;
        }

        .subtitle {
            font-size: 0.75rem;
            color: var(--text-secondary);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        /* ========== THEME TOGGLE BUTTON ========== */
        .theme-toggle {
            position: relative;
            width: 50px;
            height: 50px;
            background: var(--bg-card);
            border: 2px solid var(--border-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: var(--transition);
            padding: 0;
        }

        .theme-toggle:hover {
            transform: scale(1.1) rotate(15deg);
            border-color: var(--accent-primary);
            box-shadow: var(--shadow-md);
        }

        .theme-toggle:active {
            transform: scale(0.95);
        }

        .theme-icon {
            position: absolute;
            font-size: 1.4rem;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        :root .theme-icon.fa-sun {
            opacity: 1;
            transform: rotate(0deg) scale(1);
            color: #fbbf24;
        }

        :root .theme-icon.fa-moon {
            opacity: 0;
            transform: rotate(180deg) scale(0);
            color: #60a5fa;
        }

        [data-theme="light"] .theme-icon.fa-sun {
            opacity: 0;
            transform: rotate(-180deg) scale(0);
        }

        [data-theme="light"] .theme-icon.fa-moon {
            opacity: 1;
            transform: rotate(0deg) scale(1);
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.6rem 1.2rem;
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .back-btn:hover {
            background: var(--bg-card-hover);
            border-color: var(--accent-primary);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* ========== MAIN CONTAINER ========== */
        .main-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .page-header p {
            font-size: 1rem;
            color: var(--text-secondary);
        }

        /* ========== PAYMENT CARD ========== */
        .payment-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2.5rem;
            box-shadow: var(--shadow-lg);
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ========== PAYMENT SUMMARY ========== */
        .payment-summary {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-label {
            font-size: 0.95rem;
            color: var(--text-secondary);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .summary-label i {
            color: var(--accent-primary);
        }

        .summary-value {
            font-size: 1rem;
            color: var(--text-primary);
            font-weight: 700;
        }

        .summary-item.total {
            background: rgba(59, 130, 246, 0.1);
            margin: 1rem -1.5rem -1.5rem;
            padding: 1.2rem 1.5rem;
            border-radius: 0 0 12px 12px;
        }

        .summary-item.total .summary-value {
            font-size: 1.5rem;
            color: var(--accent-primary);
        }

        /* ========== PAYMENT METHODS ========== */
        .payment-methods {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: var(--accent-primary);
        }

        /* Card Payment Form */
        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        label i {
            color: var(--accent-primary);
            margin-right: 0.5rem;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 0.75rem 1rem;
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            transition: var(--transition);
        }

        input[type="text"]:focus,
        input[type="number"]:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        input[type="text"]::placeholder {
            color: var(--text-muted);
        }

        /* QR Code Section */
        .qr-section {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            margin-bottom: 2rem;
        }

        .qr-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--accent-success);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .qr-code-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1.5rem;
        }

        .qr-code-wrapper {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow-md);
            display: inline-block;
        }

        .qr-code-wrapper img {
            width: 220px;
            height: 220px;
            display: block;
        }

        .qr-instructions {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
        }

        .upi-id-box {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.3);
            border-radius: 8px;
            padding: 0.9rem 1.5rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            font-weight: 600;
            color: var(--accent-success);
            font-size: 1rem;
            min-width: 280px;
        }

        .upi-id-box i {
            font-size: 1.3rem;
        }

        .divider {
            position: relative;
            text-align: center;
            margin: 2.5rem 0;
        }

        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background: var(--border-color);
        }

        .divider span {
            position: relative;
            background: var(--bg-card);
            padding: 0 1rem;
            color: var(--text-muted);
            font-weight: 600;
            font-size: 0.9rem;
        }

        /* ========== SUBMIT BUTTON ========== */
        .submit-btn {
            width: 100%;
            padding: 1rem 1.5rem;
            background: linear-gradient(135deg, var(--accent-success), #059669);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .submit-btn i {
            font-size: 1.2rem;
        }

        /* ========== SECURITY NOTE ========== */
        .security-note {
            background: rgba(6, 182, 212, 0.1);
            border: 1px solid rgba(6, 182, 212, 0.3);
            border-radius: 8px;
            padding: 1rem 1.2rem;
            margin-top: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .security-note i {
            font-size: 1.2rem;
            color: var(--accent-secondary);
            flex-shrink: 0;
        }

        /* ========== FOOTER ========== */
        footer {
            background: var(--bg-secondary);
            border-top: 1px solid var(--border-color);
            padding: 1.5rem;
            margin-top: 4rem;
            text-align: center;
        }

        footer p {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        /* ========== RESPONSIVE ========== */
        @media (max-width: 768px) {
            header {
                flex-direction: column;
                gap: 1rem;
            }

            .main-container {
                padding: 0 1rem;
            }

            .payment-card {
                padding: 1.5rem;
            }

            .page-header h2 {
                font-size: 1.5rem;
            }

            .qr-code-wrapper img {
                width: 180px;
                height: 180px;
            }

            .upi-id-box {
                min-width: auto;
                font-size: 0.9rem;
            }

            .theme-toggle {
                width: 45px;
                height: 45px;
            }

            .theme-icon {
                font-size: 1.2rem;
            }
        }

        /* ========== SCROLLBAR ========== */
        ::-webkit-scrollbar {
            width: 10px;
        }

        ::-webkit-scrollbar-track {
            background: var(--bg-secondary);
        }

        ::-webkit-scrollbar-thumb {
            background: var(--border-color);
            border-radius: 5px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: var(--accent-primary);
        }
    </style>
</head>

<body>

<!-- ========== HEADER ========== -->
<header>
    <div class="header-left">
        <img src="finesnap_logo.png" alt="FineSnap Logo" class="header-logo">
        <div class="header-title">
            <h1>FineSnap</h1>
            <span class="subtitle">Traffic Management System</span>
        </div>
    </div>

    <div class="header-right">
        <!-- Theme Toggle Button -->
        <button class="theme-toggle" id="themeToggle" aria-label="Toggle theme" title="Toggle Theme">
            <i class="fas fa-sun theme-icon"></i>
            <i class="fas fa-moon theme-icon"></i>
        </button>

        <a href="dashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Back to Dashboard
        </a>
    </div>
</header>

<!-- ========== MAIN CONTENT ========== -->
<div class="main-container">

    <!-- Page Header -->
    <div class="page-header">
        <h2>Make Payment</h2>
        <p>Complete your challan payment securely</p>
    </div>

    <div class="payment-card">

        <%
            String vehicleNumber = request.getParameter("vehicleNumber");
            String amount = request.getParameter("amount");
        %>

        <!-- Payment Summary -->
        <div class="payment-summary">
            <div class="summary-item">
                <div class="summary-label">
                    <i class="fas fa-car"></i>
                    Vehicle Number
                </div>
                <div class="summary-value"><%= vehicleNumber %></div>
            </div>
            <div class="summary-item total">
                <div class="summary-label">
                    <i class="fas fa-rupee-sign"></i>
                    Total Amount
                </div>
                <div class="summary-value">₹<%= amount %></div>
            </div>
        </div>

        <!-- Payment Form -->
        <div class="payment-methods">
            <h3 class="section-title">
                <i class="fas fa-credit-card"></i>
                Card Payment
            </h3>

            <form action="ProcessPaymentServlet" method="post">
                <input type="hidden" name="vehicleNumber" value="<%= vehicleNumber %>">
                <input type="hidden" name="amount" value="<%= amount %>">

                <div class="form-group">
                    <label><i class="fas fa-credit-card"></i> Card Number</label>
                    <input type="text" name="cardNumber" placeholder="1234 5678 9012 3456"
                           maxlength="19" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-user"></i> Cardholder Name</label>
                    <input type="text" name="cardName" placeholder="Enter name on card" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label><i class="fas fa-calendar"></i> Expiry Date</label>
                        <input type="text" name="expiryDate" placeholder="MM/YY"
                               maxlength="5" required>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-lock"></i> CVV</label>
                        <input type="text" name="cvv" placeholder="123"
                               maxlength="3" required>
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-lock"></i>
                    Pay ₹<%= amount %> Now
                </button>
            </form>
        </div>

        <!-- Divider -->
        <div class="divider">
            <span>OR PAY VIA UPI</span>
        </div>

        <!-- QR Code Section -->
        <div class="qr-section">
            <h3 class="qr-title">
                <i class="fas fa-qrcode"></i>
                Scan QR Code
            </h3>

            <div class="qr-code-container">
                <p class="qr-instructions">Scan this QR using any UPI app</p>

                <div class="qr-code-wrapper">
                    <img src="QR.jpg" alt="UPI QR Code">
                </div>

                <div class="upi-id-box">
                    <i class="fab fa-google-pay"></i>
                    Finesnap112@okhdfcbank
                </div>
            </div>
        </div>

        <!-- Security Note -->
        <div class="security-note">
            <i class="fas fa-shield-alt"></i>
            <span>Your payment is secure and encrypted. We never store your card details.</span>
        </div>

    </div>

</div>

<!-- ========== FOOTER ========== -->
<footer>
    <p>&copy; 2025 FineSnap Traffic Management System. All Rights Reserved.</p>
</footer>

<!-- ========== JAVASCRIPT ========== -->
<script>
    // ========== THEME TOGGLE FUNCTIONALITY ==========
    (function() {
        const themeToggle = document.getElementById('themeToggle');
        const htmlElement = document.documentElement;

        // Toggle theme on click
        themeToggle.addEventListener('click', function() {
            const currentTheme = htmlElement.getAttribute('data-theme') === 'light' ? 'dark' : 'light';

            if (currentTheme === 'light') {
                htmlElement.setAttribute('data-theme', 'light');
            } else {
                htmlElement.removeAttribute('data-theme');
            }

            localStorage.setItem('theme', currentTheme);
            console.log('✅ Theme changed to:', currentTheme);
        });
    })();

    // ========== CARD NUMBER FORMATTING ==========
    document.querySelector('input[name="cardNumber"]').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\s/g, '');
        let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
        e.target.value = formattedValue;
    });

    // ========== EXPIRY DATE FORMATTING ==========
    document.querySelector('input[name="expiryDate"]').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length >= 2) {
            e.target.value = value.slice(0, 2) + '/' + value.slice(2, 4);
        } else {
            e.target.value = value;
        }
    });

    // ========== CVV VALIDATION ==========
    document.querySelector('input[name="cvv"]').addEventListener('input', function(e) {
        e.target.value = e.target.value.replace(/\D/g, '');
    });
</script>

</body>
</html>
