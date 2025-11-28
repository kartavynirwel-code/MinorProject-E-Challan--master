// package statement if you use one, e.g. package com.echallan.servlets;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.JsonObject;

@WebServlet("/FetchOwnerServlet")
public class FetchOwnerServlet extends HttpServlet {
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

        // Normalize plate
        plate = plate.replaceAll("[^A-Za-z0-9]", "").toUpperCase();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/echallan", "root", "root")) {

                String sql = "SELECT owner_name, owner_mobile, owner_address FROM vehicles WHERE plate = ?";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setString(1, plate);
                    try (ResultSet rs = pst.executeQuery()) {
                        JsonObject result = new JsonObject();
                        if (rs.next()) {
                            result.addProperty("found", true);
                            result.addProperty("owner_name", rs.getString("owner_name"));
                            result.addProperty("owner_mobile", rs.getString("owner_mobile"));
                            result.addProperty("owner_address", rs.getString("owner_address"));
                        } else {
                            result.addProperty("found", false);
                        }
                        out.print(result.toString());
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
