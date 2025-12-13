import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    // Default values (will be overridden by environment variables if present)
    private static final String DEFAULT_JDBC_URL = "jdbc:mysql://localhost:3306/echallan?useSSL=false&serverTimezone=UTC";
    private static final String DEFAULT_DB_USER = "root";
    private static final String DEFAULT_DB_PASS = "root";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Accept UTF-8 input
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Read DB config from environment (useful for deployment), fallback to defaults
        final String JDBC_URL = getEnv("JDBC_URL", DEFAULT_JDBC_URL);
        final String DB_USER = getEnv("DB_USER", DEFAULT_DB_USER);
        final String DB_PASS = getEnv("DB_PASS", DEFAULT_DB_PASS);

        // Read and trim inputs
        String username = trimParam(request.getParameter("username"));
        String password = trimParam(request.getParameter("password"));

        // Basic validation
        if (username.isEmpty() || password.isEmpty()) {
            response.sendRedirect("login.html");
            return;
        }

        // Query DB for user
        String sql = "SELECT id, username, password_hash, name, role, mobile, post, photo_path, bio "
                + "FROM users WHERE username = ? LIMIT 1";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
                 PreparedStatement pst = con.prepareStatement(sql)) {

                pst.setString(1, username);

                try (ResultSet rs = pst.executeQuery()) {
                    if (!rs.next()) {
                        // user not found
                        response.sendRedirect("login.html");
                        return;
                    }

                    String storedHash = rs.getString("password_hash");
                    boolean passwordMatches = verifyPassword(password, storedHash);

                    if (!passwordMatches) {
                        response.sendRedirect("login.html");
                        return;
                    }

                    // Successful login -> create session and set attributes
                    HttpSession session = request.getSession(true);
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("userId", rs.getInt("id"));       // required for created_by etc.
                    session.setAttribute("name", rs.getString("name"));
                    session.setAttribute("role", rs.getString("role"));
                    session.setAttribute("mobile", rs.getString("mobile"));
                    session.setAttribute("post", rs.getString("post"));
                    session.setAttribute("photo_path", rs.getString("photo_path"));
                    session.setAttribute("bio", rs.getString("bio"));

                    // session timeout: 30 minutes (adjust if needed)
                    session.setMaxInactiveInterval(30 * 60);

                    // Redirect to dashboard (use context path to be safe)
                    response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                }
            }

        } catch (Exception e) {
            // log server error and redirect with server error flag
            e.printStackTrace();
            response.sendRedirect("login.html");
        }
    }

    // helper to avoid NPE and trim
    private static String trimParam(String s) {
        return (s == null) ? "" : s.trim();
    }

    // helper to read environment variables with fallback
    private static String getEnv(String name, String fallback) {
        String v = System.getenv(name);
        return (v == null || v.isEmpty()) ? fallback : v;
    }

    /**
     * Verify password:
     * - If storedHash looks like a bcrypt hash (starts with $2a$, $2b$, $2y$),
     *   attempt to verify using BCrypt via reflection (optional dependency).
     * - If BCrypt isn't available or storedHash isn't bcrypt, fall back to plain compare.
     *
     * Reflection is used so this servlet compiles even if BCrypt library is not added.
     */
    private static boolean verifyPassword(String plainPassword, String storedHash) {
        if (storedHash == null) {
            return false;
        }

        String lower = storedHash.toLowerCase();
        boolean looksLikeBcrypt = lower.startsWith("$2a$") || lower.startsWith("$2b$") || lower.startsWith("$2y$");

        if (looksLikeBcrypt) {
            try {
                // Use reflection to avoid compile-time dependency on org.mindrot.jbcrypt.BCrypt
                Class<?> bcClass = Class.forName("org.mindrot.jbcrypt.BCrypt");
                java.lang.reflect.Method checkpw = bcClass.getMethod("checkpw", String.class, String.class);
                Object result = checkpw.invoke(null, plainPassword, storedHash);
                if (result instanceof Boolean) {
                    return (Boolean) result;
                }
            } catch (ClassNotFoundException cnf) {
                // BCrypt not present on classpath — fall back to plain comparison below
            } catch (Exception ex) {
                // any other reflection error — log and fall back
                ex.printStackTrace();
            }
        }

        // fallback (insecure if DB stores plain text) — keep for backward compatibility
        return plainPassword.equals(storedHash);
    }
}