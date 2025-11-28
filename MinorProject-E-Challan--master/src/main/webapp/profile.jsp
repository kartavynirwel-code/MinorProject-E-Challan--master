<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*,java.util.*" %>
<%
    // Use a different local variable name to avoid colliding with
    // the JSP implicit "session" variable.
    javax.servlet.http.HttpSession sess = request.getSession(false);

    if (sess == null || sess.getAttribute("userId") == null) {
        // not logged in -> redirect to login
        response.sendRedirect("login.html");
        return;
    }

    // session values (set by LoginServlet)
    Integer userId = (Integer) sess.getAttribute("userId");
    String sessionUsername = (String) sess.getAttribute("username");

    // defaults to show if DB lookup fails
    String name = "";
    String role = "";
    String mobile = "";
    String photoPath = null; // relative path e.g. "uploads/officer1.jpg"
    String bio = "";

    int totalChallans = 0;
    List<Map<String,Object>> recentChallans = new ArrayList<>();

    // DB config (update if your DB credentials differ)
    String jdbcUrl = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = "root";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection con = DriverManager.getConnection(jdbcUrl, dbUser, dbPass)) {

            // load user/officer details
            String qUser = "SELECT username, name, role, mobile, photo_path, bio FROM users WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(qUser)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        sessionUsername = rs.getString("username");
                        name = rs.getString("name");
                        role = rs.getString("role");
                        mobile = rs.getString("mobile");
                        photoPath = rs.getString("photo_path");
                        bio = rs.getString("bio");
                    }
                }
            }

            // total challans created by this user
            String qCount = "SELECT COUNT(*) FROM challans WHERE created_by = ?";
            try (PreparedStatement ps = con.prepareStatement(qCount)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) totalChallans = rs.getInt(1);
                }
            }

            // recent challans (last 10)
            String qRecent = "SELECT id, challan_no, vehicle_plate, fine_amount, status, created_at FROM challans WHERE created_by = ? ORDER BY created_at DESC LIMIT 10";
            try (PreparedStatement ps = con.prepareStatement(qRecent)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String,Object> row = new HashMap<>();
                        row.put("id", rs.getInt("id"));
                        row.put("challan_no", rs.getString("challan_no"));
                        row.put("vehicle_plate", rs.getString("vehicle_plate"));
                        row.put("fine_amount", rs.getDouble("fine_amount"));
                        row.put("status", rs.getString("status"));
                        row.put("created_at", rs.getTimestamp("created_at"));
                        recentChallans.add(row);
                    }
                }
            }

        } // connection closed
    } catch (Exception e) {
        // show basic error info (you can log to server log)
        out.println("<div class='alert alert-danger'>Error loading profile: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }

    // Build photo URL: if photoPath is relative, prepend context path
    String photoUrl = null;
    if (photoPath != null && !photoPath.trim().isEmpty()) {
        if (photoPath.startsWith("http://") || photoPath.startsWith("https://")) {
            photoUrl = photoPath;
        } else {
            photoUrl = request.getContextPath() + "/" + photoPath;
        }
    } else {
        // fallback avatar
        photoUrl = request.getContextPath() + "/images/default-avatar.png"; // change if you have a different default
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Officer Profile - <%= (name==null || name.isEmpty()) ? sessionUsername : name %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .profile-header { margin-top: 30px; }
        .profile-card { padding: 20px; border-radius: 8px; box-shadow: 0 6px 18px rgba(0,0,0,0.08); }
        .profile-photo { width: 160px; height:160px; object-fit:cover; border-radius:50%; border:4px solid #fff; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        .meta { font-size: 14px; color:#666; }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="profile-header text-center">
        <h1>Officer Profile</h1>
        <p class="text-muted">Welcome, <strong><%= (name==null||name.isEmpty())?sessionUsername:name %></strong></p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <div class="profile-card bg-white text-center">
                <img src="<%= photoUrl %>" alt="Officer Photo" class="profile-photo mb-3">
                <h4><%= (name==null||name.isEmpty())?sessionUsername:name %></h4>
                <p class="meta"><strong>Role:</strong> <%= (role==null?"POLICE":role) %></p>
                <p class="meta"><strong>Mobile:</strong> <%= (mobile==null?"-":mobile) %></p>
                <p class="mt-3"><strong>Bio</strong></p>
                <p class="small text-muted"><%= (bio==null || bio.trim().isEmpty()) ? "No bio provided." : bio %></p>

                <a href="editProfile.jsp" class="btn btn-outline-primary mt-3">Edit Profile</a>
                <a href="dashboard.jsp" class="btn btn-secondary mt-2">Back to Dashboard</a>
            </div>
        </div>

        <div class="col-md-8">
            <div class="bg-white p-3 profile-card">
                <h5>Stats</h5>
                <div class="row">
                    <div class="col-sm-4">
                        <div class="p-3 border rounded">
                            <h3><%= totalChallans %></h3>
                            <p class="mb-0">Challans Issued</p>
                        </div>
                    </div>
                    <div class="col-sm-8">
                        <div class="p-3">
                            <p><strong>Username:</strong> <%= sessionUsername %></p>
                            <p><strong>Member since:</strong> <!-- optionally show created_at if in session or DB --> - </p>
                        </div>
                    </div>
                </div>

                <hr/>

                <h5>Recent Challans</h5>
                <table class="table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th>No</th>
                        <th>Challan No</th>
                        <th>Vehicle</th>
                        <th>Amount (₹)</th>
                        <th>Status</th>
                        <th>Issued At</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (recentChallans.isEmpty()) {
                    %>
                    <tr><td colspan="7" class="text-center">No recent challans</td></tr>
                    <%
                    } else {
                        int idx = 1;
                        for (Map<String,Object> r : recentChallans) {
                    %>
                    <tr>
                        <td><%= idx++ %></td>
                        <td><%= r.get("challan_no") %></td>
                        <td><%= r.get("vehicle_plate") %></td>
                        <td><%= r.get("fine_amount") %></td>
                        <td><%= r.get("status") %></td>
                        <td><%= r.get("created_at") %></td>
                        <td>
                            <a class="btn btn-sm btn-primary" href="viewChallan.jsp?id=<%= r.get("id") %>">View</a>
                            <a class="btn btn-sm btn-success" href="Payment.jsp?vehicleNumber=<%= r.get("vehicle_plate") %>&amount=<%= r.get("fine_amount") %>">Pay</a>
                        </td>
                    </tr>
                    <%
                            } // for
                        } // else
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <footer class="mt-5 mb-5 text-center text-muted">
        &copy; 2025 FineSnap
    </footer>
</div>
</body>
</html>
