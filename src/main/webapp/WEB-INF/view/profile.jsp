<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="My Profile"/>
    <jsp:param name="active" value="profile"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/account.css'/>">

<div class="account-container">
    <h2>👤 My Profile</h2>

    <c:if test="${not empty message}">
        <div class="flash-message">${message}</div>
    </c:if>

    <form action="<c:url value='/bookstore/profile/update'/>" method="post" class="profile-form">
        <div class="form-group">
            <label>User ID</label>
            <input type="text" value="${user.userId}" readonly>
        </div>
        <div class="form-group">
            <label>Role</label>
            <input type="text" value="${user.role}" readonly>
        </div>
        <div class="form-group">
            <label for="firstName">Name</label>
            <input type="text" id="firstName" name="firstName" value="${user.firstName}" required>
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="${user.email}" required>
        </div>
        <div class="form-group">
            <label for="phoneNumber">Phone Number</label>
            <input type="text" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" required>
        </div>
        <div class="form-group">
            <label for="address">Address</label>
            <textarea id="address" name="address" rows="3" required>${user.address}</textarea>
        </div>

        <button type="submit" class="btn primary">Save Changes</button>
        <a href="<c:url value='/bookstore/myorders'/>" class="btn secondary">View My Orders</a>
    </form>
</div>

<jsp:include page="includes/footer.jsp"/>
