import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public class ChallanDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonArray data = new JsonArray();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/echallan",
                    "root",
                    "root"
            );

            String query = "SELECT challan_no, vehicle_plate, fine_amount, status, created_at FROM challans";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                JsonObject record = new JsonObject();
                record.addProperty("challanNo", rs.getString("challan_no"));
                record.addProperty("vehiclePlate", rs.getString("vehicle_plate"));
                record.addProperty("fineAmount", rs.getDouble("fine_amount"));
                record.addProperty("status", rs.getString("status"));
                record.addProperty("issueDate", rs.getString("created_at"));

                data.add(record);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.getWriter().write(data.toString());
    }
}
