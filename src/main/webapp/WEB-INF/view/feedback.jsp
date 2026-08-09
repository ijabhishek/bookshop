<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/popup.css">

<div class="popup-overlay" id="feedbackPopup">
    <div class="popup-box">
        <span class="close-btn" onclick="closePopup('feedbackPopup')">&times;</span>

        <h2>Feedback</h2>

        <form action="${pageContext.request.contextPath}/bookstore/feedback" method="post">

            <input type="text" name="name" placeholder="Your Name" required>

            <textarea name="message" rows="4"
                      placeholder="Write your feedback here..." required></textarea>

            <button type="submit">Send Feedback</button>
        </form>

    </div>
</div>
