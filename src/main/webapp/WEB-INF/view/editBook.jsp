<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Edit Book"/>
    <jsp:param name="active" value="admin"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/admin.css'/>">

<div class="admin-container">
    <h2>✏️ Edit Book</h2>
    <form action="updateBook" method="post" enctype="multipart/form-data" class="admin-form">
            <input type="hidden" name="bookId" value="${book.bookId}">
            <div class="form-grid">
                <div class="form-group-section">
                    <h4>Book Information</h4>
                    <div class="form-group">
                        <label for="isbn">ISBN</label>
                        <input type="text" id="isbn" name="isbn" value="${book.isbn}" required>
                    </div>
                    <div class="form-group">
                        <label for="title">Book Title</label>
                        <input type="text" id="title" name="title" value="${book.title}" required>
                    </div>
                    <div class="form-group">
                        <label for="authorId">Author</label>
                        <select id="authorId" name="authorId" required>
                            <option value="">-- Select Author --</option>
                            <c:forEach var="author" items="${authors}">
                                <option value="${author.id}" ${author.id == book.authorId ? 'selected' : ''}>${author.authorName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="category">Category</label>
                        <select id="category" name="category" required>
                            <option value="">-- Select Category --</option>
                            <option value="FANTASY" ${book.category == 'FANTASY' ? 'selected' : ''}>Fantasy</option>
                            <option value="MYSTERY" ${book.category == 'MYSTERY' ? 'selected' : ''}>Mystery</option>
                            <option value="THRILLER" ${book.category == 'THRILLER' ? 'selected' : ''}>Thriller</option>
                            <option value="HISTORY" ${book.category == 'HISTORY' ? 'selected' : ''}>History</option>
                            <option value="TECHNOLOGY" ${book.category == 'TECHNOLOGY' ? 'selected' : ''}>Technology</option>
                            <option value="ROMANCE" ${book.category == 'ROMANCE' ? 'selected' : ''}>Romance</option>
                            <option value="PHILOSOPHY" ${book.category == 'PHILOSOPHY' ? 'selected' : ''}>Philosophy</option>
                            <option value="SCIENCE" ${book.category == 'SCIENCE' ? 'selected' : ''}>Science</option>
                        </select>
                    </div>
                </div>

                <div class="form-group-section">
                    <h4>Pricing & Stock</h4>
                    <div class="form-group">
                        <label for="sellingPrice">Selling Price (₹)</label>
                        <input type="number" id="sellingPrice" name="sellingPrice" value="${book.sellingPrice}" required>
                    </div>
                    <div class="form-group">
                        <label for="discountedPrice">Discounted Price (₹)</label>
                        <input type="number" id="discountedPrice" name="discountedPrice" value="${book.discountedPrice}">
                    </div>
                    <div class="form-group">
                        <label for="stock">Stock Quantity</label>
                        <input type="number" id="stock" name="stock" value="${book.stock}" required>
                    </div>
                    <div class="form-group">
                        <label for="publishedYear">Published Date</label>
                        <input type="date" id="publishedYear" name="publishedYear" value="${book.publishedYear}" required>
                    </div>
                </div>
            </div>

            <div class="form-group form-group-full">
                <label for="bookDescription">Book Description</label>
                <textarea id="bookDescription" name="bookDescription" rows="5" required>${book.bookDescription}</textarea>
            </div>

            <div class="form-footer">
                <div class="form-group">
                    <label for="image">Book Cover (Leave empty to keep current)</label>
                    <input type="file" id="image" name="image" accept="image/*">
                    <img src="${book.imageUrl}" alt="Current Cover" style="width:100px;height:auto;margin-top:10px;">
                </div>
                <div class="form-group form-group-checkbox">
                    <input type="checkbox" id="bookAvailable" name="bookAvailable" value="true" ${book.bookAvailable ? 'checked' : ''}>
                    <label for="bookAvailable">Available for Sale</label>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn primary">💾 Update Book</button>
                    <a href="<c:url value='/admin'/>" class="btn secondary">Cancel</a>
                </div>
            </div>

    </form>
</div>

<jsp:include page="includes/footer.jsp"/>