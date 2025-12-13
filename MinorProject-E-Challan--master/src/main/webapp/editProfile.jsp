<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // require logged-in user
    javax.servlet.http.HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("userId") == null) {
        response.sendRedirect("login.html");
        return;
    }
    Integer userId = (Integer) s.getAttribute("userId");

    // Load existing user data (so form is prefilled)
    String jdbcUrl = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = "root";

    String username="";
    String name="";
    String mobile="";
    String post="";
    String bio="";
    String photoPath="";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection con = DriverManager.getConnection(jdbcUrl, dbUser, dbPass)) {
            String q = "SELECT username, name, mobile, post, bio, photo_path FROM users WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(q)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        username = rs.getString("username");
                        name = rs.getString("name");
                        mobile = rs.getString("mobile");
                        post = rs.getString("post");
                        bio = rs.getString("bio");
                        photoPath = rs.getString("photo_path");
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String photoUrl = (photoPath==null || photoPath.trim().isEmpty())
            ? (request.getContextPath()+"/default_profile.jpg")
            : (photoPath.startsWith("http") ? photoPath : request.getContextPath()+"/"+photoPath);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - FineSnap</title>

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

        .back-btn:active {
            transform: translateY(-1px);
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

        /* ========== FORM CARD ========== */
        .form-card {
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

        /* ========== PHOTO PREVIEW SECTION ========== */
        .photo-section {
            text-align: center;
            margin-bottom: 2rem;
            padding: 2rem;
            background: var(--bg-secondary);
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }

        .photo-preview-wrapper {
            position: relative;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .photo-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--accent-primary);
            box-shadow: var(--shadow-md);
            transition: var(--transition);
        }

        .photo-preview:hover {
            transform: scale(1.05);
        }

        .camera-icon {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: var(--accent-primary);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
        }

        .camera-icon:hover {
            background: var(--accent-secondary);
            transform: scale(1.1);
        }

        .camera-icon i {
            font-size: 1rem;
        }

        .upload-hint {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .upload-hint i {
            color: var(--accent-secondary);
        }

        /* ========== FORM ELEMENTS ========== */
        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        label i {
            color: var(--accent-primary);
            width: 20px;
        }

        input[type="text"],
        input[type="file"],
        textarea {
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
        input[type="file"]:focus,
        textarea:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            background: var(--bg-card-hover);
        }

        input[type="text"]:hover,
        textarea:hover {
            border-color: var(--accent-secondary);
        }

        input[type="text"]::placeholder,
        textarea::placeholder {
            color: var(--text-muted);
        }

        input[readonly] {
            background: var(--bg-primary);
            cursor: not-allowed;
            opacity: 0.7;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        input[type="file"] {
            padding: 0.6rem;
            cursor: pointer;
            display: none; /* Hidden, triggered by camera icon */
        }

        .note {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 0.3rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .note i {
            color: var(--accent-secondary);
        }

        /* ========== BUTTONS ========== */
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            flex: 1;
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

        .btn-primary {
            background: linear-gradient(135deg, var(--accent-success), #059669);
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.4);
        }

        .btn-secondary {
            background: var(--bg-secondary);
            color: var(--text-primary);
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: var(--bg-card-hover);
            border-color: var(--accent-danger);
            color: var(--accent-danger);
        }

        .btn:active {
            transform: translateY(0);
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

            .form-card {
                padding: 1.5rem;
            }

            .page-header h2 {
                font-size: 1.5rem;
            }

            .form-actions {
                flex-direction: column;
            }

            .theme-toggle {
                width: 45px;
                height: 45px;
            }

            .theme-icon {
                font-size: 1.2rem;
            }

            .photo-preview {
                width: 120px;
                height: 120px;
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

        <a href="profile.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Back to Profile
        </a>
    </div>
</header>

<!-- ========== MAIN CONTENT ========== -->
<div class="main-container">

    <!-- Page Header -->
    <div class="page-header">
        <h2><i class="fas fa-user-edit"></i> Edit Profile</h2>
        <p>Update your officer profile information</p>
    </div>

    <!-- Form Card -->
    <div class="form-card">

        <form action="EditProfileServlet" method="post" enctype="multipart/form-data" id="profileForm">

            <!-- Photo Preview Section -->
            <div class="photo-section">
                <div class="photo-preview-wrapper">
                    <img src="<%= photoUrl %>" class="photo-preview" id="photoPreview" alt="Profile Photo">
                    <label for="photoInput" class="camera-icon">
                        <i class="fas fa-camera"></i>
                    </label>
                </div>
                <p class="upload-hint">
                    <i class="fas fa-info-circle"></i>
                    Click the camera icon to upload a new photo (Max 5MB)
                </p>
                <input type="file" name="photo" id="photoInput" accept="image/*" onchange="previewPhoto(event)">
            </div>

            <!-- Username (readonly) -->
            <div class="form-group">
                <label>
                    <i class="fas fa-user"></i>
                    Username
                </label>
                <input type="text" name="username" value="<%= username %>" readonly>
                <p class="note">
                    <i class="fas fa-lock"></i>
                    Username cannot be changed
                </p>
            </div>

            <!-- Full Name -->
            <div class="form-group">
                <label>
                    <i class="fas fa-id-card"></i>
                    Full Name
                </label>
                <input type="text" name="name" value="<%= name %>" placeholder="Enter your full name" required>
            </div>

            <!-- Mobile Number -->
            <div class="form-group">
                <label>
                    <i class="fas fa-phone"></i>
                    Mobile Number
                </label>
                <input type="text" name="mobile" id="mobileInput" value="<%= mobile %>" placeholder="Enter 10-digit mobile number" maxlength="10" pattern="[0-9]{10}" required>
                <p class="note">
                    <i class="fas fa-mobile-alt"></i>
                    Enter valid 10-digit mobile number
                </p>
            </div>

            <!-- Post/Title -->
            <div class="form-group">
                <label>
                    <i class="fas fa-briefcase"></i>
                    Post / Designation
                </label>
                <input type="text" name="post" value="<%= post %>" placeholder="e.g., Traffic Inspector, Constable">
            </div>

            <!-- Bio -->
            <div class="form-group">
                <label>
                    <i class="fas fa-info-circle"></i>
                    Bio / About
                </label>
                <textarea name="bio" id="bioInput" placeholder="Write a short bio about yourself..." rows="4" maxlength="500"><%= bio %></textarea>
                <p class="note">
                    <i class="fas fa-pen"></i>
                    <span id="charCount">0</span> / 500 characters
                </p>
            </div>

            <!-- Action Buttons -->
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i>
                    Save Changes
                </button>
                <a href="profile.jsp" class="btn btn-secondary">
                    <i class="fas fa-times"></i>
                    Cancel
                </a>
            </div>
        </form>

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

    // ========== PHOTO PREVIEW FUNCTIONALITY ==========
    function previewPhoto(event) {
        const file = event.target.files[0];
        if (!file) return;

        // Validate file type
        if (!file.type.startsWith('image/')) {
            alert('⚠️ Please select a valid image file (JPG, PNG, GIF)');
            event.target.value = '';
            return;
        }

        // Validate file size (max 5MB)
        if (file.size > 5 * 1024 * 1024) {
            alert('⚠️ Image size should be less than 5MB');
            event.target.value = '';
            return;
        }

        // Create preview
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('photoPreview').src = e.target.result;
        };
        reader.readAsDataURL(file);
    }

    // ========== CHARACTER COUNTER ==========
    const bioInput = document.getElementById('bioInput');
    const charCount = document.getElementById('charCount');

    function updateCharCount() {
        charCount.textContent = bioInput.value.length;
    }

    bioInput.addEventListener('input', updateCharCount);
    updateCharCount(); // Initial count

    // ========== MOBILE NUMBER VALIDATION ==========
    const mobileInput = document.getElementById('mobileInput');

    mobileInput.addEventListener('input', function(e) {
        // Allow only digits
        e.target.value = e.target.value.replace(/[^0-9]/g, '');
    });

    // ========== FORM VALIDATION ==========
    document.getElementById('profileForm').addEventListener('submit', function(e) {
        const mobile = mobileInput.value;
        const name = document.querySelector('input[name="name"]').value.trim();

        // Validate name
        if (name.length < 3) {
            e.preventDefault();
            alert('⚠️ Please enter a valid name (minimum 3 characters)');
            return false;
        }

        // Validate mobile number
        if (mobile && !/^\d{10}$/.test(mobile)) {
            e.preventDefault();
            alert('⚠️ Please enter a valid 10-digit mobile number');
            return false;
        }

        // Show loading state
        const submitBtn = this.querySelector('.btn-primary');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        submitBtn.disabled = true;

        return true;
    });

    // ========== PREVENT FORM RESUBMISSION ==========
    if (window.history.replaceState) {
        window.history.replaceState(null, null, window.location.href);
    }
</script>

</body>
</html>
