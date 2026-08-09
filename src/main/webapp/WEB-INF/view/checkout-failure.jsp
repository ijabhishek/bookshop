<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Checkout Failed"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/account.css'/>">

<div class="account-container" style="text-align:center;">
    <h2>⚠️ We couldn't place your order</h2>
    <p class="order-meta">${error}</p>

    <div class="order-card-actions" style="justify-content:center;">
        <a href="<c:url value='/bookstore/mycart'/>" class="btn primary">Back to Cart</a>
        <a href="<c:url value='/bookstore/home'/>" class="btn secondary">Continue Shopping</a>
    </div>
</div>

<jsp:include page="includes/footer.jsp"/>
