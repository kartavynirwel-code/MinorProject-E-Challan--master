<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*,java.util.*" %>
<%
    // Use a different local variable name to avoid colliding with
    // the JSP implicit "session" variable.
    javax.servlet.http.HttpSession sess = request.getSession(false);

    if (sess == null || sess.getAttribute("userId") == null) {
        // not logged in -> redirect to login
        response.sendRedirect("login.html");
        return;
    }

    // session values (set by LoginServlet)
    Integer userId = (Integer) sess.getAttribute("userId");
    String sessionUsername = (String) sess.getAttribute("username");

    // defaults to show if DB lookup fails
    String name = "";
    String role = "";
    String mobile = "";
    String photoPath = null; // relative path e.g. "uploads/officer1.jpg"
    String bio = "";

    int totalChallans = 0;
    List<Map<String,Object>> recentChallans = new ArrayList<>();

    // DB config (update if your DB credentials differ)
    String jdbcUrl = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = "root";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection con = DriverManager.getConnection(jdbcUrl, dbUser, dbPass)) {

            // load user/officer details
            String qUser = "SELECT username, name, role, mobile, photo_path, bio FROM users WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(qUser)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        sessionUsername = rs.getString("username");
                        name = rs.getString("name");
                        role = rs.getString("role");
                        mobile = rs.getString("mobile");
                        photoPath = rs.getString("photo_path");
                        bio = rs.getString("bio");
                    }
                }
            }

            // total challans created by this user
            String qCount = "SELECT COUNT(*) FROM challans WHERE created_by = ?";
            try (PreparedStatement ps = con.prepareStatement(qCount)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalChallans = rs.getInt(1);
                }
            }

            // recent challans (last 10)
            String qRecent = "SELECT id, challan_no, vehicle_plate, fine_amount, status, created_at FROM challans WHERE created_by = ? ORDER BY created_at DESC LIMIT 10";
            try (PreparedStatement ps = con.prepareStatement(qRecent)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String,Object> row = new HashMap<>();
                        row.put("id", rs.getInt("id"));
                        row.put("challan_no", rs.getString("challan_no"));
                        row.put("vehicle_plate", rs.getString("vehicle_plate"));
                        row.put("fine_amount", rs.getDouble("fine_amount"));
                        row.put("status", rs.getString("status"));
                        row.put("created_at", rs.getTimestamp("created_at"));
                        recentChallans.add(row);
                    }
                }
            }

        } // connection closed
    } catch (Exception e) {
        // show basic error info (you can log to server log)
        out.println("<div class='alert alert-danger'>Error loading profile: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }

    // Build photo URL: if photoPath is relative, prepend context path
    String photoUrl = null;
    if (photoPath != null && !photoPath.trim().isEmpty()) {
        if (photoPath.startsWith("http://") || photoPath.startsWith("https://")) {
            photoUrl = photoPath;
        } else {
            photoUrl = request.getContextPath() + "/" + photoPath;
        }
    } else {
        // fallback avatar
        photoUrl = request.getContextPath() + "/default_profile.jpg";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Officer Profile - <%= (name==null || name.isEmpty()) ? sessionUsername : name %></title>

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
            gap: 1rem;
        }

        .header-logo {
            height: 50px;
            filter: drop-shadow(0 2px 8px rgba(59, 130, 246, 0.4));
        }

        .header-title h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
        }

        .subtitle {
            font-size: 0.75rem;
            color: var(--text-secondary);
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
            transition: var(--transition);
        }

        .back-btn:hover {
            background: var(--bg-card-hover);
            border-color: var(--accent-primary);
            transform: translateY(-2px);
        }

        /* ========== MAIN CONTAINER ========== */
        .container {
            max-width: 1400px;
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
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: var(--text-secondary);
        }

        /* ========== PROFILE LAYOUT ========== */
        .profile-grid {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 2rem;
        }

        /* Profile Card */
        .profile-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: var(--shadow-lg);
            text-align: center;
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

        .profile-photo {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid var(--accent-primary);
            object-fit: cover;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-md);
        }

        .profile-card h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .profile-meta {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
            margin: 1.5rem 0;
            text-align: left;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding: 0.8rem;
            background: var(--bg-secondary);
            border-radius: 8px;
            transition: var(--transition);
        }

        .meta-item:hover {
            background: var(--bg-card-hover);
        }

        .meta-item i {
            color: var(--accent-primary);
            width: 20px;
        }

        .bio-section {
            margin: 1.5rem 0;
            text-align: left;
        }

        .bio-section h4 {
            font-size: 1rem;
            margin-bottom: 0.5rem;
            color: var(--text-secondary);
        }

        .bio-text {
            font-size: 0.9rem;
            color: var(--text-muted);
            line-height: 1.6;
        }

        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
            margin-top: 1.5rem;
        }

        .btn {
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: var(--accent-primary);
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background: var(--accent-secondary);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-secondary {
            background: var(--bg-secondary);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: var(--bg-card-hover);
            border-color: var(--accent-primary);
        }

        /* Stats & Content Section */
        .content-section {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .stats-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: var(--shadow-lg);
            animation: slideUp 0.6s ease-out;
        }

        .stats-card h4 {
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .stats-card h4 i {
            color: var(--accent-primary);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .stat-box {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            transition: var(--transition);
        }

        .stat-box:hover {
            transform: translateY(-4px);
            border-color: var(--accent-primary);
            box-shadow: var(--shadow-md);
        }

        .stat-box h3 {
            font-size: 2.5rem;
            color: var(--accent-primary);
            margin-bottom: 0.5rem;
        }

        .stat-box p {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        /* Recent Challans Table */
        .table-wrapper {
            overflow-x: auto;
            margin-top: 1.5rem;
        }

        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            overflow: hidden;
        }

        .table thead {
            background: var(--bg-card-hover);
        }

        .table th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 0.9rem;
            border-bottom: 1px solid var(--border-color);
        }

        .table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-primary);
        }

        .table tbody tr {
            transition: var(--transition);
        }

        .table tbody tr:hover {
            background: var(--bg-card-hover);
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        .status-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-pending {
            background: rgba(245, 158, 11, 0.1);
            color: var(--accent-warning);
        }

        .status-paid {
            background: rgba(16, 185, 129, 0.1);
            color: var(--accent-success);
        }

        .btn-sm {
            padding: 0.4rem 0.8rem;
            font-size: 0.85rem;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            transition: var(--transition);
            margin-right: 0.5rem;
        }

        .btn-sm.btn-primary {
            background: var(--accent-primary);
            color: white;
        }

        .btn-sm.btn-success {
            background: var(--accent-success);
            color: white;
        }

        .btn-sm:hover {
            transform: translateY(-2px);
            opacity: 0.9;
        }

        /* Footer */
        footer {
            background: var(--bg-secondary);
            border-top: 1px solid var(--border-color);
            padding: 1.5rem;
            margin-top: 4rem;
            text-align: center;
            color: var(--text-secondary);
        }

        /* Responsive */
        @media (max-width: 992px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            header {
                flex-direction: column;
                gap: 1rem;
            }

            .theme-toggle {
                width: 45px;
                height: 45px;
            }

            .theme-icon {
                font-size: 1.2rem;
            }

            .table {
                font-size: 0.85rem;
            }

            .table th,
            .table td {
                padding: 0.7rem 0.5rem;
            }
        }

        /* Scrollbar */
        ::-webkit-scrollbar {
            width: 10px;
            height: 10px;
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
<div class="container">

    <div class="page-header">
        <h2>Officer Profile</h2>
        <p>Welcome, <strong><%= (name==null||name.isEmpty())?sessionUsername:name %></strong></p>
    </div>

    <div class="profile-grid">

        <!-- Left: Profile Card -->
        <div class="profile-card">
            <img src="<%= photoUrl %>" alt="Officer Photo" class="profile-photo">
            <h3><%= (name==null||name.isEmpty())?sessionUsername:name %></h3>

            <div class="profile-meta">
                <div class="meta-item">
                    <i class="fas fa-shield-alt"></i>
                    <span><strong>Role:</strong> <%= (role==null?"POLICE":role) %></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-phone"></i>
                    <span><strong>Mobile:</strong> <%= (mobile==null?"-":mobile) %></span>
                </div>
                <div class="meta-item">
                    <i class="fas fa-user"></i>
                    <span><strong>Username:</strong> <%= sessionUsername %></span>
                </div>
            </div>

            <div class="bio-section">
                <h4><i class="fas fa-info-circle"></i> Bio</h4>
                <p class="bio-text"><%= (bio==null || bio.trim().isEmpty()) ? "No bio provided." : bio %></p>
            </div>

            <div class="action-buttons">
                <a href="editProfile.jsp" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Edit Profile
                </a>
                <a href="dashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-th-large"></i> Dashboard
                </a>
            </div>
        </div>

        <!-- Right: Stats & Recent Challans -->
        <div class="content-section">

            <!-- Stats Card -->
            <div class="stats-card">
                <h4><i class="fas fa-chart-bar"></i> Statistics</h4>
                <div class="stats-grid">
                    <div class="stat-box">
                        <h3><%= totalChallans %></h3>
                        <p>Challans Issued</p>
                    </div>
                    <div class="stat-box">
                        <h3><%= recentChallans.size() %></h3>
                        <p>Recent Activity</p>
                    </div>
                    <div class="stat-box">
                        <h3>Active</h3>
                        <p>Status</p>
                    </div>
                </div>
            </div>

            <!-- Recent Challans -->
            <div class="stats-card">
                <h4><i class="fas fa-file-invoice"></i> Recent Challans</h4>
                <div class="table-wrapper">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>No</th>
                            <th>Challan No</th>
                            <th>Vehicle</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Issued At</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (recentChallans.isEmpty()) {
                        %>
                        <tr><td colspan="7" style="text-align:center; color: var(--text-muted);">No recent challans</td></tr>
                        <%
                        } else {
                            int idx = 1;
                            for (Map<String,Object> r : recentChallans) {
                                String status = (String) r.get("status");
                                String statusClass = (status != null && status.equalsIgnoreCase("paid")) ? "status-paid" : "status-pending";
                        %>
                        <tr>
                            <td><%= idx++ %></td>
                            <td><%= r.get("challan_no") %></td>
                            <td><%= r.get("vehicle_plate") %></td>
                            <td>₹<%= r.get("fine_amount") %></td>
                            <td><span class="status-badge <%= statusClass %>"><%= status == null ? "PENDING" : status.toUpperCase() %></span></td>
                            <td><%= r.get("created_at") %></td>
                            <td>
                                <a class="btn-sm btn-primary" href="viewChallan.jsp?id=<%= r.get("id") %>">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <a class="btn-sm btn-success" href="Payment.jsp?vehicleNumber=<%= r.get("vehicle_plate") %>&amount=<%= r.get("fine_amount") %>">
                                    <i class="fas fa-credit-card"></i> Pay
                                </a>
                            </td>
                        </tr>
                        <%
                                } // for
                            } // else
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

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

