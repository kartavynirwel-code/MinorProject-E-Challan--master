
import java.io.IOException;
import java.sql.*;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

@WebServlet("/api/challans")
public class ChallanDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root";

    // ISO 8601 formatter
    private static final DateTimeFormatter ISO_FMT = DateTimeFormatter.ISO_OFFSET_DATE_TIME.withZone(ZoneId.systemDefault());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonArray data = new JsonArray();

        String sql = "SELECT challan_no, vehicle_plate, fine_amount, status, created_at FROM challans";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
                 PreparedStatement pst = con.prepareStatement(sql);
                 ResultSet rs = pst.executeQuery()) {

                while (rs.next()) {
                    JsonObject obj = new JsonObject();
                    obj.addProperty("challanNo", rs.getString("challan_no"));
                    obj.addProperty("vehiclePlate", rs.getString("vehicle_plate"));
                    obj.addProperty("fineAmount", rs.getDouble("fine_amount"));
                    obj.addProperty("status", rs.getString("status"));

                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        obj.addProperty("issueDate", ISO_FMT.format(ts.toInstant()));
                    } else {
                        obj.add("issueDate", null);
                    }

                    data.add(obj);
                }

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(data.toString());
            }

        } catch (ClassNotFoundException cnf) {
            cnf.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject err = new JsonObject();
            err.addProperty("error", "JDBC Driver not found: " + cnf.getMessage());
            response.getWriter().write(err.toString());
        } catch (SQLException sqle) {
            sqle.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject err = new JsonObject();
            err.addProperty("error", "Database error: " + sqle.getMessage());
            response.getWriter().write(err.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject err = new JsonObject();
            err.addProperty("error", "Server error: " + e.getMessage());
            response.getWriter().write(err.toString());
        }
    }
}
