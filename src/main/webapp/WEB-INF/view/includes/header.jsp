<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}" /></title>
    <link rel="stylesheet" href="<c:url value='/css/global.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/header.css'/>">
    
    <%-- Include Font Awesome for a reliable cart icon --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
            <a href="${pageContext.request.contextPath}bookstore/home"><i class="fas fa-book"></i> BookShop</a>
        </div>
        <nav class="main-nav">
            <a href="${pageContext.request.contextPath}/bookstore/home" class="<c:if test='${active eq "home"}'>active</c:if>">
                <i class="fas fa-home"></i> Home
            </a>
            
            <%-- 🌟 THE CORE FIX: Read count from the Request Scope (set by server) 🌟 --%>
            <c:set var="itemCount" value="${cartCount != null ? cartCount : 0}"/>

            <a href="${pageContext.request.contextPath}/bookstore/mycart" 
                class="<c:if test='${active eq "cart"}'>active</c:if> cart-link-container">
                
                <%-- Using Font Awesome for the icon --%>
                <i class="fas fa-shopping-cart"></i>  Cart 
    
                <%-- Only render the badge if items exist --%>
                <c:if test="${itemCount > 0}">
                    <span id="cart-badge" class="cart-badge">
                        <c:out value="${itemCount}" />
                    </span>
                </c:if>
            </a>
            
            <a href="${pageContext.request.contextPath}/bookstore/seller" class="<c:if test='${active eq "seller"}'>active</c:if>">Seller</a>
            <a href="${pageContext.request.contextPath}/bookstore/admin" class="<c:if test='${active eq "admin"}'>active</c:if>"><i class="fas fa-user-shield"></i> Admin</a>
            <form action="viewbook" method="get" class="nav-search">
                <input type="text" name="keyword" placeholder="Search books...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </nav>
        <nav class="mobile-menu">
            <a href="${pageContext.request.contextPath}/bookstore/login"><i class="fas fa-user"></i> Login</a>
            <a href="${pageContext.request.contextPath}/bookstore/track-order"><i class="fas fa-shipping-fast"></i> Track Order</a>
            <a href="${pageContext.request.contextPath}/bookstore/request-book"> <i class="fas fa-book-open"></i> Request a Book</a>
            <div class="category-menu">
                <span onclick="toggleCategoryMenu()"><i class="fa-solid fa-layer-group"></i> Book Category</span>
                <div class="category-submenu">
                    <a href="${pageContext.request.contextPath}/bookstore/category/fiction">Fiction</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/history">History</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/romance">Romance</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/science-fiction">Science Fiction</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/mystery">Mystery</a>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/bookstore/feedback"><i class="fa-solid fa-comment-dots"></i> Feedback</a>
        </nav>
    </div>
</header>
<div class="container">
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