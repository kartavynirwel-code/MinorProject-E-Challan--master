<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Challan Issued</title>
    <link rel="stylesheet" href="challan-style.css">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow p-4">

        <h2 class="text-center text-success">Challan Issued Successfully</h2><hr>

        <%
            String vehicleNumber = request.getParameter("vehicleNumber");
            String amount = request.getParameter("amount");
            String description = request.getParameter("description");

            String owner_name = "", owner_mobile = "", owner_address = "";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/echallan", "root", "root");

                // Fetch vehicle owner
                PreparedStatement pst = con.prepareStatement(
                        "SELECT owner_name, owner_mobile, owner_address FROM vehicles WHERE plate = ?"
                );
                pst.setString(1, vehicleNumber);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    owner_name = rs.getString("owner_name");
                    owner_mobile = rs.getString("owner_mobile");
                    owner_address = rs.getString("owner_address");
                }

                // Insert challan
                PreparedStatement insert = con.prepareStatement(
                        "INSERT INTO challans (vehicle_plate, fine_amount, description) VALUES (?, ?, ?)"
                );
                insert.setString(1, vehicleNumber);
                insert.setDouble(2, Double.parseDouble(amount));
                insert.setString(3, description);
                insert.executeUpdate();

                con.close();

            } catch (Exception e) {
                System.out.println("<div class='alert alert-danger'>Error: "+e.getMessage()+"</div>");
            }
        %>

        <table class="table table-bordered mt-4">
            <tr><th>Owner Name</th><td><%= owner_name %></td></tr>
            <tr><th>Contact Number</th><td><%= owner_mobile %></td></tr>
            <tr><th>Address</th><td><%= owner_address %></td></tr>
            <tr><th>Challan Amount</th><td>₹<%= amount %></td></tr>
            <tr><th>Violation</th><td><%= description %></td></tr>
        </table>

        <div class="text-center">
            <a href="Payment.jsp?vehicleNumber=<%= vehicleNumber %>&amount=<%= amount %>"
               class="btn btn-success">Pay Challan Now</a>
        </div>

    </div>
</div>

</body>
</html>
