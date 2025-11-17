<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue Challan - FineSnap</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #dfe9f3, #ffffff);
            color: #333;
        }
        
        body {
    background: url('minor.avif') no-repeat center center fixed;
    background-size: cover;
    color: #333;
}

        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 30px 40px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .logo {
            width: 120px;
            margin-bottom: 20px;
        }

        h2 {
            margin-bottom: 25px;
            color: #2c3e50;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        label {
            text-align: left;
            font-weight: 600;
            margin-bottom: 5px;
            color: #34495e;
        }

        input[type="text"],
        input[type="number"],
        select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
            border-color: #3498db;
            outline: none;
        }

        input[type="submit"] {
            background-color: #3498db;
            color: white;
            padding: 12px;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #2980b9;
        }

        footer {
            text-align: center;
            margin-top: 40px;
            padding: 15px;
           
            font-size: 14px;
            color: #777;
            
        }
    </style>
</head>
<body>
    <!-- Page Container -->
    <div class="container">
        <!-- Logo -->
        <img src="finesnap_logo.png" alt="FineSnap Logo" class="logo">
        
        <!-- Heading -->
        <h2>Issue a Challan</h2>

        <!-- Form -->
        <form action="IssueChallanServlet" method="post">
            <label for="vehicleNumber">Vehicle Number:</label>
            <input type="text" id="vehicleNumber" name="vehicleNumber" placeholder="Enter vehicle number" required>
            
            <label for="amount">Amount:</label>
            <input type="number" id="amount" name="amount" placeholder="Enter challan amount" required>
            
            <label for="description">Challan Type:</label>
            <select id="description" name="description" required>
                <option value="">-- Select a Challan Type --</option>
                <option value="Overspeeding">Overspeeding</option>
                <option value="No Helmet">No Helmet</option>
                <option value="Drunk Driving">Drunk Driving</option>
                <option value="Red Light Jumping">Red Light Jumping</option>
                <option value="No Seatbelt">No Seatbelt</option>
                <option value="Driving Without License">Driving Without License</option>
                <option value="Illegal Parking">Illegal Parking</option>
                <option value="Expired Insurance">Expired Insurance</option>
            </select>
            
            <input type="submit" value="Issue Challan">
        </form>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2025 FineSnap. All Rights Reserved.</p>
    </footer>
</body>
</html>
