<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Owner Info - FineSnap</title>
    <link rel="stylesheet" href="ownerInfo.css">
</head>
<body>
    <!-- Page Container -->
    <div class="container">
        <!-- Logo -->
        <img src="finesnap_logo.png" alt="FineSnap Logo" class="logo">

        <!-- Page Title -->
        <h2>Vehicle Owner Information</h2>

        <!-- Form -->
        <form action="OwnerInfoServlet" method="get">
            <label for="vehicleNumber">Vehicle Number:</label>
            <input type="text" id="vehicleNumber" name="vehicleNumber" placeholder="Enter vehicle number" required>

            <input type="submit" value="Get Information">
        </form>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2025 FineSnap. All Rights Reserved.</p>
    </footer>
</body>
</html>
