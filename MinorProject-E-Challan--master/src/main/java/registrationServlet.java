import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/registrationServlet")
public class registrationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ✅ Get all form parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");  // ✅ Added email
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // ✅ Validate passwords match on server side
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("registration.html?error=password");
            return;
        }

        // Default role is POLICE
        String role = "POLICE";

        Connection con = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/echallan", "root", "root"
            );

            // ✅ Check if username or email already exists
            String checkQuery = "SELECT username, email FROM users WHERE username = ? OR email = ?";
            checkStmt = con.prepareStatement(checkQuery);
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                // User already exists
                response.sendRedirect("registration.html?error=exists");
                return;
            }

            // ✅ Insert new user with email
            String insertQuery = "INSERT INTO users (username, email, password_hash, role, created_at) " +
                    "VALUES (?, ?, ?, ?, NOW())";

            insertStmt = con.prepareStatement(insertQuery);
            insertStmt.setString(1, username);
            insertStmt.setString(2, email);        // ✅ Email added
            insertStmt.setString(3, password);     // ⚠️ Consider hashing later
            insertStmt.setString(4, role);

            int result = insertStmt.executeUpdate();

            if (result > 0) {
                // ✅ Success - redirect to registration page with success message
                response.sendRedirect("registration.html?success=true");
            } else {
                response.sendRedirect("registration.html?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registration.html?error=failed");
        } finally {
            // ✅ Close all resources
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
