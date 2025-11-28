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
%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Edit Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>.preview { width:140px; height:140px; object-fit:cover; border-radius:8px; }</style>
</head>
<body class="bg-light">
<div class="container mt-4">
    <h3>Edit Profile</h3>
    <form action="EditProfileServlet" method="post" enctype="multipart/form-data" class="mt-3">
        <div class="mb-3">
            <label class="form-label">Username (readonly)</label>
            <input class="form-control" type="text" name="username" value="<%= username %>" readonly>
        </div>

        <div class="mb-3">
            <label class="form-label">Full name</label>
            <input class="form-control" type="text" name="name" value="<%= name %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Mobile</label>
            <input class="form-control" type="text" name="mobile" value="<%= mobile %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Post / Title</label>
            <input class="form-control" type="text" name="post" value="<%= post %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Bio</label>
            <textarea class="form-control" name="bio" rows="3"><%= bio %></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Photo (optional)</label><br>
            <%
                String photoUrl = (photoPath==null || photoPath.trim().isEmpty())
                        ? (request.getContextPath()+"/images/default-avatar.png")
                        : (photoPath.startsWith("http") ? photoPath : request.getContextPath()+"/"+photoPath);
            %>
            <img src="<%= photoUrl %>" class="preview mb-2" id="photoPreview"><br>
            <input class="form-control" type="file" name="photo" accept="image/*" onchange="preview(event)">
        </div>

        <button class="btn btn-primary" type="submit">Save Profile</button>
        <a href="profile.jsp" class="btn btn-secondary ms-2">Cancel</a>
    </form>
</div>

<script>
    function preview(evt) {
        const file = evt.target.files[0];
        if (!file) return;
        const url = URL.createObjectURL(file);
        document.getElementById('photoPreview').src = url;
    }
</script>
</body>
</html>
