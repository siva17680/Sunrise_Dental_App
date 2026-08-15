<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("user") == null) {
        response.sendRedirect("index.jsp?error=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Sunrise Dental Clinic</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .dashboard { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ecf0f1; padding-bottom: 10px; margin-bottom: 20px; }
        h2 { color: #2c3e50; margin: 0; }
        .menu { display: flex; flex-direction: column; gap: 15px; }
        .menu a { text-decoration: none; background: #3498db; color: white; padding: 15px; border-radius: 5px; text-align: center; font-size: 18px; transition: 0.3s; }
        .menu a:hover { background: #2980b9; }
        .logout { color: #e74c3c; text-decoration: none; font-weight: bold; }
        .msg { color: #2ecc71; margin-bottom: 10px; text-align: center; }
        .error { color: #e74c3c; margin-bottom: 10px; text-align: center; }
    </style>
</head>
<body>
    <div class="dashboard">
        <div class="header">
            <h2>Welcome, <%= session.getAttribute("user") %></h2>
            <a href="LogoutServlet" class="logout">Logout</a>
        </div>
        
        <% if (request.getParameter("msg") != null) { %>
            <div class="msg"><%= request.getParameter("msg") %></div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="error"><%= request.getParameter("error") %></div>
        <% } %>

        <div class="menu">
            <a href="register.jsp">Register New Appointment</a>
            <a href="view.jsp">Search / View Appointment</a>
            <a href="help.jsp">Help / Instructions</a>
        </div>
    </div>
</body>
</html>
