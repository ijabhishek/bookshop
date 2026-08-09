<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Order Details"/>
    <jsp:param name="active" value="myorders"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/account.css'/>">

<div class="account-container">
    <c:choose>
        <c:when test="${empty order}">
            <div class="empty-state"><p>Order not found.</p></div>
        </c:when>
        <c:otherwise>
            <h2>🧾 Order #${order.orderNumber}</h2>

            <div class="order-card">
                <div class="order-card-header">
                    <h3>Status</h3>
                    <span class="status-badge status-${order.status.toString().toLowerCase()}">${order.status}</span>
                </div>
                <p class="order-meta">Placed on <fmt:formatDate value="${order.orderDateAsDate}" pattern="dd MMM yyyy, hh:mm a"/></p>

                <c:if test="${not empty order.user}">
                    <p class="order-meta"><strong>Customer:</strong> ${order.user.firstName} (${order.user.userId})</p>
                    <p class="order-meta"><strong>Email:</strong> ${order.user.email} &nbsp;|&nbsp; <strong>Phone:</strong> ${order.user.phoneNumber}</p>
                    <p class="order-meta"><strong>Delivery Address:</strong> ${order.user.address}</p>
                </c:if>
            </div>

            <table class="admin-table">
                <thead>
                    <tr><th>Book</th><th>Qty</th><th>Unit Price (₹)</th><th>Subtotal (₹)</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.orderItems}">
                        <tr>
                            <td>${item.book.title}</td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${item.priceAtPurchase}" type="number" minFractionDigits="2"/></td>
                            <td><fmt:formatNumber value="${item.priceAtPurchase * item.quantity}" type="number" minFractionDigits="2"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <p class="order-meta" style="text-align:right; font-size:16px; margin-top:15px;">
                <strong>Total: ₹<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2"/></strong>
            </p>

            <div class="order-card-actions">
                <a href="<c:url value='/bookstore/order/${order.orderNumber}/invoice'/>" class="btn small primary">⬇ Download Invoice</a>
                <a href="javascript:history.back()" class="btn small secondary">Back</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="includes/footer.jsp"/>
