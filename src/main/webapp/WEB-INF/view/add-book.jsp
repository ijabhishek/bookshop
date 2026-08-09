<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp"><jsp:param name="pageTitle" value="Add Book"/><jsp:param name="active" value="seller"/></jsp:include>
<link rel="stylesheet" href="<c:url value='/css/add-book.css'/>">

<div class="form-container">
    <h2 class="form-title">📚 Add a New Book</h2>
    <c:if test="${not empty message}"><div class="flash-message">${message}</div></c:if>
    <c:if test="${not empty error}"><div class="flash-message error">${error}</div></c:if>

    <form action="<c:url value='/bookstore/save'/>" method="post" enctype="multipart/form-data">
        <div class="form-group"><label>ISBN</label><input type="text" name="isbn" required placeholder="e.g. 9781234567890"></div>
        <div class="form-group"><label>Book Title</label><input type="text" name="title" required></div>
        <div class="form-group">
            <label>Writer / Author</label>
            <div style="display:flex;gap:8px">
                <select name="authorId" id="sellerAuthorId" required style="flex:1" onchange="toggleOtherWriter(this, 'sellerOtherWriter')">
                    <option value="">-- Select Writer --</option>
                    <c:forEach var="author" items="${authors}"><option value="${author.id}">${author.authorName}</option></c:forEach>
                    <option value="0">Other</option>
                </select>
                <button type="button" class="btn secondary" onclick="document.getElementById('writerForm').style.display='block'">+ Add New Writer</button>
            </div>
        </div>
        <div class="form-group" id="sellerOtherWriter" style="display:none">
            <label>Other Writer Name</label>
            <input type="text" name="otherAuthorName" placeholder="Enter writer name">
        </div>
        <div class="form-group"><label>Selling / Actual Price (₹)</label><input type="number" name="sellingPrice" step="0.01" min="0" required></div>
        <div class="form-group"><label>Discounted Price (₹)</label><input type="number" name="discountedPrice" step="0.01" min="0" required></div>
        <div class="form-group"><label>Book Description</label><textarea name="bookDescription" rows="4" required></textarea></div>
        <div class="form-group"><label>Category</label>
            <select name="category" required><c:forEach var="cat" items="${categories}"><option value="${cat}">${cat}</option></c:forEach></select>
        </div>
        <div class="form-group"><label>Published Date</label><input type="date" name="publishedYear" required></div>
        <div class="form-group"><label>Book Cover</label><input type="file" name="image" accept="image/*" required></div>
        <div class="form-group"><label>Stock</label><input type="number" name="stock" min="0" required></div>
        <div class="form-group"><label><input type="checkbox" name="bookAvailable" value="true" checked> Available for sale</label></div>
        <div class="form-actions"><button type="submit" class="btn primary">💾 Save Book</button><a href="<c:url value='/bookstore/seller'/>" class="btn secondary">Cancel</a></div>
    </form>

    <div id="writerForm" style="display:none;border:1px solid #ddd;padding:18px;margin-top:20px;border-radius:10px">
        <h3>Add New Writer</h3>
        <form action="<c:url value='/bookstore/author/save'/>" method="post" enctype="multipart/form-data">
            <div class="form-group"><label>Writer Name</label><input type="text" name="authorName" required></div>
            <div class="form-group"><label>Photo (optional)</label><input type="file" name="authorImage" accept="image/*"></div>
            <div class="form-group"><label>Date of Birth</label><input type="date" name="birthDate"></div>
            <div class="form-group"><label>Birth Place</label><input type="text" name="birthPlace" placeholder="City, Country"></div>
            <div class="form-group"><label>Biography</label><textarea name="biography" rows="4"></textarea></div>
            <div class="form-group"><label>Book Category</label>
                <select name="category" required><c:forEach var="cat" items="${categories}"><option value="${cat}">${cat}</option></c:forEach></select>
            </div>
            <button type="submit" class="btn primary">Save Writer</button>
            <button type="button" class="btn secondary" onclick="document.getElementById('writerForm').style.display='none'">Close</button>
        </form>
    </div>
</div>
<jsp:include page="includes/footer.jsp"/>

<script>
function toggleOtherWriter(select, targetId) {
    const target = document.getElementById(targetId);
    const input = target ? target.querySelector('input[name="otherAuthorName"]') : null;
    const isOther = select.value === '0';
    if (target) target.style.display = isOther ? 'block' : 'none';
    if (input) input.required = isOther;
}
</script>
