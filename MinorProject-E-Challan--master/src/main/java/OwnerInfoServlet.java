
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/OwnerInfoServlet")
public class OwnerInfoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        String vehicleNumber = request.getParameter("vehicleNumber");

        PrintWriter out = response.getWriter();
        
        // Start HTML page with Bootstrap
        out.println("<!DOCTYPE html>");
        out.println("<html><head>");
        out.println("<title>Owner Information</title>");
        out.println("<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'>");
        out.println("</head><body class='bg-light'>");
        out.println("<div class='container mt-5'>");
        out.println("<div class='card shadow p-4'>");
        out.println("<h2 class='text-center text-primary'>Vehicle Owner Information</h2><hr>");

        String dbURL = "jdbc:mysql://localhost:3306/finepaygo";
        String dbUser = "root";
        String dbPassword = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                 PreparedStatement pst = con.prepareStatement("SELECT * FROM vehicle_owners WHERE vehicle_number=?")) {

                pst.setString(1, vehicleNumber);
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        out.println("<table class='table table-bordered'>");
                        out.println("<tr><th>Owner Name</th><td>" + rs.getString("owner_name") + "</td></tr>");
                        out.println("<tr><th>Contact Number</th><td>" + rs.getString("contact_number") + "</td></tr>");
                        out.println("<tr><th>Address</th><td>" + rs.getString("address") + "</td></tr>");
                        out.println("</table>");
                    } else {
                        out.println("<p class='text-danger text-center'>No Owner Found for Vehicle Number: <strong>" + vehicleNumber + "</strong></p>");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
        }

        // Closing tags
        out.println("<a href='index.html' class='btn btn-primary mt-3'>Back</a>");
        out.println("</div></div>");
        out.println("</body></html>");
    }
}

