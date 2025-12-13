import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/UpdateChallanStatusServlet")
public class UpdateChallanStatusServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // ✅ Changed parameter name from challanId to challanNo
        String challanNo = request.getParameter("challanNo");
        String status = request.getParameter("status");

        // Validate input parameters
        if (challanNo == null || challanNo.trim().isEmpty()) {
            out.print("{\"success\": false, \"error\": \"Challan number is required\"}");
            System.out.println("❌ Error: Challan number is missing");
            return;
        }

        if (status == null || status.trim().isEmpty()) {
            out.print("{\"success\": false, \"error\": \"Status is required\"}");
            System.out.println("❌ Error: Status is missing");
            return;
        }

        // Validate status value
        if (!status.equals("PAID") && !status.equals("UNPAID")) {
            out.print("{\"success\": false, \"error\": \"Invalid status value\"}");
            System.out.println("❌ Error: Invalid status - " + status);
            return;
        }

        Connection con = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            System.out.println("✅ Database connected");
            System.out.println("📝 Updating Challan No: " + challanNo + " to status: " + status);

            // ✅ Using challan_no column name from your database
            String query = "UPDATE challans SET status = ? WHERE challan_no = ?";
            pst = con.prepareStatement(query);
            pst.setString(1, status);
            pst.setString(2, challanNo);

            int result = pst.executeUpdate();

            if (result > 0) {
                out.print("{\"success\": true, \"message\": \"Status updated successfully\"}");
                System.out.println("✅ Status updated successfully for Challan No: " + challanNo);
            } else {
                out.print("{\"success\": false, \"error\": \"Challan not found\"}");
                System.out.println("❌ Challan not found: " + challanNo);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"Database driver not found\"}");

        } catch (SQLException e) {
            System.err.println("❌ SQL Error: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"Database error: " + escapeJson(e.getMessage()) + "\"}");

        } catch (Exception e) {
            System.err.println("❌ Unexpected error: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"Unexpected error occurred\"}");

        } finally {
            try {
                if (pst != null) {
                    pst.close();
                    System.out.println("🔒 PreparedStatement closed");
                }
                if (con != null) {
                    con.close();
                    System.out.println("🔒 Connection closed");
                }
            } catch (SQLException e) {
                System.err.println("❌ Error closing resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    /**
     * Escape special characters in JSON strings
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": false, \"error\": \"GET method not supported. Use POST.\"}");
    }
}
