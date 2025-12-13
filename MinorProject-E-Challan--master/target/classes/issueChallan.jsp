<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Challan - FineSnap</title>

    <!-- ⚡ CRITICAL: Apply saved theme IMMEDIATELY (before CSS loads) -->
    <script>
        (function() {
            const theme = localStorage.getItem('theme') || 'dark';
            if (theme === 'light') {
                document.documentElement.setAttribute('data-theme', 'light');
            }
        })();
    </script>

    <!-- Tesseract OCR -->
    <script src="https://cdn.jsdelivr.net/npm/tesseract.js@4.0.2/dist/tesseract.min.js"></script>

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
            max-width: 1200px;
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

        /* ========== FORM CONTAINER ========== */
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: var(--shadow-lg);
            animation: slideUp 0.6s ease-out;
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

        .logo-section {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo {
            width: 100px;
            height: auto;
            filter: drop-shadow(0 4px 8px rgba(59, 130, 246, 0.4));
        }

        .form-title {
            text-align: center;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
        }

        /* ========== FORM ELEMENTS ========== */
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
        input[type="number"],
        select,
        input[type="file"] {
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
        input[type="number"]:focus,
        select:focus,
        input[type="file"]:focus {
            outline: none;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        input[type="text"]::placeholder,
        input[type="number"]::placeholder {
            color: var(--text-muted);
        }

        select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2394a3b8' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            padding-right: 2.5rem;
        }

        select option {
            background: var(--bg-secondary);
            color: var(--text-primary);
        }

        input[readonly] {
            background: var(--bg-primary);
            cursor: not-allowed;
            opacity: 0.7;
        }

        input[type="file"] {
            padding: 0.6rem;
            cursor: pointer;
        }

        input[type="file"]::file-selector-button {
            padding: 0.5rem 1rem;
            background: var(--accent-primary);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            margin-right: 1rem;
            transition: var(--transition);
        }

        input[type="file"]::file-selector-button:hover {
            background: var(--accent-secondary);
        }

        .note {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .note i {
            color: var(--accent-secondary);
        }

        /* ========== SUBMIT BUTTON ========== */
        .submit-btn {
            width: 100%;
            padding: 0.9rem 1.5rem;
            background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary));
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.4);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        /* ========== INFO CARD ========== */
        .info-card {
            background: rgba(6, 182, 212, 0.1);
            border: 1px solid rgba(6, 182, 212, 0.3);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .info-card h4 {
            color: var(--accent-secondary);
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-card p {
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.5;
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

            .form-container {
                padding: 1.5rem;
            }

            .page-header h2 {
                font-size: 1.5rem;
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
        <h2>Issue Traffic Challan</h2>
        <p>Record traffic violations and generate e-challans</p>
    </div>

    <!-- Form Container -->
    <div class="form-container">

        <div class="logo-section">
            <img src="finesnap_logo.png" alt="FineSnap Logo" class="logo">
        </div>

        <h3 class="form-title">Challan Details</h3>

        <!-- Info Card -->
        <div class="info-card">
            <h4><i class="fas fa-info-circle"></i> Quick Info</h4>
            <p>Use the camera scanner to automatically detect vehicle number plates. Select violation type for auto-calculated fine amount.</p>
        </div>

        <form action="IssueChallanServlet" method="post" enctype="multipart/form-data">

            <div class="form-group">
                <label><i class="fas fa-car"></i> Vehicle Number:</label>
                <input type="text" id="vehicleNumber" name="vehicleNumber" placeholder="e.g., MH12AB1234" required>
            </div>

            <div class="form-group">
                <label><i class="fas fa-exclamation-triangle"></i> Challan Type:</label>
                <select id="description" name="description" onchange="updateAmount()" required>
                    <option value="">-- Select a Violation Type --</option>
                    <option>Overspeeding</option>
                    <option>No Helmet</option>
                    <option>Drunk Driving</option>
                    <option>Red Light Jumping</option>
                    <option>No Seatbelt</option>
                    <option>Driving Without License</option>
                    <option>Illegal Parking</option>
                    <option>Expired Insurance</option>
                </select>
            </div>

            <div class="form-group">
                <label><i class="fas fa-rupee-sign"></i> Fine Amount (auto-filled):</label>
                <input type="number" id="amount" name="amount" placeholder="Select violation type" readonly required>
            </div>

            <div class="form-group">
                <label><i class="fas fa-camera"></i> Scan Number Plate (Camera):</label>
                <input type="file" id="plateScanner" accept="image/*" capture="environment">
                <p class="note">
                    <i class="fas fa-mobile-alt"></i>
                    Use mobile device camera for automatic plate scanning
                </p>
            </div>

            <button type="submit" class="submit-btn">
                <i class="fas fa-file-invoice"></i>
                Issue Challan
            </button>
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

    // ========== CHALLAN RATES ==========
    const challanRates = {
        "Overspeeding": 1000,
        "No Helmet": 500,
        "Drunk Driving": 2000,
        "Red Light Jumping": 1500,
        "No Seatbelt": 700,
        "Driving Without License": 3000,
        "Illegal Parking": 800,
        "Expired Insurance": 1200
    };

    function updateAmount() {
        const selectedType = document.getElementById("description").value;
        const amountField = document.getElementById("amount");

        if (selectedType && challanRates[selectedType]) {
            amountField.value = challanRates[selectedType];
        } else {
            amountField.value = "";
        }
    }

    // ========== OCR PLATE SCANNER ==========
    document.addEventListener("DOMContentLoaded", () => {
        const scanner = document.getElementById("plateScanner");
        const vehicleInput = document.getElementById("vehicleNumber");

        scanner.addEventListener("change", () => {
            const file = scanner.files[0];
            if (!file) return;

            // Show loading state
            vehicleInput.value = "Scanning plate...";
            vehicleInput.disabled = true;

            Tesseract.recognize(file, "eng", {
                logger: m => console.log(m)
            })
                .then(res => {
                    let text = res.data.text.replace(/[^A-Za-z0-9]/g, "").toUpperCase();

                    vehicleInput.disabled = false;

                    if (text.length < 4) {
                        alert("⚠️ Number plate not detected properly. Please enter manually.");
                        vehicleInput.value = "";
                    } else {
                        vehicleInput.value = text;
                        alert("✅ Plate detected: " + text);
                    }
                })
                .catch(err => {
                    vehicleInput.disabled = false;
                    vehicleInput.value = "";
                    alert("❌ OCR Error: " + err);
                });
        });
    });
</script>

</body>
</html>
