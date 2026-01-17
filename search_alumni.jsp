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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Alumni</title>
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
            <li><a href="search_alumni.jsp" class="active"><i class="fas fa-users"></i> Search Alumni</a></li>
            <li><a href="admin_manage_events.jsp"><i class="fas fa-calendar-check"></i> Manage Events</a></li>
            <li><a href="logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>Search Alumni</header>
        
        <div class="container">
            <h2>Search Alumni</h2>
            <form method="post">
                <input type="text" name="search" placeholder="Search by Name, Qualification, or City">
                <input type="date" name="from_date" placeholder="From Date">
                <input type="date" name="to_date" placeholder="To Date">
                <button type="submit">Search</button>
            </form>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Qualification</th>
                    <th>City</th>
                    <th>Registration Date</th>
                    <th>Action</th>
                </tr>
    
                <%-- Fetching and displaying alumni details --%>
                <%
                    String search = request.getParameter("search");
                    String fromDate = request.getParameter("from_date");
                    String toDate = request.getParameter("to_date");
    
                    if ((search != null && !search.trim().isEmpty()) || (fromDate != null && !fromDate.trim().isEmpty() && toDate != null && !toDate.trim().isEmpty())) { 
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/alumni_management", "root", "root");
    
                            String sql = "SELECT * FROM Alumni WHERE (al_name LIKE ? OR qualification LIKE ? OR city LIKE ?)";
                            
                            if (fromDate != null && !fromDate.trim().isEmpty() && toDate != null && !toDate.trim().isEmpty()) {
                                sql += " AND reg_date BETWEEN ? AND ?";
                            }
    
                            PreparedStatement stmt = con.prepareStatement(sql);
                            stmt.setString(1, "%" + search + "%");
                            stmt.setString(2, "%" + search + "%");
                            stmt.setString(3, "%" + search + "%");
                            
                            int paramIndex = 4;
                            if (fromDate != null && !fromDate.trim().isEmpty() && toDate != null && !toDate.trim().isEmpty()) {
                                stmt.setString(paramIndex++, fromDate);
                                stmt.setString(paramIndex++, toDate);
                            }
    
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                                int id = rs.getInt("al_no");
                                String name = rs.getString("al_name");
                                String qualification = rs.getString("qualification");
                                String city = rs.getString("city");
                                String regDate = rs.getString("reg_date");
                                String email = rs.getString("email");
                                String passYear = rs.getString("pass_year");
                                String address = rs.getString("addr");
                                String contact = rs.getString("contact");
                                String companyName = rs.getString("company_name");
                                String designation = rs.getString("designation");
                                String salary = rs.getString("salary");
                %>
                                <tr>
                                    <td><%= id %></td>
                                    <td><%= name %></td>
                                    <td><%= qualification %></td>
                                    <td><%= city %></td>
                                    <td><%= regDate %></td>
                                    <td>
                                        <button class="view-btn" onclick="viewAlumni('<%= id %>')">View</button>
                                    </td>
                                </tr>
    
                                <!-- Hidden Alumni Details -->
                                <div id="alumni_<%= id %>" style="display: none;">
                                    <p><strong>Name:</strong> <%= name %></p>
                                    <p><strong>Email:</strong> <%= email %></p>
                                    <p><strong>Qualification:</strong> <%= qualification %></p>
                                    <p><strong>Passing Year:</strong> <%= passYear %></p>
                                    <p><strong>Address:</strong> <%= address %></p>
                                    <p><strong>Contact:</strong> <%= contact %></p>
                                    <p><strong>City:</strong> <%= city %></p>
                                    <p><strong>Registration Date:</strong> <%= regDate %></p>
                                    <p><strong>Company Name:</strong> <%= companyName %></p>
                                    <p><strong>Designation:</strong> <%= designation %></p>
                                    <p><strong>Salary:</strong> <%= salary %></p>
                                </div>
                <%
                            }
                            con.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                        }
                    }
                %>
            </table>
        </div>
    <!-- Alumni Detail Modal -->
<div id="alumniModal" class="modal" style="display: none; position: fixed; left: 50%; top: 50%; transform: translate(-50%, -50%); width: 50%; background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2); z-index: 1000;">
    <span class="close-btn" onclick="closeModal()" style="float: right; font-size: 20px; cursor: pointer;">&times;</span>
    <h3 style="margin-bottom: 15px;">Alumni Details</h3>
    <div id="alumniInfo"></div>
    <button onclick="printAlumniInfo()" style="margin-top: 10px; padding: 10px; background: #1e3c72; color: white; border: none; cursor: pointer;">🖨️ Print Info</button>
</div>

<script>
    function viewAlumni(id) {
        var details = document.getElementById("alumni_" + id).innerHTML;
        
        if (!details.trim()) {
            alert("No details found for this alumni.");
            return;
        }

        // Insert details into the modal
        document.getElementById("alumniInfo").innerHTML = details;

        // Show the modal
        document.getElementById("alumniModal").style.display = "block";
    }

   
    function printAlumniInfo() {
        var printContent = document.getElementById("alumniInfo").innerHTML;
        
        var printWindow = window.open('', '', 'width=800,height=600');
        printWindow.document.write('<html><head><title>Alumni Info</title></head><body>');
        printWindow.document.write('<h2>Alumni Information</h2>');
        printWindow.document.write(printContent);
        printWindow.document.write('</body></html>');
        printWindow.document.close();
        printWindow.print();
    }

    function closeModal() {
        document.getElementById("alumniModal").style.display = "none";
    }
</script>

        <footer class="footer">
            &copy; 2025 Alumni Management System. All rights reserved.
        </footer>
    </div>
</body>
</html>
