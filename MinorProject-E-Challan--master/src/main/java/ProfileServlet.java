import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class ProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve the existing session without creating a new one
        HttpSession session = request.getSession(false);
        String username = null;

        // Check if session exists and retrieve the username
        if (session != null) {
            username = (String) session.getAttribute("username");
        }

        // If username is not found, redirect to the login page
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Set the username as a request attribute and forward to JSP
        request.setAttribute("username", username);
        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }
}
