<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}" /></title>
    <link rel="stylesheet" href="<c:url value='/css/global.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/header.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/request_feedback.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/footer.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body data-context-path="${pageContext.request.contextPath}">
<header class="site-header">
    <div class="header-top">
        <div class="header-inner">
            <button class="hamburger" type="button" onclick="toggleMobileMenu()" aria-label="Open navigation"><span></span><span></span><span></span></button>
            <div class="logo"><a href="${pageContext.request.contextPath}/bookstore/home"><i class="fas fa-book"></i> BookShop</a></div>
            <form action="${pageContext.request.contextPath}/bookstore/viewbook" method="get" class="nav-search">
                <input type="text" name="keyword" placeholder="Search books..." aria-label="Search books">
                <button type="submit" aria-label="Search"><i class="fas fa-search"></i></button>
            </form>
            <div class="header-account">
                <c:choose>
                    <c:when test="${pageContext.request.userPrincipal != null}">
                        <span class="user-role-badge">
                            <c:choose>
                                <c:when test="${pageContext.request.isUserInRole('SELLER')}">Seller</c:when>
                                <c:when test="${pageContext.request.isUserInRole('ADMIN')}">Admin</c:when>
                                <c:when test="${pageContext.request.isUserInRole('SALES')}">Sales</c:when>
                                <c:otherwise>Purchaser</c:otherwise>
                            </c:choose>
                        </span>
                        <form action="${pageContext.request.contextPath}/bookstore/logout" method="post" class="nav-logout-form">
                            <button type="submit" class="nav-logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
                        </form>
                    </c:when>
                    <c:otherwise><a class="account-login" href="${pageContext.request.contextPath}/bookstore/login"><i class="fas fa-user"></i> Login</a></c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <nav class="main-nav" aria-label="Main navigation">
        <div class="nav-inner">
            <c:if test="${!pageContext.request.isUserInRole('ADMIN') && !pageContext.request.isUserInRole('SELLER') && !pageContext.request.isUserInRole('SALES')}">
            <a href="${pageContext.request.contextPath}/bookstore/home" class="nav-item <c:if test='${active eq "home"}'>active</c:if>"><i class="fas fa-home"></i> Home</a>
            <div class="nav-dropdown">
                <button type="button" class="nav-item nav-dropdown-button"><i class="fa-solid fa-layer-group"></i> Categories <i class="fas fa-chevron-down small-icon"></i></button>
                <div class="nav-dropdown-menu">
                    <a href="${pageContext.request.contextPath}/bookstore/category/fantasy">Fantasy Books</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/mystery">Mystery Books</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/thriller">Thriller Books</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/history">History Books</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/technology">Technology Books</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/romance">Romance Books</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/philosophy">Philosophy Books</a>
                    <a href="${pageContext.request.contextPath}/bookstore/category/science">Science Books</a>
                </div>
            </div>
            </c:if>
            <c:set var="itemCount" value="${cartCount != null ? cartCount : 0}"/>
            <c:if test="${!pageContext.request.isUserInRole('ADMIN') && !pageContext.request.isUserInRole('SELLER') && !pageContext.request.isUserInRole('SALES')}">
                <a href="${pageContext.request.contextPath}/bookstore/mycart" class="nav-item cart-link-container <c:if test='${active eq "cart"}'>active</c:if>"><i class="fas fa-shopping-cart"></i> Cart <span id="cart-badge" class="cart-badge" style="${itemCount > 0 ? '' : 'display:none;'}"><c:out value="${itemCount}" /></span></a>
                <a href="${pageContext.request.contextPath}/bookstore/myorders" class="nav-item <c:if test='${active eq "myorders"}'>active</c:if>"><i class="fas fa-box"></i> My Orders</a>
            </c:if>
            <c:if test="${pageContext.request.isUserInRole('SELLER')}">
                <a href="${pageContext.request.contextPath}/bookstore/seller" class="nav-item <c:if test='${active eq "seller"}'>active</c:if>"><i class="fas fa-store"></i> Seller Dashboard</a>
            </c:if>
            <c:if test="${pageContext.request.isUserInRole('SALES') || pageContext.request.isUserInRole('ADMIN')}">
                <a href="${pageContext.request.contextPath}/bookstore/sales/orders" class="nav-item <c:if test='${active eq "sales"}'>active</c:if>"><i class="fas fa-truck"></i> Sales</a>
            </c:if>
            <c:if test="${pageContext.request.userPrincipal != null}"><a href="${pageContext.request.contextPath}/bookstore/profile" class="nav-item <c:if test='${active eq "profile"}'>active</c:if>"><i class="fas fa-user"></i> Profile</a></c:if>
            <c:if test="${pageContext.request.isUserInRole('ADMIN')}"><a href="${pageContext.request.contextPath}/bookstore/admin" class="nav-item <c:if test='${active eq "admin"}'>active</c:if>"><i class="fas fa-user-shield"></i> Admin</a></c:if>
            <c:if test="${pageContext.request.isUserInRole('USER') || pageContext.request.isUserInRole('SELLER')}">
                <a href="javascript:void(0);" class="nav-item nav-action" onclick="openPopup('requestBookPopup')"><i class="fas fa-book-open"></i> Request a Book</a>
            </c:if>
            <c:if test="${!pageContext.request.isUserInRole('ADMIN') && !pageContext.request.isUserInRole('SELLER') && !pageContext.request.isUserInRole('SALES')}"><a href="javascript:void(0);" class="nav-item nav-action" onclick="openPopup('feedbackPopup')"><i class="fa-solid fa-comment-dots"></i> Feedback</a></c:if>
            <a href="${pageContext.request.contextPath}/bookstore/purpose" class="nav-item"><i class="fas fa-info-circle"></i> Purpose</a>
        </div>
    </nav>

    <nav class="mobile-menu" aria-label="Mobile navigation">
        <a href="${pageContext.request.contextPath}/bookstore/home"><i class="fas fa-home"></i> Home</a>
        <div class="mobile-category-heading"><i class="fa-solid fa-layer-group"></i> Book Categories</div>
        <a href="${pageContext.request.contextPath}/bookstore/category/fantasy">Fantasy Books</a>
        <a href="${pageContext.request.contextPath}/bookstore/category/mystery">Mystery Books</a>
        <a href="${pageContext.request.contextPath}/bookstore/category/thriller">Thriller Books</a>
        <a href="${pageContext.request.contextPath}/bookstore/category/history">History Books</a>
        <a href="${pageContext.request.contextPath}/bookstore/category/technology">Technology Books</a>
        <a href="${pageContext.request.contextPath}/bookstore/category/romance">Romance Books</a>
        <a href="${pageContext.request.contextPath}/bookstore/category/philosophy">Philosophy Books</a>
        <a href="${pageContext.request.contextPath}/bookstore/category/science">Science Books</a>
        <c:if test="${pageContext.request.isUserInRole('USER')}"><a href="${pageContext.request.contextPath}/bookstore/mycart"><i class="fas fa-shopping-cart"></i> Cart</a><a href="${pageContext.request.contextPath}/bookstore/myorders"><i class="fas fa-box"></i> My Orders</a></c:if>
        <c:if test="${pageContext.request.isUserInRole('SELLER')}"><a href="${pageContext.request.contextPath}/bookstore/seller"><i class="fas fa-store"></i> Seller Dashboard</a></c:if>
        <c:if test="${pageContext.request.isUserInRole('ADMIN')}"><a href="${pageContext.request.contextPath}/bookstore/admin"><i class="fas fa-user-shield"></i> Admin</a></c:if>
        <c:if test="${pageContext.request.userPrincipal != null}"><a href="${pageContext.request.contextPath}/bookstore/profile"><i class="fas fa-user"></i> Profile</a></c:if>
        <c:if test="${pageContext.request.isUserInRole('USER') || pageContext.request.isUserInRole('SELLER')}"><a href="javascript:void(0);" onclick="openPopup('requestBookPopup')"><i class="fas fa-book-open"></i> Request a Book</a></c:if>
        <a href="javascript:void(0);" onclick="openPopup('feedbackPopup')"><i class="fa-solid fa-comment-dots"></i> Feedback</a>
    </nav>
</header>

<c:if test="${pageContext.request.isUserInRole('USER') || pageContext.request.isUserInRole('SELLER')}"><div class="popup-overlay" id="requestBookPopup"><div class="popup-box"><span class="close-btn" onclick="closePopup('requestBookPopup')">&times;</span><h2>Request a Book</h2><form action="${pageContext.request.contextPath}/bookstore/requestBook" method="post"><input type="text" name="title" placeholder="Book Name" required><input type="text" name="author" placeholder="Author Name" required><textarea name="description" rows="3" placeholder="Why do you want this book?" required></textarea><button type="submit">Submit Request</button></form></div></div></c:if>
<div class="popup-overlay" id="feedbackPopup"><div class="popup-box"><span class="close-btn" onclick="closePopup('feedbackPopup')">&times;</span><h2>Feedback</h2><form action="${pageContext.request.contextPath}/bookstore/feedback" method="post"><input type="text" name="name" placeholder="Your Name" required><textarea name="message" rows="4" placeholder="Write your feedback here..." required></textarea><button type="submit">Send Feedback</button></form></div></div>

<script>
function toggleMobileMenu(){const menu=document.querySelector('.mobile-menu');if(menu)menu.classList.toggle('active');}
function openPopup(id){const popup=document.getElementById(id);if(popup)popup.style.display='flex';}
function closePopup(id){const popup=document.getElementById(id);if(popup)popup.style.display='none';}
</script>
<script src="<c:url value='/js/cart-actions.js'/>" defer></script>
