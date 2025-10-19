<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Book Details"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/book-details.css'/>">

<div class="book-detail-container">
    <div class="book-detail">
        
        <img src="${book.imageUrl}" alt="${book.title}" class="book-image">

        <div class="detail-info">
            <h2>${book.title}</h2>
            <p><strong>Author:</strong><a href="/bookstore/author/details?id=${book.author.id}">${book.author.authorName}</a></p>
            <p><strong>ISBN:</strong> ${book.isbn}</p>
            <p><strong>Published:</strong> ${book.publishedYear}</p>
            
            <p class="price-container">
                <strong class="label-price">Selling Price:</strong> 
                <span class="original-price">₹${book.sellingPrice}</span>
            </p>
            <p class="price-container">
                <strong class="label-price">Discounted Price:</strong> 
                <span class="discounted-price">₹${book.discountedPrice}</span>
            </p>
            
            <div class="description-text">
                <h3>Description</h3>
                <p>${book.bookDescription}</p>
            </div>
            
            <form action="/bookstore/addToCart" method="post">
                <input type="hidden" name="bookId" value="${book.bookId}" />
                <label>Qty: <input type="number" name="quantity" value="1" min="1" class="qty-input" /></label>
                <button class="btn primary">Add to Cart</button>
            </form>
        </div>
    </div>
</div>

<c:if test="${not empty suggestedBooks}">
    <div class="suggested-books-section">
        <h2 class="section-title">You Might Also Like...</h2>
        <div class="suggested-books-container">
            <c:forEach var="s_book" items="${suggestedBooks}">
                <a href="/bookstore/bookdetails?bookId=${s_book.bookId}" class="suggested-book-card-link">
                    <div class="suggested-book-card">
                        <img src="${s_book.imageUrl}" alt="${s_book.title}" class="suggested-book-image">
                        <div class="suggested-book-info">
                            <p class="suggested-book-title">${s_book.title}</p>
                            <p class="suggested-book-price">₹${s_book.discountedPrice}</p>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
</c:if>

<jsp:include page="includes/footer.jsp"/>