<%@ page import="java.sql.*, java.io.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login & Register</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
    body {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    padding: 0;
    background: linear-gradient(135deg, #0052D4, #65C7F7);
    color: #333;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.container {
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(5px);
    padding: 2rem;
    border-radius: 15px;
    text-align: center;
    width: 100%;
    max-width: 400px;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
}

input, select {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    border-radius: 8px;
    border: 1px solid #ccc;
    outline: none;
    background: #f0f0f0;
    color: #333;
    font-size: 1rem;
}

input[type="submit"] {
    background: #004AAD;
    color: #fff;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

input[type="submit"]:hover {
    background: #002D72;
}

.error-message {
    color: red;
    font-size: 1rem;
    margin-bottom: 1rem;
}

.success-message {
    color: green;
    font-size: 1rem;
    margin-bottom: 1rem;
}

.toggle-link {
    color: #004AAD;
    cursor: pointer;
    text-decoration: underline;
    font-weight: bold;
}

#register-form {
    display: none;
}

    </style>
    <script>
        function showRegisterForm() {
            document.getElementById("login-form").style.display = "none";
            document.getElementById("register-form").style.display = "block";
        }
        function showLoginForm() {
            document.getElementById("register-form").style.display = "none";
            document.getElementById("login-form").style.display = "block";
        }
    </script>
</head>
<body>
    <div class="container">
        <% 
            HttpSession sessionObj = request.getSession();
            String successMessage = (String) sessionObj.getAttribute("successMessage");
            String errorMessage = (String) sessionObj.getAttribute("errorMessage");

            if (successMessage != null) {
        %>
            <p class="success-message"><%= successMessage %></p>
        <%
                sessionObj.removeAttribute("successMessage");
            }
            if (errorMessage != null) {
        %>
            <p class="error-message"><%= errorMessage %></p>
        <%
                sessionObj.removeAttribute("errorMessage");
            }
        %>

        <!-- Login Form -->
        <div id="login-form">
            <h1>Login</h1>
            <form action="Login.jsp" method="post">
                <select name="user_type" required>
                    <option value="alumni">Alumni</option>
                    <option value="admin">Admin</option>
                </select>
                <input type="text" name="username" placeholder="Enter your email" required>
                <input type="password" name="password" placeholder="Enter your password" required>
                <input type="submit" name="login" value="Login">
            </form>
            <p>New User? <span class="toggle-link" onclick="showRegisterForm()">Register here</span></p>
        </div>

        <!-- Register Form -->
        <div id="register-form">
            <h1>Register</h1>
            <form action="Login.jsp" method="post">
                <input type="text" name="name" placeholder="Full Name" required>
                <input type="email" name="email" placeholder="Email Address" required>
                <input type="text" name="qualification" placeholder="Qualification" required>
                <input type="number" name="pass_year" placeholder="Passing Year" required>
                <input type="text" name="address" placeholder="Address" required>
                <input type="text" name="contact" placeholder="Contact Number (Used as Password)" required>
                <input type="submit" name="register" value="Register">
            </form>
            <p>Already registered? <span class="toggle-link" onclick="showLoginForm()">Login here</span></p>
        </div>
    </div>
</body>
</html>

<%

    final String DB_URL = "jdbc:mysql://localhost:3306/alumni_management";
    final String DB_USER = "root";
    final String DB_PASSWORD = "root";

    String loginAction = request.getParameter("login");
    String registerAction = request.getParameter("register");

    if (loginAction != null) {
        String userType = request.getParameter("user_type").trim();
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String query;
            
            if (userType.equals("admin")) {
                query = "SELECT * FROM Admin WHERE email = ? AND password = ?";
            } else {
                query = "SELECT * FROM Alumni WHERE email = ? AND contact = ?";
            }
            
            try (PreparedStatement pst = con.prepareStatement(query)) {
                pst.setString(1, username);
                pst.setString(2, password);
                
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        sessionObj.setAttribute("username", username);
                        response.sendRedirect(userType.equals("admin") ? "admin_dashboard.jsp" : "alumni_dashboard.jsp");
                    } else {
                        sessionObj.setAttribute("errorMessage", "Invalid username or password.");
                        response.sendRedirect("Login.jsp");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            sessionObj.setAttribute("errorMessage", "Database connection error.");
            response.sendRedirect("Login.jsp");
        }
    }

    if (registerAction != null) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String qualification = request.getParameter("qualification");
        int passYear = Integer.parseInt(request.getParameter("pass_year"));
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String insertQuery = "INSERT INTO Alumni (al_name, email, qualification, pass_year, addr, contact) VALUES (?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement insertStmt = con.prepareStatement(insertQuery)) {
                insertStmt.setString(1, name);
                insertStmt.setString(2, email);
                insertStmt.setString(3, qualification);
                insertStmt.setInt(4, passYear);
                insertStmt.setString(5, address);
                insertStmt.setString(6, contact);
                insertStmt.executeUpdate();
                
                sessionObj.setAttribute("successMessage", "Registration successful! Please login.");
                response.sendRedirect("Login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sessionObj.setAttribute("errorMessage", "Registration failed.");
            response.sendRedirect("Login.jsp");
        }
    }
%>
