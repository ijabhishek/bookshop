<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}" /></title>
    <link rel="stylesheet" href="<c:url value='/css/global.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/header.css'/>">
</head>
<body>
<header class="site-header">
    <div class="container header-inner">
        <div class="hamburger" onclick="toggleMobileMenu()">
            <span></span>
            <span></span>
            <span></span>
        </div>
        <div class="logo">
            <a href="${pageContext.request.contextPath}bookstore/home">BookShop</a>
        </div>
        <nav class="main-nav">
            <a href="${pageContext.request.contextPath}/bookstore/home" class="<c:if test='${active eq "home"}'>active</c:if>">Home</a>
            <a href="${pageContext.request.contextPath}/bookstore/mycart" class="<c:if test='${active eq "cart"}'>active</c:if>">Cart</a>
            <a href="${pageContext.request.contextPath}/bookstore/seller" class="<c:if test='${active eq "seller"}'>active</c:if>">Seller</a>
            <a href="${pageContext.request.contextPath}/bookstore/admin" class="<c:if test='${active eq "admin"}'>active</c:if>">Admin</a>
            <form action="viewbook" method="get" class="nav-search">
                <input type="text" name="query" placeholder="Search books...">
                <button type="submit">Search</button>
            </form>
        </nav>
        <nav class="mobile-menu">
            <a href="${pageContext.request.contextPath}/bookstore/login">Login</a>
            <a href="${pageContext.request.contextPath}/bookstore/track-order">Track Order</a>
            <a href="${pageContext.request.contextPath}/bookstore/request-book">Request a Book</a>
            <div class="category-menu">
                <span onclick="toggleCategoryMenu()">Book Category</span>
                <div class="category-submenu">
                    <a href="${pageContext.request.contextPath}/bookstore/category/fiction">Fiction</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/history">History</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/romance">Romance</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/science-fiction">Science Fiction</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/mystery">Mystery</a>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/bookstore/feedback">Feedback</a>
        </nav>
    </div>
</header>
<div class="container">
    <!-- Main content goes here -->
</div>
<script>
    function toggleMobileMenu() {
        const mobileMenu = document.querySelector('.mobile-menu');
        mobileMenu.classList.toggle('active');
    }

    function toggleCategoryMenu() {
        const categorySubmenu = document.querySelector('.category-submenu');
        categorySubmenu.classList.toggle('active');
    }
</script>
</body>
</html>