<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sessionObj = request.getSession(false); // Get existing session without creating a new one

    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Redirect to login page if session does not exist
        return; // Stop further execution
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register for Events | Alumni Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { display: flex; background: #f5f7fa; }
        .sidebar {
            width: 260px; height: 100vh; background: #1e3c72; color: #fff; padding: 20px;
            position: fixed; left: 0; top: 0; display: flex; flex-direction: column;
        }
        .sidebar h2 { text-align: center; margin-bottom: 20px; }
        .menu { list-style: none; padding: 0; }
        .menu li { margin: 15px 0; }
        .menu a {
            display: flex; align-items: center; padding: 12px; text-decoration: none; color: #fff;
            border-radius: 5px; transition: 0.3s;
        }
        .menu a i { margin-right: 12px; }
        .menu a:hover, .menu a.active { background: #fdbb2d; color: #1e3c72; }
        .main-content {
            margin-left: 260px; padding: 30px; flex-grow: 1;
        }
        header {
            background: #2a5298; color: #fff; padding: 15px; text-align: center;
            font-size: 1.8em; font-weight: 600;
            border-radius: 10px;
        }
        .container {
            background: white; padding: 20px; margin: 30px auto; width: 60%; border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        label, input, select, button {
            display: block; width: 100%; padding: 10px; margin: 10px 0;
        }
        button {
            background: #1e3c72; color: white; border: none; cursor: pointer; border-radius: 5px;
        }
        button:hover { background: #0056b3; }
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
            <li><a href="register_event.jsp" class="active"><i class="fas fa-calendar-alt"></i> Register for Events</a></li>
            <li><a href="schedule_lecture.jsp"><i class="fas fa-chalkboard-teacher"></i> Schedule a Lecture</a></li>
            <li><a href="edit_profile.jsp"><i class="fas fa-user-edit"></i> Edit Profile</a></li>
            <li><a href="alumni_feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>Register for Events</header>
        <div class="container">
            <h2>Available Events</h2>

            <%@ page import="java.sql.*" %>
            <%
                Connection con = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                String message = "";
            
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/alumni_management", "root", "root");
            
                    // Fetch events
                    String eventQuery = "SELECT * FROM event";
                    stmt = con.prepareStatement(eventQuery);
                    rs = stmt.executeQuery();
            %>
                    <form method="post">
                        <label>Enter Your Contact Number:</label>
                        <input type="text" name="contact" required pattern="\d{10}" placeholder="Enter 10-digit contact">
                        <select name="event_id" required>
                            <%
                                while (rs.next()) {
                            %>
                                <option value="<%= rs.getInt("ev_id") %>"><%= rs.getString("ev_title") %> - <%= rs.getString("date") %></option>
                            <%
                                }
                            %>
                        </select>
                        <button type="submit">Register</button>
                    </form>
            <%
                    rs.close();
                    stmt.close();
            
                    if ("POST".equalsIgnoreCase(request.getMethod())) {
                        String contact = request.getParameter("contact");
                        int ev_id = Integer.parseInt(request.getParameter("event_id"));
                        String reg_date = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
            
                        // Check if alumni exists
                        String getAlumniQuery = "SELECT al_no FROM alumni WHERE contact = ?";
                        stmt = con.prepareStatement(getAlumniQuery);
                        stmt.setString(1, contact);
                        rs = stmt.executeQuery();
            
                        if (rs.next()) {
                            int al_no = rs.getInt("al_no");
                            rs.close();
                            stmt.close();
            
                            // Check if already registered
                            String checkQuery = "SELECT * FROM al_ev WHERE al_no = ? AND ev_id = ?";
                            stmt = con.prepareStatement(checkQuery);
                            stmt.setInt(1, al_no);
                            stmt.setInt(2, ev_id);
                            rs = stmt.executeQuery();
            
                            if (rs.next()) {
                                message = "<p style='color: red;'>You have already registered for this event.</p>";
                            } else {
                                rs.close();
                                stmt.close();
            
                                // Register for event
                                String registerQuery = "INSERT INTO al_ev (al_no, ev_id, reg_date) VALUES (?, ?, ?)";
                                stmt = con.prepareStatement(registerQuery);
                                stmt.setInt(1, al_no);
                                stmt.setInt(2, ev_id);
                                stmt.setString(3, reg_date);
            
                                int rowsInserted = stmt.executeUpdate();
                                if (rowsInserted > 0) {
                                    message = "<p style='color: green;'>Event registered successfully!</p>";
                                } else {
                                    message = "<p style='color: red;'>Failed to register. Please try again.</p>";
                                }
                            }
                        } else {
                            message = "<p style='color: red;'>Invalid contact number! No alumni found.</p>";
                        }
                    }
                } catch (Exception e) {
                    message = "<p style='color: red;'>Error: " + e.getMessage() + "</p>";
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (con != null) con.close();
                    } catch (SQLException e) {
                        message += "<p style='color: red;'>Database close error: " + e.getMessage() + "</p>";
                    }
                }
            %>
            
            <div class="message"><%= message %></div>
        </div>
        <footer class="footer">
            &copy; 2025 Alumni Management System | Designed for Professional Use
        </footer>
    </div>
</body>
</html>