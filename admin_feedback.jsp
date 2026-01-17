<%@ page import="java.sql.*" %>

<% 
    // Database Connection
    String url = "jdbc:mysql://localhost:3306/alumni_management";
    String username = "root";
    String password = "root";
    Connection conn = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
    } catch (Exception e) {
        out.println("Database Connection Error: " + e.getMessage());
    }
%>
<%
    HttpSession sessionObj = request.getSession(false); // Get existing session without creating a new one

    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Redirect to login page if session does not exist
        return; // Stop further execution
    }
%>

<html>
<head>
    <title>Admin - Review Feedback</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-4">
        <h2 class="text-center text-primary">Alumni Feedback Review</h2>
        
        <table class="table table-bordered table-hover mt-3">
            <thead class="table-dark">
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Rating</th>
                    <th>Comment</th>
                    <th>Admin Reply</th>
                    <th>Submitted At</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Fetch feedback from the database
                    String query = "SELECT * FROM feedback ORDER BY submitted_at DESC";
                    PreparedStatement ps = conn.prepareStatement(query);
                    ResultSet rs = ps.executeQuery();
                    
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getInt("rating") %></td>
                    <td><%= rs.getString("comment") %></td>
                    <td><%= rs.getString("admin_reply") == null ? "No Reply" : rs.getString("admin_reply") %></td>
                    <td><%= rs.getTimestamp("submitted_at") %></td>
                    <td>
                        <form method="post">
                            <input type="hidden" name="feedbackId" value="<%= rs.getInt("id") %>">
                            <input type="text" name="reply" class="form-control" required>
                            <button type="submit" name="submitReply" class="btn btn-primary mt-2">Submit</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <%-- Handle Reply Submission --%>
    <%
        if (request.getParameter("submitReply") != null) {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            String adminReply = request.getParameter("reply");

            String updateQuery = "UPDATE feedback SET admin_reply = ? WHERE id = ?";
            PreparedStatement updatePs = conn.prepareStatement(updateQuery);
            updatePs.setString(1, adminReply);
            updatePs.setInt(2, feedbackId);
            updatePs.executeUpdate();

            out.println("<script>alert('Reply submitted successfully!'); window.location='admin_feedback.jsp';</script>");
        }
    %>
</body>
</html>
