import java.io.File;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/IssueChallanServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 15
)
public class IssueChallanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String vehicleNumber = request.getParameter("vehicleNumber");
        String description = request.getParameter("description");
        String amountStr = request.getParameter("amount");

        double amount = Double.parseDouble(amountStr);

        // Normalize plate
        String normalizedPlate = vehicleNumber.replaceAll("[^A-Za-z0-9]", "").toUpperCase();

        // ---- Save Evidence ----
        Part filePart = request.getPart("evidence");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            filePart.write(uploadPath + File.separator + fileName);
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC",
                    "root",
                    "root"
            );

            // required fields
            String challanNo = "CHLN" + System.currentTimeMillis();
            int createdBy = 1; // default officer id

            String sql = """
                INSERT INTO challans 
                (challan_no, vehicle_plate, created_by, fine_amount, description, evidence_path)
                VALUES (?, ?, ?, ?, ?, ?)
            """;

            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, challanNo);
            pst.setString(2, normalizedPlate);
            pst.setInt(3, createdBy);
            pst.setDouble(4, amount);
            pst.setString(5, description);
            pst.setString(6, fileName);

            int result = pst.executeUpdate();

            if (result > 0) {
                response.sendRedirect("challan_success.jsp?vehicleNumber=" + normalizedPlate
                        + "&amount=" + amount + "&description=" + description);
            } else {
                response.getWriter().println("Failed to issue challan.");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
