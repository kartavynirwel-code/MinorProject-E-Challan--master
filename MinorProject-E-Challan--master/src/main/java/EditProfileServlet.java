import java.io.*;
import java.nio.file.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/EditProfileServlet")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 10*1024*1024, maxRequestSize = 15*1024*1024)
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.html");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");

        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String post = request.getParameter("post");
        String bio = request.getParameter("bio");

        Part photoPart = request.getPart("photo");
        String photoDbPath = null;

        if (photoPart != null && photoPart.getSize() > 0) {
            String submitted = Paths.get(photoPart.getSubmittedFileName()).getFileName().toString();
            String safe = submitted.replaceAll("[^A-Za-z0-9._-]", "_");
            String ext = "";
            int dot = safe.lastIndexOf('.');
            if (dot >= 0) ext = safe.substring(dot);
            String fileName = "user_" + userId + "_" + System.currentTimeMillis() + ext;

            // Save under webapp/uploads
            String uploads = getServletContext().getRealPath("/uploads");
            File dir = new File(uploads);
            if (!dir.exists()) dir.mkdirs();
            Path out = Paths.get(uploads, fileName);

            try (InputStream in = photoPart.getInputStream()) {
                Files.copy(in, out, StandardCopyOption.REPLACE_EXISTING);
            }

            // store relative path for web use
            photoDbPath = "uploads/" + fileName;
        }

        // DB update
        String jdbcUrl = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "root";

        String sql;
        if (photoDbPath != null) {
            sql = "UPDATE users SET name=?, mobile=?, post=?, bio=?, photo_path=? WHERE id=?";
        } else {
            sql = "UPDATE users SET name=?, mobile=?, post=?, bio=? WHERE id=?";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
                 PreparedStatement pst = con.prepareStatement(sql)) {

                pst.setString(1, name);
                pst.setString(2, mobile);
                pst.setString(3, post);
                pst.setString(4, bio);
                if (photoDbPath != null) {
                    pst.setString(5, photoDbPath);
                    pst.setInt(6, userId);
                } else {
                    pst.setInt(5, userId);
                }

                int updated = pst.executeUpdate();
                if (updated > 0) {
                    // update session attributes so profile.jsp shows new values immediately
                    session.setAttribute("name", name);
                    session.setAttribute("mobile", mobile);
                    session.setAttribute("post", post);
                    session.setAttribute("bio", bio);
                    if (photoDbPath != null) session.setAttribute("photo_path", photoDbPath);

                    response.sendRedirect("profile.jsp");
                } else {
                    response.getWriter().println("No rows updated.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
