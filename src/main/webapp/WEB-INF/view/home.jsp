<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="includes/header.jsp"><jsp:param name="pageTitle" value="Book Store | Home"/><jsp:param name="active" value="home"/></jsp:include>
<link rel="stylesheet" href="<c:url value='/css/home.css'/>">

<c:if test="${pageContext.request.isUserInRole('USER')}">
    <div class="role-banner purchaser-banner"><i class="fas fa-shopping-bag"></i> Purchaser mode — browse and purchase books</div>
</c:if>
<c:if test="${not empty message}"><div class="flash-message">${message}</div></c:if>
<c:if test="${not empty error}"><div class="flash-message error">${error}</div></c:if>
<div class="hero-section">
    <h1>Welcome to Book Store</h1>
    <p>Your dream book is just a click away!</p>
    <a href="#books" class="shop-now-btn">Shop Now</a>
</div>

<div id="books" class="books-container">
    <c:forEach var="book" items="${books}">
        <div class="book-card">
            <c:if test="${book.sellingPrice > book.discountedPrice}">
                <div class="discount-badge"><fmt:formatNumber value="${100 - (book.discountedPrice * 100 / book.sellingPrice)}" maxFractionDigits="0"/>% OFF</div>
            </c:if>
            <a href="<c:url value='/bookstore/bookdetails?bookId=${book.bookId}'/>" class="book-link"><img src="${book.imageUrl}" alt="${book.title}" class="book-image"></a>
            <h3 class="book-title">${book.title}</h3>
            <p class="book-author">${book.authorName}</p>
            <p class="book-price">
                <c:if test="${book.sellingPrice > book.discountedPrice}"><span class="original-price"><del>₹${book.sellingPrice}</del></span></c:if>
                <span class="discounted-price">₹${book.discountedPrice}</span>
            </p>
            <p class="stock">Stock: ${book.stock}</p>
            <form data-add-to-cart action="<c:url value='/bookstore/api/cart/add'/>" method="post">
                <input type="hidden" name="bookId" value="${book.bookId}"/>
                <button class="add-to-cart-btn" type="submit">Add to Cart</button>
            </form>
        </div>
    </c:forEach>
    <c:if test="${empty books}"><p>No books are currently available.</p></c:if>
</div>

<jsp:include page="includes/footer.jsp"/>
