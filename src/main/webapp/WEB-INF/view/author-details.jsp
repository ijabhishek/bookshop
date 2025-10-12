<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${author.authorName} - Author Profile</title>
    <link rel="stylesheet" href="/css/author-details.css">
</head>
<body>

<div class="author-container">
    <div class="author-header">
        <img src="${author.imageUrl}" alt="${author.authorName}" class="author-image"/>
        <div class="author-info">
            <h1>${author.authorName}</h1>
            <p><strong>Born:</strong> ${author.birthDate}</p>
            <p><strong>Nationality:</strong> ${author.nationality}</p>
        </div>
    </div>

    <div class="author-biography">
        <h2>Biography</h2>
        <p>${author.biography}</p>
    </div>

    <div class="author-books">
        <h2>Books by ${author.authorName}</h2>
        <div class="book-list">
            <c:forEach var="book" items="${books}">
                <div class="book-card">
                    <img src="${book.imageUrl}" alt="${book.title}" class="book-cover"/>
                    <p class="book-title">${book.title}</p>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

</body>
</html>
