<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // Use the implicit 'session' (do NOT redeclare it) to avoid duplicate local variable errors.
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FineSnap Dashboard</title>
    <link rel="stylesheet" type="text/css" href="dashboard.css">
    <!-- No CSS changes here; dropdown uses inline styles so your CSS stays untouched -->
</head>
<body>
<!-- Header with Logo + Profile dropdown -->
<header style="display:flex; justify-content:space-between; align-items:center; padding:10px 20px;">
    <div style="display:flex; align-items:center; gap:12px;">
        <img src="finesnap_logo.png" alt="FineSnap Logo" style="height:56px;">
        <h1 style="margin:0;">Welcome to FineSnap Dashboard</h1>
    </div>

    <!-- Profile area (right) -->
    <div id="profileMenu" style="position:relative; display:flex; align-items:center; gap:10px; cursor:pointer;">
        <!-- Show officer name if available -->
        <div style="color:#fff; font-weight:600; margin-right:6px;">
            <%= (session.getAttribute("name") != null) ? session.getAttribute("name") : session.getAttribute("username") %>
        </div>

        <!-- Avatar image (place police_avatar.png in webapp folder) -->
        <img src="default_profile.jpg" alt="Profile" id="profileAvatar"
             style="width:48px; height:48px; border-radius:50%; border:2px solid #fff; object-fit:cover;">

        <!-- Dropdown (hidden by default) -->
        <div id="dropdownBox"
             style="display:none; position:absolute; right:0; top:68px; background:#ffffff; color:#000;
                        width:200px; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.18); overflow:hidden; z-index:999;">
            <a href="profile.jsp" style="display:block; padding:12px 14px; text-decoration:none; color:#111; border-bottom:1px solid #eee;">
                👤 View Profile
            </a>
            <a href="editProfile.jsp" style="display:block; padding:12px 14px; text-decoration:none; color:#111; border-bottom:1px solid #eee;">
                ✏️ Edit Profile
            </a>
            <a href="LogoutServlet" style="display:block; padding:12px 14px; text-decoration:none; color:#111;">
                🚪 Logout
            </a>
        </div>
    </div>
</header>

<!-- Main Content Section (kept the same as your original) -->
<div class="container">
    <div class="card">
        <img src="fine pay go image.jpg" alt="Chart">
        <h3><a href="chart.html">Challan Data Chart</a></h3>
        <p>Visualize challan data over time.</p>
    </div>

    <!-- Challan 1 -->
    <div class="card">
        <img src="minor1.png" alt="Challan Image 1">
        <h3><a href="issueChallan.jsp"> Challan Issued</a></h3>
        <p>View issued challans and update payment status.</p>
    </div>

    <!-- Challan 2 -->
    <div class="card">
        <img src="minor2.jpg" alt="Challan Image 2">
        <h3><a href="pay.html">Payment Status</a></h3>
        <p>Track pending payments and challan history.</p>
    </div>

    <!-- Challan 3 -->
    <div class="card">
        <img src="minor3.png" alt="Challan Image 3">
        <h3><a href="ownerInfo.jsp">Vehicle Owner Information</a></h3>
        <p>Access vehicle and owner details.</p>
    </div>

    <!-- Profile -->
    <div class="card">
        <img src="minor4.jpg" alt="Profile">
        <h3><a href="profile.jsp">Traffic Police Profile</a></h3>
        <p>Update your profile information and settings.</p>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>&copy; 2025 FineSnap All Rights Reserved.</p>
</footer>

<!-- Dropdown toggle script (minimal & safe) -->
<script>
    (function () {
        var profile = document.getElementById("profileMenu");
        var box = document.getElementById("dropdownBox");

        // toggle dropdown on click
        profile.addEventListener("click", function (e) {
            e.stopPropagation();
            box.style.display = (box.style.display === "block" ? "none" : "block");
        });

        // close when clicking outside
        document.addEventListener("click", function () {
            box.style.display = "none";
        });

        // simple keyboard accessibility: Esc to close
        document.addEventListener("keydown", function (evt) {
            if (evt.key === "Escape") {
                box.style.display = "none";
            }
        });
    })();
</script>
</body>
</html>
