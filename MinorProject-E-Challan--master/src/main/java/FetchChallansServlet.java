import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

@WebServlet("/FetchChallansServlet")
public class FetchChallansServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String plate = request.getParameter("vehicleNumber");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (plate == null || plate.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            JsonObject e = new JsonObject();
            e.addProperty("error", "vehicleNumber is required");
            out.print(e.toString());
            return;
        }

        plate = plate.replaceAll("[^A-Za-z0-9]", "").toUpperCase();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC",
                    "root", "root")) {

                String sql = "SELECT id, challan_no, vehicle_plate, fine_amount, description, status, created_at "
                        + "FROM challans WHERE vehicle_plate = ? ORDER BY created_at DESC";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setString(1, plate);
                    try (ResultSet rs = pst.executeQuery()) {
                        JsonArray arr = new JsonArray();
                        while (rs.next()) {
                            JsonObject obj = new JsonObject();
                            obj.addProperty("id", rs.getInt("id"));
                            obj.addProperty("challanNo", rs.getString("challan_no"));
                            obj.addProperty("vehiclePlate", rs.getString("vehicle_plate"));
                            obj.addProperty("fineAmount", rs.getDouble("fine_amount"));
                            obj.addProperty("description", rs.getString("description"));
                            obj.addProperty("status", rs.getString("status"));
                            obj.addProperty("createdAt", rs.getString("created_at"));
                            arr.add(obj);
                        }
                        out.print(arr.toString());
                    }
                }
            }
        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject err = new JsonObject();
            err.addProperty("error", ex.getMessage());
            out.print(err.toString());
            ex.printStackTrace();
        }
    }
}
