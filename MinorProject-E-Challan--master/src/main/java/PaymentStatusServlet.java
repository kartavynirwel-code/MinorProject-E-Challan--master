import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class PaymentStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String vehicleNumber = request.getParameter("vehicleNumber");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/finepaygo", "root", "root");

            String query = "SELECT * FROM challans WHERE vehicle_number=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, vehicleNumber);
            ResultSet rs = pst.executeQuery();

            PrintWriter out = response.getWriter();
            out.println("<h2>Challan Payment Status</h2>");
            while (rs.next()) {
                out.println("<p>Challan ID: " + rs.getInt("challan_id") + "</p>");
                out.println("<p>Amount: " + rs.getDouble("amount") + "</p>");
                out.println("<p>Description: " + rs.getString("description") + "</p>");
                out.println("<p>Date Issued: " + rs.getTimestamp("date_issued") + "</p>");
                out.println("<hr>");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
