<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/popup.css">

<div class="popup-overlay" id="requestBookPopup">
    <div class="popup-box">
        <span class="close-btn" onclick="closePopup('requestBookPopup')">&times;</span>

        <h2>Request a Book</h2>

        <form action="${pageContext.request.contextPath}/bookstore/requestBook" method="post">

            <input type="text" name="title" placeholder="Book Name" required>

            <input type="text" name="author" placeholder="Author Name" required>

            <textarea name="description" rows="3"
                      placeholder="Why do you want this book?" required></textarea>

            <button type="submit">Submit Request</button>
        </form>

    </div>
</div>
