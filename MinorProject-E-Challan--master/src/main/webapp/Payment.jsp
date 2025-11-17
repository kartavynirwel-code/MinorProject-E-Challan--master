<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Make Payment</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h2 class="text-center text-primary">Payment Page</h2><hr>
            
            <%
                String vehicleNumber = request.getParameter("vehicleNumber");
                String amount = request.getParameter("amount");
            %>

            <p><strong>Vehicle Number:</strong> <%= vehicleNumber %></p>
            <p><strong>Amount to Pay:</strong> ₹<%= amount %></p>

            <form action="ProcessPaymentServlet" method="post">
                <input type="hidden" name="vehicleNumber" value="<%= vehicleNumber %>">
                <input type="hidden" name="amount" value="<%= amount %>">

                <div class="mb-3">
                    <label>Enter Card Details:</label>
                    <input type="text" name="cardNumber" class="form-control" placeholder="Enter Card Number" required>
                </div>
                
            <div class="text-center mb-4">
                <h5 class="text-success">Or Pay Here by Scanning QR Code</h5>
                <img src="QR.jpg" alt="QR Code" class="img-fluid" style="max-width: 300px;">
                <p class="mt-2"><strong>UPI ID:</strong> Finesnap112@okhdfcbank</p>
            </div>
                <button type="submit" class="btn btn-success">Pay Now</button>
            </form>
        </div>
    </div>
</body>
</html>
