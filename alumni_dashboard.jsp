<%@ page import="java.sql.*" %>
<%
    // Establish Database Connection
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/alumni_management", "root", "root");
        application.setAttribute("DBConnection", conn);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
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
    <meta name="description" content="Alumni Dashboard | Manage Alumni Activities">
    <meta name="keywords" content="Alumni, Dashboard, Events, Profile">
    <title>Alumni Dashboard | Alumni Management</title>
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
        header {
            background: #2a5298; color: #fff; padding: 15px; text-align: center;
            font-size: 1.8em; font-weight: 600; letter-spacing: 1px;
            border-radius: 10px;
        }
        .section-container {
            display: flex; justify-content: space-between; margin-top: 30px;
        }
        .card {
            width: 48%; background: #fff; padding: 20px; border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1); transition: transform 0.3s;
        }
        .card:hover { transform: translateY(-5px); }
        .card h3 { color: #1e3c72; margin-bottom: 10px; }
        .card p { color: #555; line-height: 1.6; }
        .action-buttons {
            display: flex; gap: 10px; margin-top: 15px;
        }
        .btn {
            display: inline-block; padding: 10px 15px; border: none; border-radius: 5px;
            cursor: pointer; font-size: 14px; text-decoration: none;
        }
        .btn-primary { background: #1e3c72; color: #fff; }
        .btn-secondary { background: #fdbb2d; color: #1e3c72; }
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
            <li><a href="alumni_dashboard.jsp" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="view_alumni.jsp"><i class="fas fa-users"></i> View Alumni</a></li>
            <li><a href="register_event.jsp"><i class="fas fa-calendar-alt"></i> Register for Events</a></li>
            <li><a href="schedule_lecture.jsp"><i class="fas fa-chalkboard-teacher"></i> Schedule a Lecture</a></li>
            <li><a href="edit_profile.jsp"><i class="fas fa-user-edit"></i> Edit Profile</a></li>
            <li><a href="alumni_feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>Welcome to the Alumni Dashboard</header>

        <div class="section-container">
            <div class="card">
                <h3 class="fas fa-calendar-alt"> Upcoming Events</h3>
                <p>Stay connected with alumni by attending exciting events organized by the alumni community.</p>
                <div class="action-buttons">
                    <a href="register_event.jsp" class="btn btn-secondary">Register Now</a>
                </div>
            </div>

            <div class="card">
                <h3 class="fas fa-chalkboard-teacher"> Schedule a Lecture</h3>
                <p>Share your knowledge and experience with students by scheduling a guest lecture at your university.</p>
                <div class="action-buttons">
                    <a href="schedule_lecture.jsp" class="btn btn-primary">Schedule Now</a>
                </div>
            </div>
        </div>

        <div class="section-container">
            <div class="card">
                <h3 class="fas fa-users"> Connect with Alumni</h3>
                <p>Find and reconnect with your batchmates and alumni network across different professions.</p>
                <div class="action-buttons">
                    <a href="view_alumni.jsp" class="btn btn-primary">View Alumni</a>
                </div>
            </div>

            <div class="card">
                <h3 class="fas fa-user-edit"> Manage Your Profile</h3>
                <p>Update your profile to keep your alumni details and professional information up-to-date.</p>
                <div class="action-buttons">
                    <a href="edit_profile.jsp" class="btn btn-secondary">Edit Profile</a>
                </div>
            </div>
        </div>

        <footer class="footer">
            &copy; 2025 Alumni Management System | Designed for Professional Use
        </footer>
    </div>

</body>
</html>
