<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="<c:url value='/css/order-success.css'/>">
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Order Success"/>
    <jsp:param name="active" value="myorders"/>
</jsp:include>

<div class="success-container">
    <div class="success-card">
        <div class="success-icon">🎉</div>
        <h1>Your Order Has Been Placed!</h1>
        <p class="message">Thank you for shopping with <strong>BookShop</strong>.</p>
        
        <div class="order-details">
            <p><strong>Order Number:</strong> ${order.orderNumber}</p>
            <p><strong>Order Date:</strong> 
                <fmt:formatDate value="${order.orderDateAsDate}" pattern="dd MMM yyyy, HH:mm"/>
            </p>
            <p><strong>Total Amount:</strong> ₹<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2"/></p>
        </div>

       

        <div class="actions">
            <a href="<c:url value='/bookstore/home'/>" class="btn primary">Continue Shopping</a>
            <a href="<c:url value='/bookstore/myorders'/>" class="btn secondary">View My Orders</a>
            <a href="<c:url value='/bookstore/order/${order.orderNumber}/invoice'/>" class="btn secondary">⬇ Download Invoice</a>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp"/>
