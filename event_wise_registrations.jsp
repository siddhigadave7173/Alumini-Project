<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
    <title>Event-wise Alumni Registration Report</title>
    <style>
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid black;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .btn-container {
            text-align: center;
            margin-top: 20px;
        }
        .btn {
            padding: 10px 15px;
            background: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin: 5px;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div id="printSection">
        <h2 align="center">Event-wise Alumni Registration Report</h2>
        <p align="center"><strong>Date & Time:</strong> <span id="currentDateTime"></span></p>

        <table id="reportTable">
            <tr>
                <th>Alumni ID</th>
                <th>Alumni Name</th>
                <th>Email</th>
                <th>Registered Events</th>
                <th>Registration Date</th>
            </tr>

            <%
                // Database connection details
                String url = "jdbc:mysql://localhost:3306/alumni_management";
                String user = "root";
                String password = "root";

                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // Load MySQL JDBC Driver
                    Class.forName("com.mysql.cj.jdbc.Driver");

                    // Establish connection
                    conn = DriverManager.getConnection(url, user, password);

                    // Query to fetch alumni with all their registered events grouped
                    String query = "SELECT a.al_no, a.al_name, a.email, " +
                                   "GROUP_CONCAT(e.ev_title ORDER BY e.ev_title SEPARATOR ', ') AS events, " +
                                   "MIN(ae.reg_date) AS reg_date " +
                                   "FROM al_ev ae " +
                                   "JOIN alumni a ON ae.al_no = a.al_no " +
                                   "JOIN event e ON ae.ev_id = e.ev_id " +
                                   "GROUP BY a.al_no, a.al_name, a.email " +
                                   "ORDER BY reg_date ASC";

                    pstmt = conn.prepareStatement(query);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("al_no") %></td>
                <td><%= rs.getString("al_name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("events") %></td>
                <td><%= rs.getDate("reg_date") %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' style='color:red; text-align:center;'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            %>  
        </table>
    </div>

    <div class="btn-container">
        <button onclick="printReport()" class="btn"> Print Report</button>
    </div>

    <script>
        // Function to display current date and time
        function updateDateTime() {
            var now = new Date();
            var dateTimeString = now.toLocaleString();
            document.getElementById("currentDateTime").textContent = dateTimeString;
        }

        // Call function on page load
        updateDateTime();

        // Print function for the report
        function printReport() {
            var printContent = document.getElementById("printSection").innerHTML;
            var printWindow = window.open('', '', 'width=800,height=600');

            printWindow.document.write('<html><head><title>Event-wise Alumni Registration Report</title>');
            // Add styles to ensure table borders are printed
            printWindow.document.write('<style>');
            printWindow.document.write('body { font-family: Arial, sans-serif; text-align: center; }');
            printWindow.document.write('table { width: 80%; border-collapse: collapse; margin: 20px auto; }');
            printWindow.document.write('th, td { border: 1px solid black; padding: 10px; text-align: left; }');
            printWindow.document.write('th { background-color: #f2f2f2; }');
            printWindow.document.write('</style></head><body>');

            printWindow.document.write(printContent); // Print the entire section

            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }
    </script>
</body>

</html>
