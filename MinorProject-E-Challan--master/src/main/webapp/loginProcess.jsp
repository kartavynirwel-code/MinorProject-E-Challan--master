<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // 🔐 TEMP LOGIN (replace with DB later)
    if ("admin".equals(username) && "admin123".equals(password)) {

        session.setAttribute("userId", 1);
        session.setAttribute("username", username);

        response.sendRedirect("dashboard.jsp");
    } else {
        response.sendRedirect("login.jsp?error=1");
    }
%>
