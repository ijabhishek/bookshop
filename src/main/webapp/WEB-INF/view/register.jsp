<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>📚 Create Your BookStore Account</title>
    <link rel="stylesheet" href="<c:url value='/css/register.css'/>">
</head>
<body>

<div class="container">
    <h2>Create Your Account</h2>

    <form action="registerUser" method="post">

        <label>User ID</label>
        <input type="text" name="userId" required>

        <label>First Name</label>
        <input type="text" name="firstName" required>

        <label>Email</label>
        <input type="email" name="email" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <label>Phone Number</label>
        <input type="text" name="phoneNumber" required>

        <label>Address</label>
        <textarea name="address" required></textarea>

        <button type="submit" class="btn">Register</button>

        <div class="login-link">
            Already have an account? <a href="login.jsp">Login</a>
        </div>

    </form>
</div>


</body>
</html>
