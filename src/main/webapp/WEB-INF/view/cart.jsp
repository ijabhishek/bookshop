<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="My Cart"/>
    <jsp:param name="active" value="cart"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/cart.css'/>">

<div class="cart-container">
    <h2>🛒 Your Shopping Cart</h2>

    <!-- If cart is empty -->
    <c:if test="${empty cartItems}">
        <p class="empty-cart">Your cart is empty. <a href="<c:url value='/bookstore/home'/>">Browse books</a></p>
    </c:if>

    <!-- If cart has items -->
    <c:if test="${not empty cartItems}">
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Book</th>
                    <th>Title</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Remove</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cartItems}">
                    <tr>
                        <td><img src="<c:url value='/images/${item.book.image}'/>" class="cart-image"/></td>
                        <td>${item.book.title}</td>
                        <td>₹${item.book.price}</td>
                        <td>
                            <form action="cart/update" method="post" class="qty-form">
                                <input type="hidden" name="bookId" value="${item.book.id}">
                                <input type="number" name="quantity" value="${item.quantity}" min="1" class="qty-input">
                                <button type="submit" class="btn small">Update</button>
                            </form>
                        </td>
                        <td>₹${item.book.price * item.quantity}</td>
                        <td>
                            <a href="cart/remove?bookId=${item.book.id}" class="btn danger small">Remove</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Cart Summary -->
        <div class="cart-summary">
            <h3>Total: ₹${cartTotal}</h3>
            <a href="<c:url value='/checkout'/>" class="btn primary">Proceed to Checkout</a>
        </div>
    </c:if>
</div>

<jsp:include page="includes/footer.jsp"/>
