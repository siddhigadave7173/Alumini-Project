<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession sessionObj = request.getSession(false); // Get existing session without creating a new one

    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp"); // Redirect to login page if session does not exist
        return; // Stop further execution
    }
%>

<%
    // Database connection details
    String dbURL = "jdbc:mysql://localhost:3306/alumni_management";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String contact = request.getParameter("contact");
    String al_name = "", email = "", addr = "", city = "", company = "", designation = "", salary = "";
    boolean showForm = false;
    
    if (contact != null && !contact.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            
            String query = "SELECT * FROM Alumni WHERE contact = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, contact);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                al_name = rs.getString("al_name");
                email = rs.getString("email");
                addr = rs.getString("addr");
                city = rs.getString("city");
                company = rs.getString("company_name");
                designation = rs.getString("designation");
                salary = rs.getString("salary");
                showForm = true;
            } else {
                out.println("<script>alert('Contact not found!'); window.location='edit_profile.jsp';</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
    
    if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("update") != null) {
        String new_name = request.getParameter("al_name");
        String new_email = request.getParameter("email");
        String new_addr = request.getParameter("addr");
        String new_city = request.getParameter("city");
        String new_company = request.getParameter("company");
        String new_designation = request.getParameter("designation");
        String new_salary = request.getParameter("salary");
        String new_contact = request.getParameter("new_contact");

        try {
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String updateQuery = "UPDATE Alumni SET al_name=?, email=?, addr=?, city=?, company_name=?, designation=?, salary=?, contact=? WHERE contact=?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, new_name);
            pstmt.setString(2, new_email);
            pstmt.setString(3, new_addr);
            pstmt.setString(4, new_city);
            pstmt.setString(5, new_company);
            pstmt.setString(6, new_designation);
            pstmt.setString(7, new_salary);
            pstmt.setString(8, new_contact);
            pstmt.setString(9, contact);

            int updated = pstmt.executeUpdate();
            if (updated > 0) {
                out.println("<script>alert('Profile updated successfully!'); window.location='edit_profile.jsp';</script>");
            } else {
                out.println("<script>alert('Update failed. Try again.');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error updating profile.');</script>");
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Edit Profile - Alumni Management System">
    <title>Edit Profile | Alumni Management</title>
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
        label, input, button {
            display: block; width: 100%; padding: 10px; margin: 10px 0;
        }
        button {
            background: #1e3c72; color: white; border: none; cursor: pointer; border-radius: 5px;
        }
        button:hover { background: #0056b3; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Alumni Panel</h2>
        <ul class="menu">
            <li><a href="alumni_dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="view_alumni.jsp"><i class="fas fa-users"></i> View Alumni</a></li>
            <li><a href="register_event.jsp"><i class="fas fa-calendar-alt"></i> Register for Events</a></li>
            <li><a href="schedule_lecture.jsp"><i class="fas fa-chalkboard-teacher"></i> Schedule a Lecture</a></li>
            <li><a href="edit_profile.jsp" class="active"><i class="fas fa-user-edit"></i> Edit Profile</a></li>
            <li><a href="alumni_feedback.jsp"><i class="fas fa-comments"></i> Feedback</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    <div class="main-content">
        <header>Edit Profile</header>
        <div class="container">
            <% if (!showForm) { %>
                <form method="GET">
                    <label>Enter Contact Number:</label><br>
                    <input type="text" name="contact" required pattern="\d{10}" placeholder="Enter 10-digit contact"><br>
                    <button type="submit">Fetch Profile</button>
                </form>
            <% } else { %>
                <form method="POST">
                    <input type="hidden" name="contact" value="<%= contact %>">
                    <label>Name:</label>
                    <input type="text" name="al_name" value="<%= al_name %>" required><br>
                    <label>Email:</label>
                    <input type="email" name="email" value="<%= email %>" required><br>
                    <label>Address:</label>
                    <input type="text" name="addr" value="<%= addr %>"><br>
                    <label>City:</label>
                    <input type="text" name="city" value="<%= city %>"><br>
                    <label>Company Name:</label>
                    <input type="text" name="company" value="<%= company %>"><br>
                    <label>Designation:</label>
                    <input type="text" name="designation" value="<%= designation %>"><br>
                    <label>Salary:</label>
                    <input type="text" name="salary" value="<%= salary %>"><br>
                    <label>New Contact Number:</label>
                    <input type="text" name="new_contact" value="<%= contact %>" required pattern="\d{10}"><br>
                    <button type="submit" name="update">Update Profile</button>
                </form>
            <% } %>
        </div>
    </div>
</body>
</html>
