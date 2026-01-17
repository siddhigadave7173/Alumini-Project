<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.sql.*, java.util.Date" %>
<%
    HttpSession sessionObj = request.getSession(false); // Get existing session without creating a new one

    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Redirect to login page if session does not exist
        return; // Stop further execution
    }
%>

<%
    String dbURL = "jdbc:mysql://localhost:3306/alumni_management";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement getAlumniStmt = null;
    ResultSet rs = null;
    ResultSet alumniRs = null;
    String message = "";
    String latestStatus = "Not Requested"; // Default status
    boolean hideForm = false;
    
    String email = request.getParameter("email");

    // Retrieve stored status from session
    String storedMessage = (String) session.getAttribute("lecture_status_message");
    Long storedTimestamp = (Long) session.getAttribute("lecture_status_time");


    if (request.getMethod().equalsIgnoreCase("POST") && !hideForm) {
        String selectedDate = request.getParameter("available_date");
        String customDate = request.getParameter("custom_date");
        String lectureTopic = request.getParameter("lecture_topic");
        int alumniId = -1;

        try {
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String getAlumniQuery = "SELECT al_no FROM alumni WHERE email = ?";
            getAlumniStmt = conn.prepareStatement(getAlumniQuery);
            getAlumniStmt.setString(1, email);
            alumniRs = getAlumniStmt.executeQuery();

            if (alumniRs.next()) {
                alumniId = alumniRs.getInt("al_no");
                String insertQuery = "INSERT INTO lecture_schedule (alumni_id, email, topic, selected_date, status) VALUES (?, ?, ?, ?, 'Pending')";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setInt(1, alumniId);
                pstmt.setString(2, email);
                pstmt.setString(3, lectureTopic);
                pstmt.setString(4, (selectedDate != null && !selectedDate.isEmpty()) ? selectedDate : customDate);                
                int result = pstmt.executeUpdate();

                if (result > 0) {
                    hideForm = true;
                    message = "<p style='color: green;'>Request sent successfully! Your lecture is pending approval.</p>";

                    // Store the request message in session with timestamp
                    session.setAttribute("lecture_status_message", message);
                    session.setAttribute("lecture_status_time", new Date().getTime());
                } else {
                    message = "<p style='color: red;'>Error submitting request. Please try again.</p>";
                }
            } else {
                message = "<p style='color: red;'>Invalid Email. No alumni found.</p>";
            }
        } catch (Exception e) {
            message = "<p style='color: red;'>Database error: " + e.getMessage() + "</p>";
            e.printStackTrace();
        } finally {
            try {
                if (alumniRs != null) alumniRs.close();
                if (getAlumniStmt != null) getAlumniStmt.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule a Lecture | Alumni Management</title>
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
        .menu a i { margin-right: 12px; }
        .menu a:hover, .menu a.active { background: #fdbb2d; color: #1e3c72; }
        .main-content {
            margin-left: 260px; padding: 30px; flex-grow: 1; display: flex; flex-direction: column;
        }
        .main-content { margin-left: 260px; padding: 30px; flex-grow: 1; }
        header { background: #2a5298; color: #fff; padding: 15px; text-align: center;
            font-size: 1.8em; font-weight: 600; border-radius: 10px; }
                    .container { 
            background: white; 
            padding: 30px; 
            margin: 50px auto; 
            width: 40%; 
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2); 
            text-align: center;
        }

        .container h2 {
            margin-bottom: 20px;
            color: #1e3c72;
        }

        .container form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .container input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            outline: none;
        }

        .container input:focus {
            border-color: #1e3c72;
            box-shadow: 0 0 5px rgba(30, 60, 114, 0.5);
        }

        .container button {
            padding: 12px;
            background: #1e3c72;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            transition: 0.3s;
        }

        .container button:hover {
            background: #2a5298;
        }

        button { background: #1e3c72; color: white; border: none; cursor: pointer; border-radius: 5px; }
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
            <li><a href="view_alumni.jsp" class="active"><i class="fas fa-users"></i> View Alumni</a></li>
            <li><a href="register_event.jsp"><i class="fas fa-calendar-check"></i> Register for Events</a></li>
            <li><a href="schedule_lecture.jsp"><i class="fas fa-chalkboard-teacher"></i> Schedule a Lecture</a></li>
            <li><a href="edit_profile.jsp"><i class="fas fa-user-edit"></i> Edit Profile</a></li>
            <li><a href="alumni_feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    <div class="main-content">
        <header>Schedule a Lecture</header>
        <div class="container">
            <h2>Request a Lecture Session</h2>
            <%= message %>
            <% if (!hideForm) { %>
            <form method="POST" action="schedule_lecture.jsp">
                <input type="email" name="email" required placeholder="Enter your email">
                <input type="date" name="custom_date">
                <input type="text" name="lecture_topic" required placeholder="Enter lecture topic">
                <button type="submit">Submit Request</button>
            </form>
            <% } %>
        </div>
        <footer class="footer">
            &copy; 2025 Alumni Management System | Designed for Professional Use
        </footer>
    </div>
</body>
</html>
