<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Sales - Orders"/>
    <jsp:param name="active" value="sales"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
<link rel="stylesheet" href="<c:url value='/css/account.css'/>">

<div class="admin-container">
    <h2>🧑‍💼 Orders &amp; Delivery Addresses</h2>

    <c:if test="${not empty message}">
        <div class="flash-message">${message}</div>
    </c:if>

    <form class="filter-bar" method="get" action="<c:url value='/bookstore/sales/orders'/>">
        <label for="status">Filter by status:</label>
        <select id="status" name="status" onchange="this.form.submit()">
            <option value="">All</option>
            <c:forEach var="s" items="${statuses}">
                <option value="${s}" ${selectedStatus == s ? 'selected' : ''}>${s}</option>
            </c:forEach>
        </select>
    </form>

    <table class="admin-table">
        <thead>
            <tr>
                <th>Order #</th><th>Customer</th><th>Phone</th><th>Delivery Address</th>
                <th>Date</th><th>Total (₹)</th><th>Status</th><th>Update</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="order" items="${orders}">
                <tr>
                    <td><a href="<c:url value='/bookstore/order/${order.orderNumber}'/>">${order.orderNumber}</a></td>
                    <td>${order.user.firstName}</td>
                    <td>${order.user.phoneNumber}</td>
                    <td>${order.user.address}</td>
                    <td><fmt:formatDate value="${order.orderDateAsDate}" pattern="dd MMM yyyy"/></td>
                    <td><fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2"/></td>
                    <td><span class="status-badge status-${order.status.toString().toLowerCase()}">${order.status}</span></td>
                    <td>
                        <form action="<c:url value='/bookstore/sales/updateStatus'/>" method="post" class="order-update-form">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <select name="status">
                                <c:forEach var="s" items="${statuses}">
                                    <option value="${s}" ${order.status == s ? 'selected' : ''}>${s}</option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn small primary">Update</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="includes/footer.jsp"/>
