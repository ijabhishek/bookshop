<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>🔐 Login to Your Book Haven</title>
    <link rel="stylesheet" href="<c:url value='/css/login.css'/>">
</head>
<body>

<div class="login-container">

    <h2>Welcome Back</h2>

    <form action="loginUser" method="post">

        <label>User ID</label>
        <input type="text" name="userId" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit" class="btn">Login</button>

        <div class="forgot">
            <a href="forgotPassword.jsp">Forgot Password?</a>
        </div>

        <div class="register-link">
            New user? 
            <a href="<c:url value='/bookstore/register'/>">Register Here</a>
        </div>

    </form>

</div>

</body>
</html>
