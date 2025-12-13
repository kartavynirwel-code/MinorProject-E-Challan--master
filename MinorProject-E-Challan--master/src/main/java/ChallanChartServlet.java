import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/chart-data")
public class ChallanChartServlet extends HttpServlet {

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 🔹 Read filter parameters
        String statusFilter = request.getParameter("filter");
        String periodFilter = request.getParameter("period");

        if (statusFilter == null || statusFilter.equalsIgnoreCase("All")) {
            statusFilter = "ALL";
        }

        if (periodFilter == null) {
            periodFilter = "month"; // Default to "This Month"
        }

        // 🔹 Base SQL (date-wise total)
        StringBuilder sql = new StringBuilder(
                "SELECT DATE(created_at) AS challan_date, " +
                        "SUM(fine_amount) AS total_amount " +
                        "FROM challans WHERE 1=1 "
        );

        // 🔹 Apply status filter
        if (statusFilter.equalsIgnoreCase("Paid")) {
            sql.append("AND status = 'PAID' ");
        } else if (statusFilter.equalsIgnoreCase("Unpaid")) {
            sql.append("AND status = 'UNPAID' ");
        }

        // 🔹 Apply period filter
        switch (periodFilter.toLowerCase()) {
            case "today":
                sql.append("AND DATE(created_at) = CURDATE() ");
                break;
            case "month":
                sql.append("AND MONTH(created_at) = MONTH(CURDATE()) ");
                sql.append("AND YEAR(created_at) = YEAR(CURDATE()) ");
                break;
            case "year":
                sql.append("AND YEAR(created_at) = YEAR(CURDATE()) ");
                break;
        }

        sql.append("GROUP BY DATE(created_at) ORDER BY DATE(created_at)");

        System.out.println("📊 Chart Query: " + sql.toString()); // Debug log

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(sql.toString())) {

                out.print("[");
                boolean first = true;
                int recordCount = 0;

                while (rs.next()) {
                    if (!first) out.print(",");

                    out.print("{");
                    out.print("\"date\":\"" + rs.getString("challan_date") + "\",");
                    out.print("\"total\":" + rs.getInt("total_amount"));
                    out.print("}");

                    first = false;
                    recordCount++;
                }
                out.print("]");

                System.out.println("✅ Returned " + recordCount + " records"); // Debug log

            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"server error\"}");
        }
    }
}
