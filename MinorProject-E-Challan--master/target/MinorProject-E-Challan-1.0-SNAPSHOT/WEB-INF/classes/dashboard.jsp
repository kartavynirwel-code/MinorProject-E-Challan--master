<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // ✅ Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // ✅ Check session and redirect if not logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.html");
        return;
    }

    // ✅ Get username from session
    String username = (String) session.getAttribute("username");
    if (username == null) {
        username = (String) session.getAttribute("name");
    }
    if (username == null) {
        username = "User";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FineSnap - Traffic Police Dashboard</title>

    <script>
        // Apply theme immediately
        (function() {
            const theme = localStorage.getItem('theme') || 'dark';
            if (theme === 'light') {
                document.documentElement.setAttribute('data-theme', 'light');
            }
        })();
    </script>

    <link rel="stylesheet" type="text/css" href="dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css" rel="stylesheet" />
</head>

<body>

<!-- ================= HEADER ================= -->
<header>
    <div class="header-left">
        <img src="finesnap_logo.png" alt="FineSnap Logo" class="logo">
        <div class="header-title">
            <h1>FineSnap</h1>
            <span class="subtitle">Traffic Management System</span>
        </div>
    </div>

    <div class="header-right">
        <!-- Theme Toggle Button -->
        <button class="theme-toggle" id="themeToggle" aria-label="Toggle theme" title="Toggle Theme">
            <i class="fas fa-sun theme-icon" id="lightIcon"></i>
            <i class="fas fa-moon theme-icon" id="darkIcon"></i>
        </button>

        <!-- Profile Menu -->
        <div class="profile-menu" id="profileMenu">
            <div class="user-info">
                <span class="user-name" id="displayUsername"><%= username %></span>
                <span class="user-role">Traffic Officer</span>
            </div>
            <img src="default_profile.jpg" alt="Profile" class="profile-img">
            <i class="fas fa-chevron-down dropdown-icon"></i>

            <!-- Dropdown Menu -->
            <div class="dropdown-menu" id="dropdownBox">
                <a href="profile.jsp">
                    <i class="fas fa-user-circle"></i>
                    <span>View Profile</span>
                </a>
                <a href="editProfile.jsp">
                    <i class="fas fa-edit"></i>
                    <span>Edit Profile</span>
                </a>
                <div class="dropdown-divider"></div>
                <!-- ✅ NEW: Manage Challans Option -->
                <a href="manage-challans.jsp">
                    <i class="ri-file-list-3-line"></i>
                    <span>Manage Challans</span>
                </a>
                <div class="dropdown-divider"></div>
                <a href="#" onclick="handleLogout(event)" class="logout-link">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>
    </div>
</header>

<!-- ================= MAIN CONTENT ================= -->
<main class="dashboard-main">

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="fas fa-file-invoice"></i>
            </div>
            <div class="stat-info">
                <span class="stat-value">156</span>
                <span class="stat-label">Total Challans</span>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon pending">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-info">
                <span class="stat-value">42</span>
                <span class="stat-label">Pending Payments</span>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon success">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-info">
                <span class="stat-value">114</span>
                <span class="stat-label">Completed</span>
            </div>
        </div>
    </div>

    <!-- Dashboard Cards Grid -->
    <div class="cards-grid">

        <!-- Card 1: Challan Issued -->
        <div class="dashboard-card">
            <div class="card-image-wrapper">
                <img src="minor1.png" alt="Challan Issued">
                <div class="card-overlay">
                    <i class="fas fa-receipt"></i>
                </div>
            </div>
            <div class="card-body">
                <h3>Challan Issued</h3>
                <p>View and manage issued traffic violation challans and update payment status.</p>
                <a href="issueChallan.jsp" class="card-btn">
                    <span>Issue</span>
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>

        <!-- Card 2: Traffic Police Profile -->
        <div class="dashboard-card">
            <div class="card-image-wrapper">
                <img src="minor4.jpg" alt="Traffic Police Profile">
                <div class="card-overlay">
                    <i class="fas fa-user-shield"></i>
                </div>
            </div>
            <div class="card-body">
                <h3>Traffic Police Profile</h3>
                <p>Manage your officer profile, credentials, and system access settings.</p>
                <a href="profile.jsp" class="card-btn">
                    <span>Manage Profile</span>
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>

        <!-- Card 3: Payment Status -->
        <div class="dashboard-card">
            <div class="card-image-wrapper">
                <img src="minor2.jpg" alt="Payment Status">
                <div class="card-overlay">
                    <i class="fas fa-credit-card"></i>
                </div>
            </div>
            <div class="card-body">
                <h3>Payment Status</h3>
                <p>Monitor payment transactions and track pending and completed payments.</p>
                <a href="pay.html" class="card-btn">
                    <span>Track Payments</span>
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>

        <!-- Card 4: Challan Data Chart -->
        <div class="dashboard-card">
            <div class="card-image-wrapper">
                <img src="fine pay go image.jpg" alt="Challan Data Chart">
                <div class="card-overlay">
                    <i class="fas fa-chart-line"></i>
                </div>
            </div>
            <div class="card-body">
                <h3>Challan Data Analytics</h3>
                <p>Access comprehensive data analytics and visualizations with statistical reports.</p>
                <a href="chart.html" class="card-btn">
                    <span>View Analytics</span>
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>

        <!-- Card 5: Vehicle Owner Information -->
        <div class="dashboard-card">
            <div class="card-image-wrapper">
                <img src="minor3.png" alt="Vehicle Owner Information">
                <div class="card-overlay">
                    <i class="fas fa-car"></i>
                </div>
            </div>
            <div class="card-body">
                <h3>Vehicle Owner Database</h3>
                <p>Search vehicle registration details, owner information, and violation history.</p>
                <a href="ownerInfo.jsp" class="card-btn">
                    <span>Search Database</span>
                    <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>

    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer>
    <div class="footer-content">
        <p>&copy; 2025 FineSnap Traffic Management System. All Rights Reserved.</p>
        <p class="footer-meta">Version 2.1.0 | Last Login: <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date()) %></p>
    </div>
</footer>

<!-- Custom Alert Modal -->
<div id="customAlert" class="custom-alert-overlay">
    <div class="custom-alert-box">
        <div class="alert-header">
            <div class="alert-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3 class="alert-title">Confirm Logout</h3>
        </div>
        <div class="alert-body">
            <p class="alert-message" id="alertMessage">Are you sure you want to logout?</p>
        </div>
        <div class="alert-footer" style="display: flex; gap: 10px;">
            <button class="custom-alert-btn" onclick="confirmLogout()" style="background: #dc3545; color: #fff;">
                <i class="fas fa-sign-out-alt"></i> Yes, Logout
            </button>
            <button class="custom-alert-btn" onclick="closeCustomAlert()">
                <i class="fas fa-times"></i> Cancel
            </button>
        </div>
    </div>
</div>

<!-- ================= JAVASCRIPT ================= -->
<script>
    // ========== CUSTOM ALERT FUNCTIONS ==========
    function showCustomAlert(message) {
        document.getElementById('alertMessage').textContent = message;
        document.getElementById('customAlert').style.display = 'flex';
    }

    function closeCustomAlert() {
        const overlay = document.getElementById('customAlert');
        overlay.style.animation = 'fadeOut 0.3s ease';
        setTimeout(() => {
            overlay.style.display = 'none';
            overlay.style.animation = '';
        }, 300);
    }

    function confirmLogout() {
        console.log('🚪 Logging out...');
        localStorage.clear();
        console.log('✅ localStorage cleared');
        window.location.href = 'LogoutServlet';
    }

    // ========== LOGOUT HANDLER ==========
    function handleLogout(event) {
        event.preventDefault();
        showCustomAlert('Are you sure you want to logout?');
    }

    // ========== PREVENT BACK BUTTON AFTER LOGOUT ==========
    (function() {
        window.history.forward();
        window.onpageshow = function(event) {
            if (event.persisted) {
                window.location.reload();
            }
        };
    })();

    // ========== THEME TOGGLE ==========
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
            console.log('🎨 Theme changed to:', currentTheme);
        });
    })();

    // ========== PROFILE DROPDOWN ==========
    (function() {
        const profileMenu = document.getElementById('profileMenu');
        const dropdownBox = document.getElementById('dropdownBox');

        profileMenu.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdownBox.classList.toggle('show');
        });

        document.addEventListener('click', function(e) {
            if (!profileMenu.contains(e.target)) {
                dropdownBox.classList.remove('show');
            }
        });
    })();

    // ========== DASHBOARD CARD CLICKS ==========
    (function() {
        document.querySelectorAll('.dashboard-card').forEach(card => {
            card.addEventListener('click', function(e) {
                if (!e.target.closest('.card-btn')) {
                    const link = this.querySelector('.card-btn');
                    if (link) {
                        window.location.href = link.getAttribute('href');
                    }
                }
            });
        });
    })();

    // ========== SMOOTH SCROLL FOR STATS ==========
    (function() {
        const statCards = document.querySelectorAll('.stat-card');
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, { threshold: 0.1 });

        statCards.forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'all 0.5s ease';
            observer.observe(card);
        });
    })();
</script>

</body>
</html>
