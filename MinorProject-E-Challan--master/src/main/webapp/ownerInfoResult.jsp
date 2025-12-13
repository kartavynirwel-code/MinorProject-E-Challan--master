<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String vehicleNumber = (String) request.getAttribute("vehicleNumber");
    String ownerName = (String) request.getAttribute("ownerName");
    String ownerMobile = (String) request.getAttribute("ownerMobile");
    String ownerAddress = (String) request.getAttribute("ownerAddress");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Owner Details - FineSnap</title>

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

<header>
    <div class="header-left">
        <img src="finesnap_logo.png" alt="FineSnap Logo" class="header-logo">
        <div class="header-title">
            <h1>FineSnap</h1>
            <span class="subtitle">Traffic Management System</span>
        </div>
    </div>

    <div class="header-right">
        <button class="theme-toggle" id="themeToggle">
            <i class="fas fa-sun theme-icon"></i>
            <i class="fas fa-moon theme-icon"></i>
        </button>

        <a href="ownerInfo.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            New Search
        </a>
    </div>
</header>

<div class="main-container">
    <div class="page-header">
        <div class="icon-wrapper" style="background: linear-gradient(135deg, #10b981, #059669);">
            <i class="fas fa-check-circle"></i>
        </div>
        <h2>Vehicle Found!</h2>
        <p>Owner information retrieved successfully</p>
    </div>

    <div class="search-card">
        <div class="result-item">
            <i class="fas fa-car"></i>
            <div>
                <label>Vehicle Number</label>
                <strong><%= vehicleNumber %></strong>
            </div>
        </div>

        <div class="result-item">
            <i class="fas fa-user"></i>
            <div>
                <label>Owner Name</label>
                <strong><%= ownerName != null ? ownerName : "N/A" %></strong>
            </div>
        </div>

        <div class="result-item">
            <i class="fas fa-phone"></i>
            <div>
                <label>Mobile Number</label>
                <strong><%= ownerMobile != null ? ownerMobile : "N/A" %></strong>
            </div>
        </div>

        <div class="result-item">
            <i class="fas fa-map-marker-alt"></i>
            <div>
                <label>Address</label>
                <strong><%= ownerAddress != null ? ownerAddress : "N/A" %></strong>
            </div>
        </div>

        <a href="ownerInfo.jsp" class="search-btn">
            <i class="fas fa-search"></i>
            Search Another Vehicle
        </a>
    </div>
</div>

<footer>
    <p>&copy; 2025 FineSnap Traffic Management System. All Rights Reserved.</p>
</footer>

<script>
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
        });
    })();
</script>

<style>
    .result-item {
        display: flex;
        align-items: center;
        gap: 1rem;
        padding: 1.2rem;
        background: var(--bg-secondary);
        border: 1px solid var(--border-color);
        border-radius: 10px;
        margin-bottom: 1rem;
        transition: var(--transition);
    }

    .result-item:hover {
        transform: translateX(5px);
        border-color: var(--accent-primary);
    }

    .result-item i {
        font-size: 1.5rem;
        color: var(--accent-primary);
        width: 40px;
        text-align: center;
    }

    .result-item label {
        display: block;
        font-size: 0.85rem;
        color: var(--text-secondary);
        margin-bottom: 0.3rem;
    }

    .result-item strong {
        font-size: 1.1rem;
        color: var(--text-primary);
    }
</style>

</body>
</html>
