<%@ page import="java.sql.*" %>
<% 
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/alumni_management", "root", "root");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!-- <%
    HttpSession sessionObj = request.getSession(false); // Get existing session without creating a new one

    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Redirect to login page if session does not exist
        return; // Stop further execution
    }
%> -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Admin Dashboard | Manage Alumni, Events, and Registrations">
    <meta name="keywords" content="Alumni, Admin Dashboard, Events Management">
    <title>Admin Dashboard | Alumni Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { display: flex; background: #f4f6f9; }
        .sidebar {
            width: 250px; height: 100vh; background: #1e3c72; color: #fff; padding: 20px;
            position: fixed; left: 0; top: 0; display: flex; flex-direction: column;
        }
        .sidebar h2 { text-align: center; margin-bottom: 20px; }
        .menu { list-style: none; padding: 0; }
        .menu li { margin: 15px 0; }
        .menu a {
            display: block; padding: 10px; text-decoration: none; color: #fff;
            border-radius: 5px; transition: 0.3s;
        }
        .menu a:hover, .menu a.active { background: #fdbb2d; color: #1e3c72; }
        .main-content {
            margin-left: 250px; padding: 20px; flex-grow: 1;
        }
        header {
            background: #2a5298; color: #fff; padding: 15px; text-align: center;
            font-size: 1.8em; font-weight: 600; letter-spacing: 1px;
        }
        .dashboard-info {
            display: flex; justify-content: space-around; margin: 20px 0;
        }
        .info-box {
            background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center; width: 300px;
        }
        .info-box h3 { margin: 10px 0; color: #1e3c72; }
        .info-box p { font-size: 1.1em; color: #333; }
        .content-area {
            background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-top: 20px;
        }
        .footer {
            text-align: center; padding: 20px; background: #1e3c72; color: #fff;
            position: absolute; bottom: 0; width: 100%;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <ul class="menu">
            <li><a href="admin_dashboard.jsp" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="admin_manage_events.jsp"><i class="fas fa-calendar-alt"></i> Manage Events</a></li>
            <li><a href="search_alumni.jsp"><i class="fas fa-search"></i> Search Alumni</a></li>
            <li><a href="manage_lectures.jsp"><i class="fas fa-chalkboard-teacher"></i> Manage Lectures</a></li>
            <li><a href="alumni_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li><a href="admin_feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    <div class="main-content">
        <header>Admin Dashboard</header>
        <div class="dashboard-info">
            <div class="info-box">
                <h3>Welcome, Admin!</h3>
                <p>Manage alumni, events, and registrations efficiently.</p>
            </div>
            <div class="info-box">
                <h3>System Overview</h3>
                <p>Keep track of alumni engagement and upcoming events.</p>
            </div>
            <div class="info-box">
                <h3>Quick Actions</h3>
                <p><a href="admin_manage_events.jsp" style="text-decoration: none; color: #1e3c72; font-weight: bold;">- Manage Events</a></p>
                <p><a href="search_alumni.jsp" style="text-decoration: none; color: #1e3c72; font-weight: bold;" >- Search Alumni</a></p>
                <p><a href="alumni_report.jsp" style="text-decoration: none; color: #1e3c72; font-weight: bold;">- Generate Reports</a></p>
            </div>
        </div>
        <div class="content-area">
            <h2>Latest Updates</h2>
            <p>Stay informed about recent activities and announcements in the alumni network.</p>
            <ul>
                <li>New alumni registrations this month.</li>
                <li>Upcoming alumni meet-ups and events.</li>
                <li>System updates and feature enhancements.</li>
            </ul>
        </div>
        <footer class="footer">
            &copy; 2025 Alumni Management System | Designed for Professional Use
        </footer>
    </div>
</body>
</html>
