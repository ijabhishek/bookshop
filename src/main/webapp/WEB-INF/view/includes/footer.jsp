<footer class="site-footer">
    <div class="container footer-inner">
        <div class="footer-column">
            <h3>BookShop</h3>
            <p>Your one-stop shop for books of all genres. Discover, read, and enjoy!</p>
        </div>
        <div class="footer-column">
            <h3>Quick Links</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/bookstore/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/mycart">Cart</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/seller">Seller</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/admin">Admin</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>Categories</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/bookstore/category/fantasy">Fantasy</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/category/mystery">Mystery</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/category/thriller">Thriller</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/category/history">History</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/category/technology">Technology</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/category/romance">Romance</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/category/philosophy">Philosophy</a></li>
                <li><a href="${pageContext.request.contextPath}/bookstore/category/science">Science</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>Contact Us</h3>
            <ul>
                <li>Email: <a href="mailto:support@bookshop.com">support@bookshop.com</a></li>
                <li>Phone: <a href="tel:+1234567890">+1 (234) 567-890</a></li>
                <li>Address: 123 Book Lane, Reading City, BK 45678</li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>Stay Connected</h3>
            <form action="${pageContext.request.contextPath}/bookstore/subscribe" method="post" class="newsletter-form">
                <input type="email" name="email" placeholder="Enter your email" required>
                <button type="submit">Subscribe</button>
            </form>
            <div class="social-links">
                <a href="https://twitter.com" target="_blank" class="social-icon"> <i class="fab fa-twitter"></i></a>
                <a href="https://facebook.com" target="_blank" class="social-icon"> <i class="fab fa-facebook"></i></a>
                <a href="https://instagram.com" target="_blank" class="social-icon"> <i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2026 BookShop. All rights reserved.</p>
        <button class="back-to-top" onclick="scrollToTop()"> Back to Top</button>
    </div>
</footer>
<script>
function scrollToTop() { window.scrollTo({ top: 0, behavior: 'smooth' }); }
</script>
</body>
</html>
