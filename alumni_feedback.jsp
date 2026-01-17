<%@ page import="java.sql.*" %>
<%
    HttpSession sessionObj = request.getSession(false); // Get existing session without creating a new one

    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Redirect to login page if session does not exist
        return; // Stop further execution
    }
%>

<html>
<head>
    <title>Alumni Feedback</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
       * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
body { display: flex; background: #f5f7fa; }
.sidebar {
            width: 260px; height: 100vh; background: #1e3c72; color: #fff; padding: 20px;
            position: fixed; left: 0; top: 0; display: flex; flex-direction: column;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar h2 { text-align: center; margin-bottom: 20px; font-weight: 600; }
.menu { list-style: none; padding: 0; }
.menu li { margin: 15px 0; }
.menu a {
    display: flex; align-items: center; padding: 12px; text-decoration: none; color: #fff;
    border-radius: 5px; transition: 0.3s; font-size: 16px;
}
.menu a:hover, .menu a.active { background: #fdbb2d; color: #1e3c72; }
.main-content {
    margin-left: 260px; padding: 30px; flex-grow: 1; display: flex; flex-direction: column;
}
header {
    background: #2a5298; color: #fff; padding: 15px; text-align: center;
    font-size: 1.8em; font-weight: 600; letter-spacing: 1px;
    border-radius: 10px;
}
.container {
    background: #fff;
    color: #000;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
    max-width: 1000px; /* Fixed width */
    width: 100%;
    margin: 30px auto; /* Centering */
    margin-left: 300px;
    min-height: 1200px; /* Increase height to ensure space */
    display: flex;
    flex-direction: column;
    justify-content: center; /* Center content vertically */
}


form {
    display: flex; flex-direction: column;
}
label, input, select, textarea {
    margin: 10px 0; padding: 10px; width: 100%;
    border: 1px solid #ccc; border-radius: 5px;
}
textarea { resize: vertical; }
button {
    padding: 10px; background: #1e3c72; color: white; border: none;
    cursor: pointer; border-radius: 5px; font-size: 16px; font-weight: bold;
    transition: 0.3s ease;
}
button:hover { background: #fdbb2d; color: #1e3c72; }
table {
    width: 100%; border-collapse: collapse; margin-top: 20px;
}
th, td {
    padding: 12px; border: 1px solid #ccc; text-align: center;
}
th {
    background: #6a11cb; color: white; text-transform: uppercase;
}
.footer {
    text-align: center; padding: 20px; background: #1e3c72; color: #fff;
    margin-top: 30px; border-radius: 10px;
}
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Alumni Panel</h2>
        <ul class="menu">
            <li><a href="alumni_dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="view_alumni.jsp"><i class="fas fa-users"></i> View Alumni</a></li>
            <li><a href="register_event.jsp"><i class="fas fa-calendar-check"></i> Register for Events</a></li>
            <li><a href="schedule_lecture.jsp"><i class="fas fa-chalkboard-teacher"></i> Schedule a Lecture</a></li>
            <li><a href="edit_profile.jsp"><i class="fas fa-user-edit"></i> Edit Profile</a></li>
            <li><a href="alumni_feedback.jsp" class="active"><i class="fas fa-comments"></i> Feedback</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    
    <div class="container">
        <header>Feedback</header>

        <!-- Feedback Form -->
        <form method="post">
            <label>Name:</label>
            <input type="text" name="name" required>

            <label>Email:</label>
            <input type="email" name="email" required>

            <label>Rating:</label>
            <select name="rating" required>
                <option value="5">1 2 3 4 5 (Excellent)</option>
                <option value="4">1 2 3 4 (Good)</option>
                <option value="3">1 2 3 (Average)</option>
                <option value="2">1 2 (Poor)</option>
                <option value="1">1 (Very Bad)</option>
            </select>

            <label>Comments:</label>
            <textarea name="comment" rows="4" required></textarea>

            <button type="submit" name="submit">Submit Feedback</button>
        </form>
        

        <hr>

        <!-- Display Feedback -->
        <%@ page import="java.sql.*" %>

        <% 
            // Database Connection
            String url = "jdbc:mysql://localhost:3306/alumni_management";
            String username = "root";
            String password = "root";
            Connection conn = null;
        
            try {
                Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL Driver
                conn = DriverManager.getConnection(url, username, password); // Connect to DB
            } catch (Exception e) {
                out.println("<p style='color:red;'>Database Connection Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
        
        <!-- Check if the connection is null before using it -->
        <% if (conn != null) { %>
        
       <!-- Scrollable Table -->
<div style="max-height: 400px; overflow-y: auto; border: 1px solid #ccc; border-radius: 5px; margin-top: 20px;">
    <table>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Rating</th>
            <th>Comment</th>
            <th>Admin Reply</th>
            <th>Submitted At</th>
        </tr>
        <%
            try {
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
        </tr>
        <%
                }
                rs.close();
                ps.close();
            } catch (SQLException e) {
                out.println("<p style='color:red;'>Error fetching feedback: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        %>
    </table>
</div>

        
        <% } else { %>
            <p style="color:red;">Unable to connect to the database. Please try again later.</p>
        <% } %>
        
        <%
            // Handle Feedback Submission
            if (request.getParameter("submit") != null && conn != null) {
                try {
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    int rating = Integer.parseInt(request.getParameter("rating"));
                    String comment = request.getParameter("comment");
        
                    String insertQuery = "INSERT INTO feedback (name, email, rating, comment, submitted_at) VALUES (?, ?, ?, ?, NOW())";
                    PreparedStatement insertPs = conn.prepareStatement(insertQuery);
                    insertPs.setString(1, name);
                    insertPs.setString(2, email);
                    insertPs.setInt(3, rating);
                    insertPs.setString(4, comment);
                    insertPs.executeUpdate();
                    insertPs.close();
        
                    out.println("<script>alert('Feedback submitted successfully!'); window.location='alumni_feedback.jsp';</script>");
                } catch (SQLException e) {
                    out.println("<p style='color:red;'>Error submitting feedback: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
            }
        
            // Close connection at the end
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        <div class="footer">&copy; 2025 Alumni Management System. All Rights Reserved.</div>
</body>
</html>
