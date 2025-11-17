import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/IssueChallanServlet")
public class IssueChallanServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String vehicleNumber = request.getParameter("vehicleNumber");
        String amount = request.getParameter("amount");
        String description = request.getParameter("description");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/finepaygo", "root", "root");

            String query = "INSERT INTO challans (vehicle_number, amount, description) VALUES (?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, vehicleNumber);
            pst.setString(2, amount);
            pst.setString(3, description);

            int result = pst.executeUpdate();
            if (result > 0) {
                // Redirect to a success page with details
                response.sendRedirect("challan_success.jsp?vehicleNumber=" + vehicleNumber + "&amount=" + amount + "&description=" + description);
            } else {
                response.getWriter().println("Failed to Issue Challan.");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}