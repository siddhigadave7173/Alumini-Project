<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sessionObj = request.getSession(false); // Get existing session without creating a new one

    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Redirect to login page if session does not exist
        return; // Stop further execution
    }
%>

<%
  
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/alumni_management";
    String user = "root";
    String password = "root";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, user, password);
        
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String eventName = request.getParameter("event_name");
            String date = request.getParameter("date");
            String description = request.getParameter("description");
            
            String sql = "INSERT INTO event (ev_title, date, description) VALUES (?, ?, ?)";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, eventName);
            stmt.setString(2, date);
            stmt.setString(3, description);
            stmt.executeUpdate();
            
            out.println("<p style='color: lightgreen; text-align:center;'>Event Added Successfully!</p>");
        }
        
        if (request.getParameter("delete") != null) {
            String sql = "DELETE FROM event WHERE ev_id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(request.getParameter("delete")));
            stmt.executeUpdate();
            response.sendRedirect("admin_manage_events.jsp");
        }
        
        String fetchQuery = "SELECT * FROM event ORDER BY date ASC";
        stmt = con.prepareStatement(fetchQuery);
        rs = stmt.executeQuery();
        
        List<Map<String, String>> events = new ArrayList<>();
        while (rs.next()) {
            Map<String, String> event = new HashMap<>();
            event.put("ev_id", rs.getString("ev_id"));
            event.put("ev_title", rs.getString("ev_title"));
            event.put("date", rs.getString("date"));
            event.put("description", rs.getString("description"));
            events.add(event);
        }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events | Alumni Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body { font-family: 'Arial', sans-serif; background: linear-gradient(to right, #1e3c72, #2a5298); color: #fff; text-align: center; }
        .navbar { background: rgba(0, 0, 0, 0.3); padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { margin: 0; font-size: 1.8em; text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.4); }
        .navbar a { text-decoration: none; color: #fdbb2d; font-size: 1.2em; font-weight: bold; padding: 8px 15px; }
        .content { padding: 50px 20px; }
        form { background: rgba(255, 255, 255, 0.9); color: #000; padding: 30px; border-radius: 10px; max-width: 600px; margin: auto; }
        label { font-weight: bold; display: block; margin-top: 10px; text-align: left; }
        input, textarea { width: 100%; padding: 10px; margin: 5px 0; border-radius: 5px; }
        button { width: 100%; padding: 12px; background: #fdbb2d; color: #000; border-radius: 5px; font-size: 1.2em; }
        .events-section { margin: 40px auto; max-width: 80%; }
        .events-table { width: 100%; border-collapse: collapse; background: rgba(255, 255, 255, 0.9); color: black; }
        .events-table th, .events-table td { padding: 12px; border: 1px solid #ddd; }
        .events-table th { background: #fdbb2d; color: #000; }
        a.delete-btn { color: red; font-weight: bold; }
		.back-btn {
            text-decoration: none;
            color: #fdbb2d;
            font-size: 1.2em;
            font-weight: bold;
            padding: 10px 15px;
            border-radius: 5px;
            transition: 0.3s;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
        }
        .back-btn i {
            margin-right: 5px;
        }
        .back-btn:hover {
            background: #fdbb2d;
            color: #000;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Alumni Management System</h1>
        <a href="admin_dashboard.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>
    <div class="content">
        <h2>Add Event</h2>
        <form method="post">
            <label for="event_name">Event Name:</label>
            <input type="text" id="event_name" name="event_name" required>
            <label for="date">Date:</label>
            <input type="date" id="date" name="date" required>
            <label for="description">Description:</label>
            <textarea id="description" name="description" required></textarea>
            <button type="submit">Add Event</button>
        </form>
    </div>
    <div class="events-section">
        <h2>Upcoming Events</h2>
        <% if (!events.isEmpty()) { %>
        <table class="events-table">
            <tr>
                <th>Event Name</th>
                <th>Date</th>
                <th>Description</th>
                <th>Action</th>
            </tr>
            <% for (Map<String, String> event : events) { %>
            <tr>
                <td><%= event.get("ev_title") %></td>
                <td><%= event.get("date") %></td>
                <td><%= event.get("description") %></td>
                <td><a class="delete-btn" href="?delete=<%= event.get("ev_id") %>" onclick="return confirm('Delete this event?')">Delete</a></td>
            </tr>
            <% } %>
        </table>
        <% } else { %>
        <p>No upcoming events.</p>
        <% } %>
    </div>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    }
%>