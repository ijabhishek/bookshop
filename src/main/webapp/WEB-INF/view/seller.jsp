<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Seller Dashboard"/>
    <jsp:param name="active" value="seller"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/seller.css'/>">

<h2>My Uploaded Books</h2>
<a href="addbook" class="btn primary">+ Add New Book</a>

<div class="seller-books">
    <c:forEach var="book" items="${sellerBooks}">
        <div class="seller-book">
            <img src="${book.imageUrl}" class="seller-thumb"/>
            <div>
                <h4>${book.title}</h4>
                <p>₹${book.price}</p>
            </div>
            <div class="seller-actions">
                <a href="seller/edit/${book.id}" class="btn small">Edit</a>
                <form action="seller/delete" method="post" class="inline-form">
                    <input type="hidden" name="bookId" value="${book.id}"/>
                    <button class="btn danger small">Delete</button>
                </form>
            </div>
        </div>
    </c:forEach>
</div>

<jsp:include page="includes/footer.jsp"/>
