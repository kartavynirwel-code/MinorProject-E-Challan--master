import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Fetch form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Check for empty fields
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect("login.html?error=blank");
            return;
        }

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/finepaygo", "root", "root");

            // Prepare SQL query
            String query = "SELECT * FROM users WHERE username=? AND password=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);

            // Execute query
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // User exists: Start session and redirect to dashboard
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                response.sendRedirect("dashboard.jsp");
            } else {
                // Invalid login: Redirect to login page with error
                response.sendRedirect("login.html?error=invalid");
            }

            // Close connection
            con.close();
        } catch (Exception e) {
            // Log error for server-side debugging
            e.printStackTrace();

            // Redirect to login with generic error message
            response.sendRedirect("login.html?error=server");
        }
    }
}
