import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class registrationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");

        // NOTE: role is always POLICE by default
        String role = "POLICE";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/echallan", "root", "root"
            );

            // Your updated SQL
            String query = "INSERT INTO users (username, password_hash, name, mobile, role, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, NOW())";

            PreparedStatement pst = con.prepareStatement(query);

            pst.setString(1, username);
            pst.setString(2, password);   // ⚠ hash later
            pst.setString(3, name);
            pst.setString(4, mobile);
            pst.setString(5, role);

            int result = pst.executeUpdate();

            if (result > 0) {
                response.sendRedirect("login.html");
            } else {
                response.getWriter().println("Registration failed");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
