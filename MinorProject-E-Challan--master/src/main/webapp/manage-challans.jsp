<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // ✅ Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // ✅ Check session
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Challans - FineSnap</title>

    <!-- Theme Script -->
    <script>
        (function() {
            const theme = localStorage.getItem('theme') || 'dark';
            if (theme === 'light') {
                document.documentElement.setAttribute('data-theme', 'light');
            }
        })();
    </script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css" rel="stylesheet" />

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

        :root {
            --bg-primary: #0a0e27;
            --bg-secondary: #141b2d;
            --bg-card: #1a2035;
            --bg-input: #1f2742;
            --accent-primary: #3b82f6;
            --accent-success: #10b981;
            --accent-danger: #ef4444;
            --accent-warning: #f59e0b;
            --text-primary: #ffffff;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            --border-color: #2d3548;
            --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.4);
        }

        [data-theme="light"] {
            --bg-primary: #f5f7fa;
            --bg-secondary: #ffffff;
            --bg-card: #ffffff;
            --bg-input: #f8fafc;
            --accent-primary: #2563eb;
            --accent-success: #059669;
            --accent-danger: #dc2626;
            --accent-warning: #d97706;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            min-height: 100vh;
            transition: background 0.3s ease;
        }

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

        .header-left h1 {
            font-size: 1.5rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .header-left h1 i {
            color: var(--accent-primary);
        }

        .header-right {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .theme-toggle {
            width: 50px;
            height: 50px;
            background: var(--bg-card);
            border: 2px solid var(--border-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .theme-toggle:hover {
            transform: scale(1.1) rotate(15deg);
            border-color: var(--accent-primary);
        }

        .theme-icon {
            position: absolute;
            font-size: 1.4rem;
            transition: all 0.4s ease;
        }

        :root .theme-icon.fa-sun {
            opacity: 1;
            transform: scale(1);
            color: #fbbf24;
        }

        :root .theme-icon.fa-moon {
            opacity: 0;
            transform: scale(0);
            color: #60a5fa;
        }

        [data-theme="light"] .theme-icon.fa-sun {
            opacity: 0;
            transform: scale(0);
        }

        [data-theme="light"] .theme-icon.fa-moon {
            opacity: 1;
            transform: scale(1);
        }

        .back-btn {
            padding: 0.6rem 1.2rem;
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            border-color: var(--accent-primary);
            transform: translateY(-2px);
        }

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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
        }

        .stat-icon.total {
            background: rgba(59, 130, 246, 0.2);
            color: var(--accent-primary);
        }

        .stat-icon.paid {
            background: rgba(16, 185, 129, 0.2);
            color: var(--accent-success);
        }

        .stat-icon.unpaid {
            background: rgba(239, 68, 68, 0.2);
            color: var(--accent-danger);
        }

        .stat-info h3 {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .stat-info p {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .filter-bar {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .filter-bar input,
        .filter-bar select {
            padding: 0.7rem 1rem;
            background: var(--bg-input);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            min-width: 200px;
            flex: 1;
        }

        .filter-bar input::placeholder {
            color: var(--text-muted);
        }

        .filter-bar input:focus,
        .filter-bar select:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .table-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: var(--shadow-md);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: var(--bg-input);
        }

        th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        td {
            padding: 1rem;
            border-top: 1px solid var(--border-color);
            white-space: nowrap;
        }

        tbody tr {
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background: var(--bg-input);
        }

        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }

        .status-badge.paid {
            background: rgba(16, 185, 129, 0.2);
            color: var(--accent-success);
        }

        .status-badge.unpaid {
            background: rgba(239, 68, 68, 0.2);
            color: var(--accent-danger);
        }

        .action-btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .mark-paid-btn {
            background: var(--accent-success);
            color: white;
        }

        .mark-paid-btn:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
        }

        .mark-unpaid-btn {
            background: var(--accent-danger);
            color: white;
        }

        .mark-unpaid-btn:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(239, 68, 68, 0.3);
        }

        .success-message {
            background: rgba(16, 185, 129, 0.2);
            border: 1px solid var(--accent-success);
            color: var(--accent-success);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            display: none;
            align-items: center;
            gap: 0.5rem;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .error-message {
            background: rgba(239, 68, 68, 0.2);
            border: 1px solid var(--accent-danger);
            color: var(--accent-danger);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-secondary);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--text-muted);
            margin-bottom: 1rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 0 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .filter-bar {
                flex-direction: column;
            }

            .filter-bar input,
            .filter-bar select {
                width: 100%;
            }

            table {
                font-size: 0.85rem;
            }

            th, td {
                padding: 0.7rem 0.5rem;
            }
        }
    </style>
</head>
<body>

<header>
    <div class="header-left">
        <h1>
            <i class="ri-file-list-3-line"></i>
            Manage Challans
        </h1>
    </div>
    <div class="header-right">
        <button class="theme-toggle" id="themeToggle">
            <i class="fas fa-sun theme-icon"></i>
            <i class="fas fa-moon theme-icon"></i>
        </button>
        <a href="dashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</header>

<div class="container">
    <div class="page-header">
        <h2>Challan Management System</h2>
        <p style="color: var(--text-secondary);">View and update challan payment status</p>
    </div>

    <div id="successMessage" class="success-message">
        <i class="fas fa-check-circle"></i>
        <span>Status updated successfully!</span>
    </div>

    <%
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        int totalChallans = 0;
        int paidChallans = 0;
        int unpaidChallans = 0;
        double totalAmount = 0;
        boolean hasError = false;
        String errorMessage = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/echallan", "root", "root");
            st = con.createStatement();

            // Get statistics
            rs = st.executeQuery("SELECT COUNT(*) as total, " +
                    "SUM(CASE WHEN status = 'PAID' THEN 1 ELSE 0 END) as paid, " +
                    "SUM(CASE WHEN status = 'UNPAID' THEN 1 ELSE 0 END) as unpaid, " +
                    "SUM(fine_amount) as total_amount FROM challans");
            if (rs.next()) {
                totalChallans = rs.getInt("total");
                paidChallans = rs.getInt("paid");
                unpaidChallans = rs.getInt("unpaid");
                totalAmount = rs.getDouble("total_amount");
            }
    %>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon total">
                <i class="fas fa-file-invoice"></i>
            </div>
            <div class="stat-info">
                <h3><%= totalChallans %></h3>
                <p>Total Challans</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon paid">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-info">
                <h3><%= paidChallans %></h3>
                <p>Paid Challans</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon unpaid">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <div class="stat-info">
                <h3><%= unpaidChallans %></h3>
                <p>Unpaid Challans</p>
            </div>
        </div>
    </div>

    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="🔍 Search by Challan No or Vehicle Plate..." onkeyup="filterTable()">
        <select id="statusFilter" onchange="filterTable()">
            <option value="">All Status</option>
            <option value="PAID">Paid Only</option>
            <option value="UNPAID">Unpaid Only</option>
        </select>
    </div>

    <div class="table-card">
        <% if (totalChallans > 0) { %>
        <table id="challanTable">
            <thead>
            <tr>
                <th>Challan No</th>
                <th>Vehicle Plate</th>
                <th>Fine Amount</th>
                <th>Description</th>
                <th>Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <%
                // ✅ Using actual column names from your database
                rs = st.executeQuery("SELECT challan_no, vehicle_plate, fine_amount, description, " +
                        "DATE_FORMAT(created_at, '%d-%m-%Y') as challan_date, " +
                        "status FROM challans ORDER BY created_at DESC");
                while (rs.next()) {
                    String challanNo = rs.getString("challan_no");
                    String vehiclePlate = rs.getString("vehicle_plate");
                    double fineAmount = rs.getDouble("fine_amount");
                    String description = rs.getString("description");
                    String challanDate = rs.getString("challan_date");
                    String status = rs.getString("status");

                    // Handle null status
                    if (status == null || status.trim().isEmpty()) {
                        status = "UNPAID";
                    }
            %>
            <tr>
                <td><strong>#<%= challanNo %></strong></td>
                <td><%= vehiclePlate %></td>
                <td><strong>₹<%= String.format("%.2f", fineAmount) %></strong></td>
                <td><%= description != null ? description : "N/A" %></td>
                <td><%= challanDate %></td>
                <td>
                    <span class="status-badge <%= status.toLowerCase() %>">
                        <% if ("PAID".equals(status)) { %>
                            <i class="fas fa-check-circle"></i>
                        <% } else { %>
                            <i class="fas fa-clock"></i>
                        <% } %>
                        <%= status %>
                    </span>
                </td>
                <td>
                    <% if ("UNPAID".equals(status)) { %>
                    <button class="action-btn mark-paid-btn" onclick="updateStatus('<%= challanNo %>', 'PAID')">
                        <i class="fas fa-check"></i> Mark Paid
                    </button>
                    <% } else { %>
                    <button class="action-btn mark-unpaid-btn" onclick="updateStatus('<%= challanNo %>', 'UNPAID')">
                        <i class="fas fa-times"></i> Mark Unpaid
                    </button>
                    <% } %>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-inbox"></i>
            <h3>No Challans Found</h3>
            <p>There are no challans in the system yet.</p>
        </div>
        <% } %>
    </div>

    <%
        } catch (Exception e) {
            hasError = true;
            errorMessage = e.getMessage();
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (hasError) {
    %>
    <div class="error-message">
        <i class="fas fa-exclamation-triangle"></i>
        <span>Error loading challans: <%= errorMessage %></span>
    </div>
    <% } %>
</div>

<script>
    // Theme Toggle
    (function() {
        const themeToggle = document.getElementById('themeToggle');
        const htmlElement = document.documentElement;

        themeToggle.addEventListener('click', function() {
            const currentTheme = htmlElement.getAttribute('data-theme') === 'light' ? 'dark' : 'light';
            if (currentTheme === 'light') {
                htmlElement.setAttribute('data-theme', 'light');
            } else {
                htmlElement.removeAttribute('data-theme');
            }
            localStorage.setItem('theme', currentTheme);
        });
    })();

    // Update Status
    function updateStatus(challanNo, newStatus) {
        if (confirm(`Are you sure you want to mark challan #${challanNo} as ${newStatus}?`)) {
            fetch('UpdateChallanStatusServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'challanNo=' + encodeURIComponent(challanNo) + '&status=' + encodeURIComponent(newStatus)
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const successMsg = document.getElementById('successMessage');
                        successMsg.style.display = 'flex';
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    } else {
                        alert('Failed to update status: ' + (data.error || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating status. Please try again.');
                });
        }
    }

    // Filter Table
    function filterTable() {
        const searchInput = document.getElementById('searchInput').value.toUpperCase();
        const statusFilter = document.getElementById('statusFilter').value.toUpperCase();
        const table = document.getElementById('challanTable');

        if (!table) return;

        const tr = table.getElementsByTagName('tr');
        let visibleCount = 0;

        for (let i = 1; i < tr.length; i++) {
            const tdChallanNo = tr[i].getElementsByTagName('td')[0];
            const tdVehicle = tr[i].getElementsByTagName('td')[1];
            const tdStatus = tr[i].getElementsByTagName('td')[5];

            if (tdChallanNo && tdVehicle && tdStatus) {
                const challanNo = tdChallanNo.textContent || tdChallanNo.innerText;
                const vehicle = tdVehicle.textContent || tdVehicle.innerText;
                const status = tdStatus.textContent || tdStatus.innerText;

                const matchesSearch = challanNo.toUpperCase().indexOf(searchInput) > -1 ||
                    vehicle.toUpperCase().indexOf(searchInput) > -1;
                const matchesStatus = statusFilter === '' || status.toUpperCase().indexOf(statusFilter) > -1;

                if (matchesSearch && matchesStatus) {
                    tr[i].style.display = '';
                    visibleCount++;
                } else {
                    tr[i].style.display = 'none';
                }
            }
        }

        console.log(`Showing ${visibleCount} of ${tr.length - 1} challans`);
    }

    // Check URL parameters for success message
    (function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('updated') === 'true') {
            document.getElementById('successMessage').style.display = 'flex';
            setTimeout(() => {
                document.getElementById('successMessage').style.display = 'none';
            }, 3000);
        }
    })();
</script>

</body>
</html>
