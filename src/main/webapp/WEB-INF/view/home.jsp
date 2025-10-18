<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book Store | Home</title>
    <link rel="stylesheet" href="<c:url value='/css/home.css'/>">
</head>

<body>

    <!-- Header include -->
    <jsp:include page="includes/header.jsp"/>

    <!-- Hero section -->
    <div class="hero-section">
        <h1>Welcome to Book Store</h1>
        <p>Your dream book is just a click away!</p>
        <a href="#books" class="shop-now-btn">Shop Now</a>
    </div>

    <!-- Books list -->
    <div id="books" class="books-container">

        <c:forEach var="book" items="${books}">
            <div class="book-card">

                <!-- Discount badge if applicable -->
                <c:if test="${book.sellingPrice > book.discountedPrice}">
                    <div class="discount-badge">
                        <fmt:formatNumber value="${100 - (book.discountedPrice * 100 / book.sellingPrice)}" maxFractionDigits="0"/>% OFF
                    </div>
                </c:if>

                <!-- Book image link -->
                <a href="/bookstore/bookdetails?bookId=${book.bookId}" class="book-link">
                    <img src="${book.imageUrl}" alt="${book.title}" class="book-image">
                </a>

                <!-- Title -->
                <h3 class="book-title">${book.title}</h3>

                <!-- Price -->
                <p class="book-price">
                    <span class="original-price">
                        <c:if test="${book.sellingPrice > book.discountedPrice}">
                            <del>₹${book.sellingPrice}</del>
                        </c:if>
                    </span>
                    <span class="discounted-price">₹${book.discountedPrice}</span>
                </p>

                <!-- Stock -->
                <p class="stock">Stock: ${book.stock}</p>

                <!-- Add to cart -->
                <form action="/bookstore/addToCart" method="post">
                    <input type="hidden" name="bookId" value="${book.bookId}"/>
                    <button class="add-to-cart-btn" type="submit">Add to Cart</button>
                </form>
            </div>
        </c:forEach>

    </div>

    <!-- Footer include -->
    <jsp:include page="includes/footer.jsp"/>
    
    <script src="<c:url value='/js/home.js'/>"></script>

</body>
</html>
