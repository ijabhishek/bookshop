
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Add Book"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/add-book.css'/>">

<div class="form-container">
    <h2 class="form-title">📚 Add a New Book</h2>
    <form action="save" method="post" enctype="multipart/form-data">


        <!-- ISBN -->
        <div class="form-group">
            <label for="isbn">ISBN</label>
            <input type="text" id="isbn" name="isbn" required placeholder="e.g. 9781234567890">
        </div>

        <!-- Title -->
        <div class="form-group">
            <label for="title">Book Title</label>
            <input type="text" id="title" name="title" required placeholder="Enter book title">
        </div>

        <!-- Author -->
        <div class="form-group">
            <label for="authorId">Author</label>
            <select id="authorId" name="authorId" required>
                <option value="">-- Select Author --</option>
                <c:forEach var="author" items="${authors}">
                    <option value="${author.id}">${author.authorName}</option>
                </c:forEach>
            </select>
        </div>

        <!-- Selling Price -->
        <div class="form-group">
            <label for="sellingPrice">Selling Price (₹)</label>
            <input type="number" id="sellingPrice" name="sellingPrice" required placeholder="Enter price">
        </div>

        <!-- Discounted Price -->
        <div class="form-group">
            <label for="discountedPrice">Discounted Price (₹)</label>
            <input type="number" id="discountedPrice" name="discountedPrice" placeholder="Enter discounted price">
        </div>


        <!-- Description -->
        <div class="form-group">
            <label for="bookDescription">Book Description</label>
            <textarea id="bookDescription" name="bookDescription" rows="4" placeholder="Write a short description about the book..." required></textarea>
        </div>

        <!-- Category Dropdown -->
        <div class="form-group">
            <label for="category">Category</label>
            <select id="category" name="category" required>
                <option value="">-- Select Category --</option>
                <option value="FANTASY">Fantasy</option>
                <option value="MYSTERY">Mystery</option>
                <option value="THRILLER">Thriller</option>
                <option value="HISTORY">History</option>
                <option value="TECHNOLOGY">Technology</option>
                <option value="ROMANCE">Romance</option>
                <option value="PHILOSOPHY">Philosophy</option>
                <option value="SCIENCE">Science</option>
            </select>
        </div>

        <!-- Published Year -->
        <div class="form-group">
            <label for="publishedYear">Published Year</label>
            <input type="date" id="publishedYear" name="publishedYear" required>
        </div>

        <!-- Image Upload -->
        <div class="form-group">
            <label for="image">Book Cover</label>
            <input type="file" id="image" name="image" accept="image/*" required>
        </div>
        <div class="form-group">
            <label for="stock">Stock</label>
            <input type="number" id="stock" name="stock" required placeholder="Please enter the stock">
        </div>
        <!-- Book Available -->
        <div class="form-group">
            <label for="bookAvailable">Book Available</label>
            <input type="checkbox" id="bookAvailable" name="bookAvailable" value="true"/>
        </div>

        <!-- Actions -->
        <div class="form-actions">
            <button type="submit" class="btn primary">💾 Save Book</button>
            <a href="seller" class="btn secondary">❌ Cancel</a>
        </div>
    </form>
</div>

<jsp:include page="includes/footer.jsp"/>

