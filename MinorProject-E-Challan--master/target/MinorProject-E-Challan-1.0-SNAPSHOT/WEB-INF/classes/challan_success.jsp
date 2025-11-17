<%@ page import="java.sql.*" %>
<%@ page import="com.twilio.Twilio" %>
<%@ page import="com.twilio.rest.api.v2010.account.Message" %>
<%@ page import="com.twilio.type.PhoneNumber" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Challan Issued</title>
    <link rel="stylesheet" href="challan-style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        setTimeout(function() {
            document.getElementById("alertBox").style.display = "none";
        }, 5000);
    </script>
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h2 class="text-center text-success">Challan Issued Successfully</h2><hr>

            <div class="alert alert-warning text-center" id="alertBox">
                <strong>Notice:</strong> A fine has been issued against vehicle <b><%= request.getParameter("vehicleNumber") %></b>.
            </div>

            <%
                String vehicleNumber = request.getParameter("vehicleNumber");
                String amount = request.getParameter("amount");
                String description = request.getParameter("description");
                String ownerName = "", contactNumber = "", address = "";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/finepaygo", "root", "");

                    // Fetch owner details
                    PreparedStatement pst = con.prepareStatement("SELECT * FROM vehicle_owners WHERE vehicle_number=?");
                    pst.setString(1, vehicleNumber);
                    ResultSet rs = pst.executeQuery();

                    if (rs.next()) {
                        ownerName = rs.getString("owner_name");
                        contactNumber = rs.getString("contact_number");
                        address = rs.getString("address");
                    }

                    // Insert challan
                    PreparedStatement insertChallan = con.prepareStatement(
                        "INSERT INTO challans (vehicle_number, amount, description) VALUES (?, ?, ?)"
                    );
                    insertChallan.setString(1, vehicleNumber);
                    insertChallan.setDouble(2, Double.parseDouble(amount));
                    insertChallan.setString(3, description);
                    insertChallan.executeUpdate();

                    // ✅ Twilio Integration
                    final String ACCOUNT_SID = "AC0b1909ea04765072d12f10521bc7842f";  // Replace with your Account SID
                    final String AUTH_TOKEN = "a734a4a2844ff48c3a20ac277c7c4ca0";                  // Replace with your Auth Token
                    final String FROM_PHONE = "+17572392284";                    // Replace with your Twilio number

                    Twilio.init(ACCOUNT_SID, AUTH_TOKEN);

                  String smsMessage = "🚨 Challan Issued 🚨\n"
    + "Vehicle: " + vehicleNumber + "\n"
    + "Amount: ₹" + amount + "\n"
    + "Pay at: yourdomain.com/pay";

                    Message.creator(
                        new PhoneNumber(contactNumber), // To
                        new PhoneNumber(FROM_PHONE),    // From (Twilio)
                        smsMessage
                    ).create();

                    con.close();
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>SMS sending failed: " + e.getMessage() + "</div>");
                    e.printStackTrace();
                }
            %>

            <table class="table table-bordered mt-4">
                <tr><th>Owner Name</th><td><%= ownerName %></td></tr>
                <tr><th>Contact Number</th><td><%= contactNumber %></td></tr>
                <tr><th>Address</th><td><%= address %></td></tr>
                <tr><th>Challan Amount</th><td>₹<%= amount %></td></tr>
                <tr><th>Violation</th><td><%= description %></td></tr>
            </table>

            <div class="text-center">
                <a href="Payment.jsp?vehicleNumber=<%= vehicleNumber %>&amount=<%= amount %>" class="btn btn-success">
                    Pay Challan Now
                </a>
            </div>
        </div>
    </div>
</body>
</html>
