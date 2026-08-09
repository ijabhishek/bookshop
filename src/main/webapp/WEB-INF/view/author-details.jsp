<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp"><jsp:param name="pageTitle" value="Author Profile"/></jsp:include>
<link rel="stylesheet" href="<c:url value='/css/author-details.css'/>">
<main class="author-page">
<div class="author-container">
    <div class="author-header">
        <c:choose><c:when test="${not empty author.imageUrl}"><img src="${author.imageUrl}" alt="${author.authorName}" class="author-image"/></c:when><c:otherwise><div class="author-image author-placeholder"><i class="fas fa-user"></i></div></c:otherwise></c:choose>
        <div class="author-info"><span class="author-kicker">AUTHOR PROFILE</span><h1>${author.authorName}</h1><p><strong>Born:</strong> ${author.birthDate}</p><p><strong>Birth Place:</strong> ${author.birthPlace}</p><p><strong>Category:</strong> ${author.category}</p></div>
    </div>
    <div class="author-biography"><h2>Biography</h2><p>${author.biography}</p></div>
    <div class="author-books"><h2>Books by ${author.authorName}</h2><div class="book-list"><c:forEach var="book" items="${books}"><a class="book-card" href="${pageContext.request.contextPath}/bookstore/bookdetails?bookId=${book.bookId}"><img src="${book.imageUrl}" alt="${book.title}" class="book-cover"/><p class="book-title">${book.title}</p><span>View book <i class="fas fa-arrow-right"></i></span></a></c:forEach><c:if test="${empty books}"><p class="no-books">No books are available for this author yet.</p></c:if></div></div>
</div>
</main>
<jsp:include page="includes/footer.jsp"/>
