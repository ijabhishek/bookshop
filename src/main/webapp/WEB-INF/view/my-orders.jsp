<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="My Orders"/>
    <jsp:param name="active" value="myorders"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/account.css'/>">

<div class="account-container">
    <h2>📦 My Orders</h2><c:if test="${not empty message}"><div class="flash-message">${message}</div></c:if><c:if test="${not empty error}"><div class="flash-message error">${error}</div></c:if>

    <c:if test="${empty orders}">
        <div class="empty-state">
            <p>You haven't placed any orders yet.</p>
            <a href="<c:url value='/bookstore/home'/>" class="btn primary">Start Shopping</a>
        </div>
    </c:if>

    <c:forEach var="order" items="${orders}">
        <div class="order-card">
            <div class="order-card-header">
                <h3>Order #${order.orderNumber}</h3>
                <span class="status-badge status-${order.status.toString().toLowerCase()}">${order.status}</span>
            </div>
            <p class="order-meta">
                Placed on <fmt:formatDate value="${order.orderDateAsDate}" pattern="dd MMM yyyy, hh:mm a"/>
                &nbsp;|&nbsp; Total: ₹<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2"/>
            </p>

            <ul class="order-items-list">
                <c:forEach var="item" items="${order.orderItems}">
                    <li>${item.book.title} &times; ${item.quantity} &mdash; ₹<fmt:formatNumber value="${item.priceAtPurchase}" type="number" minFractionDigits="2"/> each</li>
                </c:forEach>
            </ul>

            <div class="order-card-actions">
                <c:if test="${order.status != 'DELIVERED' && order.status != 'CANCELLED'}">
                    <form action="<c:url value='/bookstore/cancelOrder/${order.orderNumber}'/>" method="post" style="display:inline" onsubmit="return confirm('Cancel this order? It will be removed from the database.');">
                        <button type="submit" class="btn small danger">Cancel Order</button>
                    </form>
                </c:if>
                <a href="<c:url value='/bookstore/order/${order.orderNumber}'/>" class="btn small secondary">View Details</a>
                <a href="<c:url value='/bookstore/order/${order.orderNumber}/invoice'/>" class="btn small primary">⬇ Download Invoice</a>
            </div>
        </div>
    </c:forEach>
</div>

<jsp:include page="includes/footer.jsp"/>
