<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Generate Reports</title>
    <script>
        function redirectToReport() {
            var selectedReport = document.getElementById("reportType").value;
            if (selectedReport) {
                window.location.href = selectedReport;
            }
        }
    </script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 20px;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 500px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: auto;
            text-align: center;
        }
        h2 {
            color: #333;
        }
        select, button {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #007bff;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border: none;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Generate Reports</h2>
        <label for="reportType">Select Report Type:</label>
        <select id="reportType">
            <option value="">-- Select Report --</option>
            <option value="event_attendence_report.jsp"> Event-wise Attendence Report</option>
            <option value="event_wise_registrations.jsp">Event-wise Alumni Registration Report</option>
        </select>
        <button onclick="redirectToReport()">Generate Report</button>
    </div>
</body>
</html>
