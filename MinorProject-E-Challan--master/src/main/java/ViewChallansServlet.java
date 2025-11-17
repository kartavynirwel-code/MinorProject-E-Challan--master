import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;

public class ViewChallansServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<String> vehicleNumbers = new ArrayList<>();
        List<Integer> amounts = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/finepaygo", "root", "root");

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT vehicle_number, amount FROM challans");

            while (rs.next()) {
                vehicleNumbers.add(rs.getString("vehicle_number"));
                amounts.add(rs.getInt("amount"));
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("vehicleNumbers", vehicleNumbers);
        request.setAttribute("amounts", amounts);
        RequestDispatcher dispatcher = request.getRequestDispatcher("viewChallans.jsp");
        dispatcher.forward(request, response);
    }
}
