<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="includes/header.jsp"><jsp:param name="pageTitle" value="Category"/><jsp:param name="active" value="home"/></jsp:include>
<link rel="stylesheet" href="<c:url value='/css/home.css'/>">
<div class="hero-section"><h1>${category} Books</h1><p>Books in the ${category} category</p></div>
<div id="books" class="books-container">
<c:forEach var="book" items="${books}">
<div class="book-card">
<c:if test="${book.sellingPrice > book.discountedPrice}"><div class="discount-badge"><fmt:formatNumber value="${100 - (book.discountedPrice * 100 / book.sellingPrice)}" maxFractionDigits="0"/>% OFF</div></c:if>
<a href="<c:url value='/bookstore/bookdetails?bookId=${book.bookId}'/>"><img src="${book.imageUrl}" alt="${book.title}" class="book-image"></a>
<h3 class="book-title">${book.title}</h3><p>${book.authorName}</p>
<p class="book-price"><c:if test="${book.sellingPrice > book.discountedPrice}"><del>₹${book.sellingPrice}</del></c:if> <span class="discounted-price">₹${book.discountedPrice}</span></p>
<p class="stock">Stock: ${book.stock}</p>
<form data-add-to-cart action="<c:url value='/bookstore/api/cart/add'/>" method="post"><input type="hidden" name="bookId" value="${book.bookId}"/><button class="add-to-cart-btn">Add to Cart</button></form>
</div>
</c:forEach>
<c:if test="${empty books}"><p>No books found in this category.</p></c:if>
</div>
<jsp:include page="includes/footer.jsp"/>
