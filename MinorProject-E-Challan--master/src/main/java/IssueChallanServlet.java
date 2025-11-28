import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

@WebServlet("/IssueChallanServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,      // 1 MB
        maxFileSize = 1024 * 1024 * 10,           // 10 MB
        maxRequestSize = 1024 * 1024 * 15         // 15 MB
)
public class IssueChallanServlet extends HttpServlet {

    // TODO: replace with secure config loading (env vars, properties file, etc.)
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root";

    // Twilio placeholders — replace with your real credentials or load from env
    private static final String TW_ACCOUNT_SID = "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    private static final String TW_AUTH_TOKEN  = "your_auth_token";
    private static final String TW_FROM_PHONE  = "+10000000000";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // require login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.html");
            return;
        }
        Integer createdBy = (Integer) session.getAttribute("userId");

        String vehicleNumber = trim(request.getParameter("vehicleNumber"));
        String description = trim(request.getParameter("description"));
        String amountStr = trim(request.getParameter("amount"));

        if (vehicleNumber.isEmpty()) {
            response.getWriter().println("Error: vehicleNumber is required.");
            return;
        }

        // normalize plate
        String normalizedPlate = vehicleNumber.replaceAll("[^A-Za-z0-9]", "").toUpperCase();

        // parse amount (fallback 0)
        double amount = 0;
        try {
            if (!amountStr.isEmpty()) amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException nfe) {
            amount = 0;
        }

        // handle evidence upload
        Part filePart = request.getPart("evidence"); // form field name must be "evidence"
        String evidenceDbPath = null;

        if (filePart != null && filePart.getSize() > 0) {
            String uploadsReal = getServletContext().getRealPath("/uploads");
            File uploadsDir = new File(uploadsReal);
            if (!uploadsDir.exists() && !uploadsDir.mkdirs()) {
                response.getWriter().println("Error: cannot create uploads directory");
                return;
            }

            String submitted = filePart.getSubmittedFileName();
            String sanitized = (submitted == null) ? "evidence" : submitted.replaceAll("[^A-Za-z0-9._-]", "_");
            String ext = "";
            int dot = sanitized.lastIndexOf('.');
            if (dot >= 0) ext = sanitized.substring(dot);
            String fileName = "evidence_" + System.currentTimeMillis() + ext;

            Path outPath = Path.of(uploadsReal, fileName);
            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in, outPath);
            } catch (IOException ioe) {
                ioe.printStackTrace();
                response.getWriter().println("Error saving uploaded file: " + ioe.getMessage());
                return;
            }

            evidenceDbPath = "uploads/" + fileName;
        }

        // Insert challan and then send SMS if owner exists
        String insertSql = "INSERT INTO challans (challan_no, vehicle_plate, created_by, fine_amount, description, status, evidence_path, created_at) "
                + "VALUES (CONCAT('CHLN', UNIX_TIMESTAMP()), ?, ?, ?, ?, 'UNPAID', ?, NOW())";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            response.getWriter().println("JDBC driver missing: " + cnfe.getMessage());
            return;
        }

        try (Connection con = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
             PreparedStatement pst = con.prepareStatement(insertSql)) {

            pst.setString(1, normalizedPlate);
            pst.setInt(2, createdBy);
            pst.setDouble(3, amount);
            pst.setString(4, description);
            pst.setString(5, evidenceDbPath);

            int rows = pst.executeUpdate();
            if (rows <= 0) {
                response.getWriter().println("Failed to insert challan.");
                return;
            }

            // lookup owner info
            String ownerMobile = null;
            String ownerName = null;
            String q = "SELECT owner_name, owner_mobile FROM vehicles WHERE plate = ? LIMIT 1";
            try (PreparedStatement p2 = con.prepareStatement(q)) {
                p2.setString(1, normalizedPlate);
                try (ResultSet rs = p2.executeQuery()) {
                    if (rs.next()) {
                        ownerName = rs.getString("owner_name");
                        ownerMobile = rs.getString("owner_mobile");
                    }
                }
            } catch (SQLException e) {
                // ignore lookup error but log
                e.printStackTrace();
            }

            // try to send SMS if mobile present
            if (ownerMobile != null && !ownerMobile.trim().isEmpty()) {
                try {
                    // initialize Twilio (safe to call even if keys are placeholders)
                    Twilio.init(TW_ACCOUNT_SID, TW_AUTH_TOKEN);

                    String sms = "FineSnap: A challan has been issued.\nVehicle: " + normalizedPlate
                            + "\nAmount: ₹" + amount
                            + (description != null && !description.isEmpty() ? "\nReason: " + description : "")
                            + "\nPay at: yourdomain.com/pay";

                    Message.creator(new PhoneNumber(ownerMobile), new PhoneNumber(TW_FROM_PHONE), sms).create();
                } catch (Exception ex) {
                    // Twilio fail — don't block flow, only log
                    ex.printStackTrace();
                }
            }

            // redirect to success page
            String encPlate = URLEncoder.encode(normalizedPlate, "UTF-8");
            String encDesc = description == null ? "" : URLEncoder.encode(description, "UTF-8");
            String encAmount = URLEncoder.encode(String.valueOf(amount), "UTF-8");

            response.sendRedirect("challan_success.jsp?vehicleNumber=" + encPlate + "&amount=" + encAmount + "&description=" + encDesc);

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }

    private static String trim(String s) {
        return (s == null) ? "" : s.trim();
    }
}
