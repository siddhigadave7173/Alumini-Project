<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
    <title>Event Attendance Report</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        table { width: 80%; border-collapse: collapse; margin: 20px auto; }
        th, td { border: 1px solid black; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .btn-container { text-align: center; margin-top: 20px; }
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
        <h2 align="center">Event Attendance Report</h2>
        <p align="center"><strong>Date & Time:</strong> <span id="currentDateTime"></span></p>

        <table>
            <tr>
                <th>Event ID</th>
                <th>Event Title</th>
                <th>Event Date</th>
                <th>Total Alumni Registered</th>
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

                    // Query to get event attendance details
                    String query = "SELECT e.ev_id, e.ev_title, e.date, " +
                                   "COUNT(ae.al_no) AS total_registered " +
                                   "FROM event e " +
                                   "LEFT JOIN al_ev ae ON e.ev_id = ae.ev_id " +
                                   "GROUP BY e.ev_id, e.ev_title, e.date " +
                                   "ORDER BY e.date DESC";

                    pstmt = conn.prepareStatement(query);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("ev_id") %></td>
                <td><%= rs.getString("ev_title") %></td>
                <td><%= rs.getDate("date") %></td>
                <td><%= rs.getInt("total_registered") %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='4' style='color:red; text-align:center;'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            %>  
        </table>
    </div>

    <div class="btn-container">
        <button onclick="printReport()" class="btn">Print Report</button>
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

        // Print function
        function printReport() {
            var printContent = document.getElementById("printSection").innerHTML;
            var printWindow = window.open('', '', 'width=800,height=600');

            printWindow.document.write('<html><head><title>Event Attendance Report</title>');
            // Ensure table borders are printed properly
            printWindow.document.write('<style>');
            printWindow.document.write('body { font-family: Arial, sans-serif; text-align: center; }');
            printWindow.document.write('table { width: 80%; border-collapse: collapse; margin: 20px auto; }');
            printWindow.document.write('th, td { border: 1px solid black; padding: 10px; text-align: left; }');
            printWindow.document.write('th { background-color: #f2f2f2; }');
            printWindow.document.write('</style></head><body>');

            printWindow.document.write(printContent); // Print the report content

            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }
    </script>

</body>
</html>
