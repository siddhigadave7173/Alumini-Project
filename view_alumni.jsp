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
    <meta name="description" content="View Alumni - Alumni Management System">
    <title>View Alumni | Alumni Management</title>
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
        .container {
            background: #fff; color: #000; padding: 30px; border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1); max-width: 90%; margin: auto;
        }
        table {
            width: 100%; border-collapse: collapse; margin-top: 20px;
        }
        th, td {
            padding: 12px; border: 1px solid #ccc; text-align: center;
        }
        th {
            background: #6a11cb; color: white;
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
            <li><a href="view_alumni.jsp" class="active"><i class="fas fa-users"></i> View Alumni</a></li>
            <li><a href="register_event.jsp"><i class="fas fa-calendar-check"></i> Register for Events</a></li>
            <li><a href="edit_profile.jsp"><i class="fas fa-user-edit"></i> Edit Profile</a></li>
            <li><a href="schedule_lecture.jsp"><i class="fas fa-chalkboard-teacher"></i> Schedule a Lecture</a></li>
            <li><a href="alumni_feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>View Alumni</header>

        <div class="container">
            <h2>Alumni List</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Qualification</th>
                    <th>City</th>
                    <th>Email</th>
                </tr>
                <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/alumni_management", "root", "root");
                    String sql = "SELECT * FROM Alumni ORDER BY al_no";
                    PreparedStatement stmt = con.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();
                    boolean hasResults = false;
                    while (rs.next()) {
                        hasResults = true;
                %>
                        <tr>
                            <td><%= rs.getInt("al_no") %></td>
                            <td><%= rs.getString("al_name") %></td>
                            <td><%= rs.getString("qualification") %></td>
                            <td><%= rs.getString("city") %></td>
                            <td><%= rs.getString("email") %></td>
                        </tr>
                <%
                    }
                    if (!hasResults) {
                        out.println("<tr><td colspan='4' style='text-align:center;'>No alumni found.</td></tr>");
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                }
                %>
            </table>
        </div>

        <footer class="footer">
            &copy; 2025 Alumni Management System | Designed for Professional Use
        </footer>
    </div>

</body>
</html>
