<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Search Results"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/viewbook.css'/>">

<div class="main-content">

    <!-- Top: Books matching search keyword -->
    <c:if test="${not empty searchedBooks}">
        <h2 class="section-title">Search Results for "<c:out value='${keyword}'/>"</h2>
        <div class="book-container">
            <c:forEach var="book" items="${searchedBooks}">
                <div class="book-card">
                    <a href="/bookstore/bookdetails?bookId=${book.bookId}">
                        <img src="${book.imageUrl}" alt="${book.title}" />
                        <div class="book-details">
                            <div class="book-title">${book.title}</div>
                            <div class="book-author">Author: ${book.author.authorName}</div>
                            <div class="book-category">Category: ${book.category}</div>
                            <div class="book-year">Published: ${book.publishedYear}</div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- Bottom: Suggested or other books -->
    <c:if test="${not empty suggestedBooks}">
        <h2 class="section-title">You Might Also Like...</h2>
        <div class="book-container">
            <c:forEach var="s_book" items="${suggestedBooks}">
                <div class="book-card">
                    <a href="/bookstore/bookdetails?bookId=${s_book.bookId}">
                        <img src="${s_book.imageUrl}" alt="${s_book.title}" />
                        <div class="book-details">
                            <div class="book-title">${s_book.title}</div>
                            <div class="book-author">Author: ${s_book.author.authorName}</div>
                            <div class="book-category">Category: ${s_book.category}</div>
                            <div class="book-year">Published: ${s_book.publishedYear}</div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- If no books found -->
    <c:if test="${empty searchedBooks}">
        <p>No books found matching "<c:out value='${keyword}'/>".</p>
    </c:if>

</div>

<jsp:include page="includes/footer.jsp"/>
