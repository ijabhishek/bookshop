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

    <c:if test="${param.error == 'true'}">
        <div class="login-error">Incorrect User ID or Password.</div>
    </c:if>
    <c:if test="${param.logout == 'true'}">
        <div class="login-success">You have been logged out successfully.</div>
    </c:if>

    <form action="<c:url value='/bookstore/loginUser'/>" method="post">
        <label>User ID</label>
        <input type="text" name="userId" required autocomplete="username">

        <label>Password</label>
        <input type="password" name="password" required autocomplete="current-password">


        <button type="submit" class="btn">Login</button>

        <div class="forgot"><a href="forgotPassword.jsp">Forgot Password?</a></div>
        <div class="register-link">New user? <a href="<c:url value='/bookstore/register'/>">Register Here</a></div>
    </form>
</div>
</body>
</html>
