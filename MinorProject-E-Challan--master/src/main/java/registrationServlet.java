import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class registrationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String role = request.getParameter("role"); // POLICE / GOV

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/echallan", "root", "root"
            );

            String sql = "INSERT INTO users (username, password_hash, name, role, mobile) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);

            pst.setString(1, username);
            pst.setString(2, password);  // hashing recommended later
            pst.setString(3, name);
            pst.setString(4, role);
            pst.setString(5, mobile);

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
