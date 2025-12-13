<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Owner Info - FineSnap</title>

    <!-- ⚡ CRITICAL: Apply saved theme IMMEDIATELY (before CSS loads) -->
    <script>
        (function() {
            var theme = localStorage.getItem('theme') || 'dark';
            if (theme === 'light') {
                document.documentElement.setAttribute('data-theme', 'light');
            }
        })();
    </script>

    <link rel="stylesheet" href="ownerInfo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<!-- Header -->
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

<!-- Main Container -->
<div class="main-container">

    <!-- Page Header -->
    <div class="page-header">
        <div class="icon-wrapper">
            <i class="fas fa-car"></i>
        </div>
        <h2>Vehicle Owner Information</h2>
        <p>Search vehicle registration details and owner information</p>
    </div>

    <%-- Display error messages if any --%>
    <%
        String error = request.getParameter("error");
        String vehicle = request.getParameter("vehicle");
        if (error != null) {
    %>
    <div class="alert-box alert-<%= error.equals("notfound") ? "warning" : "error" %>">
        <i class="fas fa-<%= error.equals("notfound") ? "exclamation-triangle" : "exclamation-circle" %>"></i>
        <div>
            <% if ("notfound".equals(error)) { %>
            <strong>Vehicle Not Found!</strong>
            <p>No records found for vehicle number: <strong><%= vehicle != null ? vehicle : "" %></strong></p>
            <% } else if ("empty".equals(error)) { %>
            <strong>Invalid Input!</strong>
            <p>Please enter a vehicle number to search.</p>
            <% } else { %>
            <strong>Database Error!</strong>
            <p>Unable to fetch vehicle information. Please try again later.</p>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- Search Card -->
    <div class="search-card">
        <form action="OwnerInfoServlet" method="get" id="searchForm">
            <div class="form-group">
                <label for="vehicleNumber">
                    <i class="fas fa-id-card"></i>
                    Vehicle Registration Number
                </label>
                <input type="text"
                       id="vehicleNumber"
                       name="vehicleNumber"
                       placeholder="e.g., MH12AB1234"
                       value="<%= vehicle != null ? vehicle : "" %>"
                       required
                       pattern="[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}"
                       title="Enter valid vehicle number (e.g., MH12AB1234)"
                       maxlength="13">
                <p class="input-hint">
                    <i class="fas fa-info-circle"></i>
                    Enter the vehicle number in proper format
                </p>
            </div>

            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i>
                Search Vehicle
            </button>
        </form>
    </div>

    <!-- Info Card -->
    <div class="info-card">
        <div class="info-icon">
            <i class="fas fa-shield-alt"></i>
        </div>
        <div class="info-content">
            <h3>Secure & Verified Data</h3>
            <p>All vehicle information is fetched from official government databases and is completely secure.</p>
        </div>
    </div>

</div>

<!-- Footer -->
<footer>
    <p>&copy; 2025 FineSnap Traffic Management System. All Rights Reserved.</p>
</footer>

<!-- JavaScript -->
<script>
    // ========== THEME TOGGLE FUNCTIONALITY ==========
    (function() {
        var themeToggle = document.getElementById('themeToggle');
        var htmlElement = document.documentElement;

        // Toggle theme on button click
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
    var vehicleInput = document.getElementById('vehicleNumber');

    vehicleInput.addEventListener('input', function(e) {
        e.target.value = e.target.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
    });

    // ========== FORM VALIDATION WITH BETTER UX ==========
    document.getElementById('searchForm').addEventListener('submit', function(e) {
        var vehicleNumber = vehicleInput.value.trim().toUpperCase();
        var pattern = /^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$/;

        if (!vehicleNumber) {
            e.preventDefault();
            showNotification('Please enter a vehicle number', 'warning');
            vehicleInput.focus();
            return false;
        }

        if (!pattern.test(vehicleNumber)) {
            e.preventDefault();
            showNotification('Invalid format! Use: MH12AB1234', 'error');
            vehicleInput.focus();
            return false;
        }

        vehicleInput.value = vehicleNumber;
        showNotification('Searching vehicle information...', 'info');
    });

    // ========== NOTIFICATION SYSTEM ==========
    function showNotification(message, type) {
        type = type || 'info';

        // Remove existing notification
        var existingNotif = document.querySelector('.notification');
        if (existingNotif) {
            existingNotif.remove();
        }

        // Create notification
        var notification = document.createElement('div');
        notification.className = 'notification notification-' + type;

        var iconClass = 'info-circle';
        if (type === 'error') iconClass = 'exclamation-circle';
        if (type === 'warning') iconClass = 'exclamation-triangle';
        if (type === 'success') iconClass = 'check-circle';

        notification.innerHTML = '<i class="fas fa-' + iconClass + '"></i><span>' + message + '</span>';

        document.body.appendChild(notification);

        // Animate in
        setTimeout(function() {
            notification.classList.add('show');
        }, 10);

        // Remove after 3 seconds
        setTimeout(function() {
            notification.classList.remove('show');
            setTimeout(function() {
                notification.remove();
            }, 300);
        }, 3000);
    }

    // ========== INPUT FORMATTING HINTS ==========
    vehicleInput.addEventListener('focus', function() {
        this.placeholder = 'XX00XX0000';
    });

    vehicleInput.addEventListener('blur', function() {
        this.placeholder = 'e.g., MH12AB1234';
    });

    // ========== KEYBOARD SHORTCUTS ==========
    document.addEventListener('keydown', function(e) {
        // Alt + S to focus search input
        if (e.altKey && e.key === 's') {
            e.preventDefault();
            vehicleInput.focus();
        }
    });
</script>

<!-- Notification & Alert Styles -->
<style>
    .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 1rem 1.5rem;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 0.8rem;
        font-weight: 600;
        font-size: 0.95rem;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        z-index: 9999;
        transform: translateX(400px);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        backdrop-filter: blur(10px);
    }

    .notification.show {
        transform: translateX(0);
    }

    .notification i {
        font-size: 1.2rem;
    }

    .notification-info {
        background: rgba(59, 130, 246, 0.95);
        color: white;
        border: 1px solid rgba(59, 130, 246, 0.3);
    }

    .notification-warning {
        background: rgba(245, 158, 11, 0.95);
        color: white;
        border: 1px solid rgba(245, 158, 11, 0.3);
    }

    .notification-error {
        background: rgba(239, 68, 68, 0.95);
        color: white;
        border: 1px solid rgba(239, 68, 68, 0.3);
    }

    .notification-success {
        background: rgba(16, 185, 129, 0.95);
        color: white;
        border: 1px solid rgba(16, 185, 129, 0.3);
    }

    /* Alert Box Styles */
    .alert-box {
        padding: 1rem 1.5rem;
        border-radius: 12px;
        margin-bottom: 2rem;
        display: flex;
        align-items: flex-start;
        gap: 1rem;
        animation: slideDown 0.4s ease-out;
    }

    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .alert-box i {
        font-size: 1.5rem;
        margin-top: 0.2rem;
    }

    .alert-box strong {
        display: block;
        font-size: 1.1rem;
        margin-bottom: 0.3rem;
    }

    .alert-box p {
        margin: 0;
        font-size: 0.95rem;
    }

    .alert-warning {
        background: rgba(245, 158, 11, 0.1);
        border: 1px solid rgba(245, 158, 11, 0.3);
        color: var(--accent-warning);
    }

    .alert-error {
        background: rgba(239, 68, 68, 0.1);
        border: 1px solid rgba(239, 68, 68, 0.3);
        color: var(--accent-danger);
    }

    @media (max-width: 768px) {
        .notification {
            right: 10px;
            left: 10px;
            top: 10px;
        }

        .alert-box {
            flex-direction: column;
            text-align: center;
        }
    }
</style>

</body>
</html>
