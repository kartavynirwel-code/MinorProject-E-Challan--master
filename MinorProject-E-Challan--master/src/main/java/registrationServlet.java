import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class registrationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/finepaygo","root", "root");

            String query = "INSERT INTO users (username, password, email) VALUES (?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, email);

            int result = pst.executeUpdate();
            if (result > 0) {
                response.sendRedirect("login.html");
            } else {
                response.getWriter().println("Registration Failed");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
