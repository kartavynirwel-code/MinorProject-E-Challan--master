import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/api/challans")
public class ChallanDataServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        out.print("[");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/echallan",
                    "root",
                    "root"
            );

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(
                    "SELECT challan_no, fine_amount FROM challans"
            );

            boolean first = true;
            while (rs.next()) {
                if (!first) out.print(",");
                out.print("{");
                out.print("\"challan_no\":\"" + rs.getString("challan_no") + "\",");
                out.print("\"fine_amount\":" + rs.getInt("fine_amount"));
                out.print("}");
                first = false;
            }

            out.print("]");
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("{\"error\":\"server error\"}");
        }
    }
}
