<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Challan - FineSnap</title>

    <!-- ⚡ CRITICAL: Apply saved theme IMMEDIATELY (before CSS loads) -->
    <script>
        (function() {
            var theme = localStorage.getItem('theme') || 'dark';
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
            transition: background 0.3s ease, color 0.3s ease;
            overflow-x: hidden;
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

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .page-header h2 i {
            color: var(--accent-primary);
        }

        .page-header p {
            font-size: 1rem;
            color: var(--text-secondary);
        }

        /* ========== SEARCH BOX ========== */
        .search-box {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-lg);
            animation: slideUp 0.4s ease-out;
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

        .search-box form {
            display: flex;
            gap: 1rem;
            align-items: flex-end;
        }

        .form-group {
            flex: 1;
        }

        .form-group label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .form-group label i {
            color: var(--accent-primary);
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem 1rem;
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            transition: var(--transition);
            text-transform: uppercase;
            font-weight: 600;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .search-btn {
            padding: 0.75rem 1.5rem;
            background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.5);
        }

        /* ========== CHALLAN CARDS ========== */
        .challan-list {
            display: grid;
            gap: 1.5rem;
        }

        .challan-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: var(--shadow-lg);
            transition: var(--transition);
            animation: slideUp 0.6s ease-out;
        }

        .challan-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
            border-color: var(--accent-primary);
        }

        .challan-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .challan-id {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .challan-id label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .challan-id strong {
            font-size: 1.2rem;
            color: var(--accent-primary);
            font-weight: 700;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .status-paid {
            background: rgba(16, 185, 129, 0.15);
            color: var(--accent-success);
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .status-unpaid {
            background: rgba(239, 68, 68, 0.15);
            color: var(--accent-danger);
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .challan-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .detail-item i {
            font-size: 1.2rem;
            color: var(--accent-secondary);
            width: 30px;
        }

        .detail-content label {
            display: block;
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-bottom: 0.2rem;
        }

        .detail-content strong {
            font-size: 1rem;
            color: var(--text-primary);
        }

        .challan-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
        }

        .btn {
            flex: 1;
            padding: 0.75rem 1.2rem;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-pay {
            background: linear-gradient(135deg, var(--accent-success), #059669);
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .btn-pay:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
        }

        .btn-disabled {
            background: var(--bg-secondary);
            color: var(--text-muted);
            border: 1px solid var(--border-color);
            cursor: not-allowed;
            opacity: 0.6;
        }

        /* ========== EMPTY STATE ========== */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            box-shadow: var(--shadow-lg);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--text-muted);
            margin-bottom: 1.5rem;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--text-secondary);
            margin-bottom: 2rem;
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

            .search-box form {
                flex-direction: column;
            }

            .challan-details {
                grid-template-columns: 1fr;
            }

            .challan-header {
                flex-direction: column;
                gap: 1rem;
            }

            .challan-actions {
                flex-direction: column;
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

        <a href="pay.html" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Back to Home
        </a>
    </div>
</header>

<!-- ========== MAIN CONTENT ========== -->
<div class="main-container">

    <!-- Page Header -->
    <div class="page-header">
        <h2>
            <i class="fas fa-file-invoice"></i>
            View Challans
        </h2>
        <p>Search and view your traffic violation records</p>
    </div>

    <!-- Search Box -->
    <div class="search-box">
        <form method="get" action="viewChallan.jsp">
            <div class="form-group">
                <label>
                    <i class="fas fa-car"></i>
                    Vehicle Number
                </label>
                <input type="text"
                       name="vehiclePlate"
                       id="vehicleInput"
                       placeholder="e.g., MH12AB1234"
                       value="<%= request.getParameter("vehiclePlate") != null ? request.getParameter("vehiclePlate") : "" %>"
                       maxlength="13"
                       required>
            </div>
            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i>
                Search
            </button>
        </form>
    </div>

    <!-- Challan List -->
    <div class="challan-list">
        <%
            String vehiclePlate = request.getParameter("vehiclePlate");

            if (vehiclePlate != null && !vehiclePlate.trim().isEmpty()) {
                vehiclePlate = vehiclePlate.toUpperCase().trim();

                String jdbcUrl = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
                String dbUser = "root";
                String dbPass = "root";

                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                boolean foundChallans = false;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

                    // Query matching your database schema
                    String query = "SELECT c.id, c.challan_no, c.vehicle_plate, c.fine_amount, " +
                            "c.description, c.status, c.created_at, c.paid_at, " +
                            "v.owner_name, v.owner_mobile " +
                            "FROM challans c " +
                            "LEFT JOIN vehicles v ON c.vehicle_plate = v.plate " +
                            "WHERE c.vehicle_plate = ? ORDER BY c.created_at DESC";

                    ps = con.prepareStatement(query);
                    ps.setString(1, vehiclePlate);
                    rs = ps.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

                    while (rs.next()) {
                        foundChallans = true;
                        int challanId = rs.getInt("id");
                        String challanNo = rs.getString("challan_no");
                        double fineAmount = rs.getDouble("fine_amount");
                        String description = rs.getString("description");
                        String status = rs.getString("status");
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        Timestamp paidAt = rs.getTimestamp("paid_at");
                        String ownerName = rs.getString("owner_name");
                        String ownerMobile = rs.getString("owner_mobile");

                        boolean isPaid = "Paid".equalsIgnoreCase(status);
        %>

        <!-- Challan Card -->
        <div class="challan-card">
            <div class="challan-header">
                <div class="challan-id">
                    <label>Challan Number</label>
                    <strong><%= challanNo != null ? challanNo : "CH" + String.format("%06d", challanId) %></strong>
                </div>
                <div class="status-badge <%= isPaid ? "status-paid" : "status-unpaid" %>">
                    <i class="fas fa-<%= isPaid ? "check-circle" : "exclamation-circle" %>"></i>
                    <%= status %>
                </div>
            </div>

            <div class="challan-details">
                <div class="detail-item">
                    <i class="fas fa-car"></i>
                    <div class="detail-content">
                        <label>Vehicle Number</label>
                        <strong><%= vehiclePlate %></strong>
                    </div>
                </div>

                <% if (ownerName != null) { %>
                <div class="detail-item">
                    <i class="fas fa-user"></i>
                    <div class="detail-content">
                        <label>Owner Name</label>
                        <strong><%= ownerName %></strong>
                    </div>
                </div>
                <% } %>

                <% if (ownerMobile != null) { %>
                <div class="detail-item">
                    <i class="fas fa-phone"></i>
                    <div class="detail-content">
                        <label>Mobile Number</label>
                        <strong><%= ownerMobile %></strong>
                    </div>
                </div>
                <% } %>

                <div class="detail-item">
                    <i class="fas fa-rupee-sign"></i>
                    <div class="detail-content">
                        <label>Fine Amount</label>
                        <strong>₹<%= String.format("%.2f", fineAmount) %></strong>
                    </div>
                </div>

                <div class="detail-item">
                    <i class="fas fa-calendar"></i>
                    <div class="detail-content">
                        <label>Issue Date</label>
                        <strong><%= sdf.format(createdAt) %></strong>
                    </div>
                </div>

                <% if (isPaid && paidAt != null) { %>
                <div class="detail-item">
                    <i class="fas fa-check-circle"></i>
                    <div class="detail-content">
                        <label>Paid Date</label>
                        <strong><%= sdf.format(paidAt) %></strong>
                    </div>
                </div>
                <% } %>

                <div class="detail-item" style="grid-column: 1 / -1;">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div class="detail-content">
                        <label>Violation Description</label>
                        <strong><%= description != null ? description : "Traffic Violation" %></strong>
                    </div>
                </div>
            </div>

            <div class="challan-actions">
                <% if (!isPaid) { %>
                <a href="Payment.jsp?challanId=<%= challanId %>" class="btn btn-pay">
                    <i class="fas fa-credit-card"></i>
                    Pay Now - ₹<%= String.format("%.0f", fineAmount) %>
                </a>
                <% } else { %>
                <button class="btn btn-disabled" disabled>
                    <i class="fas fa-check-circle"></i>
                    Already Paid
                </button>
                <% } %>
            </div>
        </div>

        <%
            }

            if (!foundChallans) {
        %>
        <!-- No Challans Found -->
        <div class="empty-state">
            <i class="fas fa-inbox"></i>
            <h3>No Challans Found</h3>
            <p>No challan records found for vehicle number: <strong><%= vehiclePlate %></strong></p>
            <a href="viewChallan.jsp" class="search-btn" style="display: inline-flex; text-decoration: none;">
                <i class="fas fa-search"></i>
                Search Again
            </a>
        </div>
        <%
            }

        } catch (Exception e) {
            e.printStackTrace();
        %>
        <div class="empty-state">
            <i class="fas fa-exclamation-circle" style="color: var(--accent-danger);"></i>
            <h3>Database Error</h3>
            <p>Unable to fetch challan records. Please try again later.</p>
            <p style="font-size: 0.85rem; color: var(--text-muted);"><%= e.getMessage() %></p>
        </div>
        <%
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (ps != null) try { ps.close(); } catch (SQLException e) {}
                    if (con != null) try { con.close(); } catch (SQLException e) {}
                }
            }
        %>
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
        var themeToggle = document.getElementById('themeToggle');
        var htmlElement = document.documentElement;

        themeToggle.addEventListener('click', function() {
            var currentTheme = htmlElement.getAttribute('data-theme') === 'light' ? 'dark' : 'light';

            if (currentTheme === 'light') {
                htmlElement.setAttribute('data-theme', 'light');
            } else {
                htmlElement.removeAttribute('data-theme');
            }

            localStorage.setItem('theme', currentTheme);
            console.log('Theme changed to: ' + currentTheme);
        });
    })();

    // ========== AUTO UPPERCASE INPUT ==========
    var vehicleInput = document.getElementById('vehicleInput');

    if (vehicleInput) {
        vehicleInput.addEventListener('input', function(e) {
            e.target.value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
        });
    }
</script>

</body>
</html>
