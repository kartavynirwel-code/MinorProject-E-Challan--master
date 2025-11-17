import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.google.gson.JsonArray;     // Correct Gson Imports
import com.google.gson.JsonObject;

public class ChallanDataServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonArray data = new JsonArray();  // This is now Google's JsonArray

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/finepaygo", "root", "root");

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT vehicle_number, amount, date_issued FROM challans");

            while (rs.next()) {
                JsonObject record = new JsonObject();
                record.addProperty("vehicleNumber", rs.getString("vehicle_number"));
                record.addProperty("amount", rs.getInt("amount"));
                record.addProperty("issueDate", rs.getString("date_issued"));
                data.add(record);  // This works correctly with Google's JsonArray
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.getWriter().write(data.toString());
    }
}