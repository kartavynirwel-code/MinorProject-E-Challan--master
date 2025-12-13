<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Challan Issued - FineSnap</title>

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
            max-width: 900px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* ========== SUCCESS CARD ========== */
        .success-card {
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

        /* Success Header */
        .success-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .success-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--accent-success), #059669);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            animation: scaleIn 0.5s ease-out 0.2s backwards;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .success-icon i {
            font-size: 2.5rem;
            color: white;
        }

        .success-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--accent-success);
            margin-bottom: 0.5rem;
        }

        .success-header p {
            font-size: 1rem;
            color: var(--text-secondary);
        }

        .divider {
            height: 1px;
            background: var(--border-color);
            margin: 1.5rem 0;
        }

        /* ========== INFO TABLE ========== */
        .info-section {
            margin: 2rem 0;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title i {
            color: var(--accent-primary);
        }

        .info-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            overflow: hidden;
        }

        .info-table tr {
            transition: var(--transition);
        }

        .info-table tr:hover {
            background: var(--bg-card-hover);
        }

        .info-table th,
        .info-table td {
            padding: 1rem 1.2rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        .info-table tr:last-child th,
        .info-table tr:last-child td {
            border-bottom: none;
        }

        .info-table th {
            font-weight: 600;
            color: var(--text-secondary);
            width: 40%;
            font-size: 0.9rem;
        }

        .info-table th i {
            margin-right: 0.5rem;
        }

        .info-table td {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 1rem;
        }

        /* Highlight amount row */
        .info-table tr.amount-row {
            background: rgba(59, 130, 246, 0.1);
        }

        .info-table tr.amount-row td {
            color: var(--accent-primary);
            font-size: 1.3rem;
            font-weight: 700;
        }

        /* ========== ALERT BOX ========== */
        .alert {
            padding: 1rem 1.2rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            font-size: 0.9rem;
        }

        .alert i {
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .alert-info {
            background: rgba(6, 182, 212, 0.1);
            border: 1px solid rgba(6, 182, 212, 0.3);
            color: var(--accent-secondary);
        }

        /* ========== ACTION BUTTONS ========== */
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        .btn {
            flex: 1;
            min-width: 200px;
            padding: 0.9rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            text-align: center;
        }

        .btn-success {
            background: linear-gradient(135deg, var(--accent-success), #059669);
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
        }

        .btn-primary {
            background: var(--bg-secondary);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .btn-primary:hover {
            background: var(--bg-card-hover);
            border-color: var(--accent-primary);
            transform: translateY(-2px);
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

            .success-card {
                padding: 1.5rem;
            }

            .success-header h2 {
                font-size: 1.5rem;
            }

            .info-table th,
            .info-table td {
                padding: 0.8rem;
                font-size: 0.85rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                min-width: 100%;
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

    <div class="success-card">

        <!-- Success Header -->
        <div class="success-header">
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>
            <h2>Challan Issued Successfully!</h2>
            <p>Traffic violation challan has been recorded in the system</p>
        </div>

        <div class="divider"></div>

        <%
            String vehicleNumber = request.getParameter("vehicleNumber");
            String amount = request.getParameter("amount");
            String description = request.getParameter("description");

            String owner_name = "", owner_mobile = "", owner_address = "";
            String challanNo = "CH" + System.currentTimeMillis();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/echallan", "root", "root");

                // Fetch vehicle owner
                PreparedStatement pst = con.prepareStatement(
                        "SELECT owner_name, owner_mobile, owner_address FROM vehicles WHERE plate = ?"
                );
                pst.setString(1, vehicleNumber);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    owner_name = rs.getString("owner_name");
                    owner_mobile = rs.getString("owner_mobile");
                    owner_address = rs.getString("owner_address");
                }

                // Insert challan with auto-generated challan number
                PreparedStatement insert = con.prepareStatement(
                        "INSERT INTO challans (challan_no, vehicle_plate, fine_amount, description) VALUES (?, ?, ?, ?)"
                );
                insert.setString(1, challanNo);
                insert.setString(2, vehicleNumber);
                insert.setDouble(3, Double.parseDouble(amount));
                insert.setString(4, description);
                insert.executeUpdate();

                con.close();

            } catch (Exception e) {
                // Log error silently for debugging
                System.err.println("Database Error: " + e.getMessage());
                e.printStackTrace();
            }
        %>

        <!-- Challan Number Display -->
        <div class="alert alert-info">
            <i class="fas fa-receipt"></i>
            <span><strong>Challan Number:</strong> <%= challanNo %> - Please save this for your records.</span>
        </div>

        <!-- Vehicle Owner Information -->
        <div class="info-section">
            <h3 class="section-title">
                <i class="fas fa-user"></i>
                Vehicle Owner Details
            </h3>
            <table class="info-table">
                <tr>
                    <th><i class="fas fa-id-card"></i> Owner Name</th>
                    <td><%= owner_name.isEmpty() ? "N/A" : owner_name %></td>
                </tr>
                <tr>
                    <th><i class="fas fa-phone"></i> Contact Number</th>
                    <td><%= owner_mobile.isEmpty() ? "N/A" : owner_mobile %></td>
                </tr>
                <tr>
                    <th><i class="fas fa-map-marker-alt"></i> Address</th>
                    <td><%= owner_address.isEmpty() ? "N/A" : owner_address %></td>
                </tr>
            </table>
        </div>

        <!-- Challan Information -->
        <div class="info-section">
            <h3 class="section-title">
                <i class="fas fa-file-invoice"></i>
                Challan Information
            </h3>
            <table class="info-table">
                <tr>
                    <th><i class="fas fa-car"></i> Vehicle Number</th>
                    <td><%= vehicleNumber %></td>
                </tr>
                <tr>
                    <th><i class="fas fa-exclamation-triangle"></i> Violation Type</th>
                    <td><%= description %></td>
                </tr>
                <tr class="amount-row">
                    <th><i class="fas fa-rupee-sign"></i> Fine Amount</th>
                    <td>₹<%= amount %></td>
                </tr>
            </table>
        </div>

        <!-- Info Alert -->
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <span>The vehicle owner will be notified via SMS. Payment can be made online or at nearest traffic office.</span>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="Payment.jsp?vehicleNumber=<%= vehicleNumber %>&amount=<%= amount %>"
               class="btn btn-success">
                <i class="fas fa-credit-card"></i>
                Process Payment Now
            </a>
            <a href="issueChallan.jsp" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i>
                Issue Another Challan
            </a>
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
</script>

</body>
</html>
