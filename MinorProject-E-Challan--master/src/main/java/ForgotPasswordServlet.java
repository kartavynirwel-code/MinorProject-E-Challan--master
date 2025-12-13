import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    // ✅ Database connection method - UPDATED TO MATCH YOUR DB
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/echallan"; // ✅ Changed to echallan
        String dbUser = "root";
        String dbPass = "root"; // ✅ Your password
        return DriverManager.getConnection(url, dbUser, dbPass);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        System.out.println("📧 Searching for email: " + email); // Debug log

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            System.out.println("✅ Database connection established");

            // ✅ Check if email exists (removed user_id to avoid issues)
            String checkQuery = "SELECT username, email FROM users WHERE email = ?";
            checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, email);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                String username = rs.getString("username");
                System.out.println("✅ Email found for user: " + username);

                // Generate reset token
                String resetToken = UUID.randomUUID().toString();

                // Store token in database (expires in 1 hour)
                String updateQuery = "UPDATE users SET reset_token = ?, token_expiry = DATE_ADD(NOW(), INTERVAL 1 HOUR) WHERE email = ?";
                updateStmt = conn.prepareStatement(updateQuery);
                updateStmt.setString(1, resetToken);
                updateStmt.setString(2, email);
                int updated = updateStmt.executeUpdate();

                System.out.println("✅ Token updated for " + updated + " user(s)");

                // Print reset link to console (for testing)
                String resetLink = "http://localhost:8080/MinorProject_E_Challan_master_war/reset-password.html?token=" + resetToken;
                System.out.println("\n========================================");
                System.out.println("🔐 Password Reset Request");
                System.out.println("========================================");
                System.out.println("User: " + username);
                System.out.println("Email: " + email);
                System.out.println("Reset Link: " + resetLink);
                System.out.println("Token: " + resetToken);
                System.out.println("========================================\n");

                response.sendRedirect("forgot-password.html?success=true");
            } else {
                System.out.println("❌ Email not found in database: " + email);
                response.sendRedirect("forgot-password.html?error=true");
            }

        } catch (Exception e) {
            System.out.println("❌ Error occurred: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("forgot-password.html?error=true");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (updateStmt != null) updateStmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
