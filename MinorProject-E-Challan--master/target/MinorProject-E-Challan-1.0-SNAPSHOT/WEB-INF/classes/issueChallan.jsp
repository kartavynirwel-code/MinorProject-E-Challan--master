<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Tesseract OCR -->
    <script src="https://cdn.jsdelivr.net/npm/tesseract.js@4.0.2/dist/tesseract.min.js"></script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Challan - FineSnap</title>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url('minor.avif') no-repeat center center fixed;
            background-size: cover;
            color: #333;
        }

        .container {
            max-width: 520px;
            margin: 48px auto;
            padding: 28px 36px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
            text-align: center;
        }

        .logo {
            width: 120px;
            margin-bottom: 18px;
        }

        label {
            text-align: left;
            font-weight: 600;
            color: #34495e;
            display: block;
        }

        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 12px;
            font-size: 15px;
        }

        input[type="submit"] {
            background: #3498db;
            color: #fff;
            cursor: pointer;
            border: none;
        }

        .note {
            font-size: 13px;
            color: #666;
            text-align: left;
            margin-top: -8px;
        }
    </style>
</head>

<body>
<div class="container">
    <img src="finesnap_logo.png" alt="FineSnap Logo" class="logo">

    <h2>Issue a Challan</h2>

    <form action="IssueChallanServlet" method="post" enctype="multipart/form-data">

        <label>Vehicle Number:</label>
        <input type="text" id="vehicleNumber" name="vehicleNumber" required>

        <label>Challan Type:</label>
        <select id="description" name="description" onchange="updateAmount()" required>
            <option value="">-- Select a Challan Type --</option>
            <option>Overspeeding</option>
            <option>No Helmet</option>
            <option>Drunk Driving</option>
            <option>Red Light Jumping</option>
            <option>No Seatbelt</option>
            <option>Driving Without License</option>
            <option>Illegal Parking</option>
            <option>Expired Insurance</option>
        </select>

        <label>Amount (auto-filled):</label>
        <input type="number" id="amount" name="amount" readonly required>


        <label>Scan Number Plate (Camera):</label>
        <input type="file" id="plateScanner" accept="image/*" capture="environment">
        <p class="note">Use mobile device for camera scanning.</p>

        <input type="submit" value="Issue Challan">
    </form>
</div>

<footer style="text-align:center; margin-top:20px; color:#777;">
    &copy; 2025 FineSnap. All Rights Reserved.
</footer>

<script>
    // Challan Rates
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
        document.getElementById("amount").value =
            challanRates[document.getElementById("description").value] || "";
    }

    // OCR Plate Scanner
    document.addEventListener("DOMContentLoaded", () => {
        const scanner = document.getElementById("plateScanner");
        scanner.addEventListener("change", () => {
            const file = scanner.files[0];
            if (!file) return;

            Tesseract.recognize(file, "eng", { logger: m => console.log(m) })
                .then(res => {
                    let text = res.data.text.replace(/[^A-Za-z0-9]/g, "").toUpperCase();
                    if (text.length < 4) alert("Plate not detected properly");

                    document.getElementById("vehicleNumber").value = text;
                })
                .catch(err => alert("OCR Error: " + err));
        });
    });
</script>

</body>
</html>
