<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp"/>
<link rel="stylesheet" href="<c:url value='/css/home.css'/>">

<div class="hero-section">
    <h1>Welcome to Book Store</h1>
    <p>Your dream book is just a click away!</p>
    <a href="#books" class="shop-now-btn">Shop Now</a>
</div>

<div id="books" class="books-container">
    
    <c:forEach var="book" items="${books}">
     
        <div class="book-card">
            
            <c:if test="${book.sellingPrice > book.discountedPrice}">
               
                 
            </c:if>

          
            <a href="/bookstore/bookdetails?bookId=${book.bookId}" class="book-link">
                <img src="${book.imageUrl}" alt="${book.title}" class="book-image">
            </a>

            <h3 class="book-title">${book.title}</h3>
            
            <p class="book-price">
                <span class="original-price">${book.sellingPrice}</span> 
                <span class="discounted-price">$${book.discountedPrice}</span>
            </p>
            
            <p class="stock">Stock: ${book.stock}</p>
            
            <form action="addToCart" method="post">
                <input type="hidden" name="bookId" value="${book.bookId}"/>
                <button class="add-to-cart-btn" type="submit">Add to Cart</button>
            </form>
        </div>
    </c:forEach>
</div>

<jsp:include page="includes/footer.jsp"/>