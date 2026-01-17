<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.mail.*, javax.mail.internet.*, java.util.Properties" %>
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

    Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    if (request.getParameter("approve") != null || request.getParameter("reject") != null) {
        int lec_id = Integer.parseInt(request.getParameter("lec_id"));
        String status = request.getParameter("approve") != null ? "Approved" : "Rejected";

        // Fetch email of the alumni
        String emailQuery = "SELECT a.email FROM lecture_schedule l JOIN alumni a ON l.alumni_id = a.al_no WHERE l.lec_id = ?";
        pstmt = conn.prepareStatement(emailQuery);
        pstmt.setInt(1, lec_id);
        rs = pstmt.executeQuery();

        String alumniEmail = "";
        if (rs.next()) {
            alumniEmail = rs.getString("email");
        }

        // Update lecture status
        String updateQuery = "UPDATE lecture_schedule SET status = ? WHERE lec_id = ?";
        pstmt = conn.prepareStatement(updateQuery);
        pstmt.setString(1, status);
        pstmt.setInt(2, lec_id);
        pstmt.executeUpdate();

        // Send Email Notification
        if (!alumniEmail.isEmpty()) {
            final String senderEmail = "abc@gmail.com"; // Replace with your email
            final String senderPassword = "yourkey-xzkdshshkahskjk"; // Replace with your email password

            Properties properties = new Properties();
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.host", "smtp.gmail.com");
            properties.put("mail.smtp.port", "587");

            Session mailSession = Session.getInstance(properties, new Authenticator() {  // ✅ Renamed session variable
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            try {
                Message message = new MimeMessage(mailSession);
                message.setFrom(new InternetAddress(senderEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(alumniEmail));
                message.setSubject("Lecture Request Status Update");
                message.setText("Dear Alumni,\n\nYour lecture request has been " + status + ".\n\nRegards,\nAdmin Team");

                Transport.send(message);
                System.out.println("Email Sent Successfully!");
            } catch (MessagingException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("manage_lectures.jsp");
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Lecture Requests</title>
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
        <h2>Admin Panel</h2>
        <ul class="menu">
            <li><a href="admin_dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="manage_lectures.jsp" class="active"><i class="fas fa-chalkboard-teacher"></i> Manage Lectures</a></li>
            <li><a href="admin_manage_events.jsp"><i class="fas fa-calendar"></i> Manage Events</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>Manage Lecture Requests</header>
        <div class="container">
            <h2>Lecture Requests</h2>
            <table>
                <tr>
                    <th>Lecture Topic</th>
                    <th>Requested Date</th>
                    <th>Alumni ID</th>
                    <th>Alumni Email</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                <%
                        String selectQuery = "SELECT l.topic, l.selected_date, l.alumni_id, l.status, l.lec_id, a.email " +
                        "FROM lecture_schedule l " +
                        "JOIN alumni a ON l.alumni_id = a.al_no " +
                        "WHERE l.status = 'Pending'";

                    pstmt = conn.prepareStatement(selectQuery);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("topic") %></td>
                    <td><%= rs.getString("selected_date") %></td>
                    <td><%= rs.getInt("alumni_id") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("status") %></td>
                    <td>
                        <form method="POST">
                            <input type="hidden" name="lec_id" value="<%= rs.getInt("lec_id") %>">
                            <button type="submit" name="approve">Approve</button>
                            <button type="submit" name="reject">Reject</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>

        <footer class="footer">
            &copy; 2025 Alumni Management System | Designed for Professional Use
        </footer>
    </div>
</body>
</html>
