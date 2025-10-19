<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Cart</title>
    <link rel="stylesheet" href="<c:url value='/css/cart.css'/>">
    <style>
        /* CSS for the cart count badge (add this to your cart.css or keep it here) */
        .cart-badge {
            position: absolute;
            top: 0px; /* Adjust as needed */
            right: 0px; /* Adjust as needed */
            padding: 2px 6px;
            border-radius: 50%;
            background: #ff4500; /* Orange-red color */
            color: white;
            font-size: 10px;
            line-height: 1;
            font-weight: bold;
        }
        /* Ensure your header's cart link has 'position: relative' */
        /* You will need to apply a 'position: relative;' style to the cart link/icon element in your header.jsp */
    </style>
</head>
<body>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="My Cart"/>
    <jsp:param name="active" value="cart"/>
    <jsp:param name="cartItemCount" value="${cartItemCount}"/> 
</jsp:include>

<div class="cart-container">
    <h2>🛒 Your Shopping Cart</h2>

    <c:if test="${empty cart}">
        <p class="empty-cart">Your cart is empty. <a href="<c:url value='/bookstore/home'/>">Browse books</a></p>
    </c:if>

    <c:if test="${not empty cart}">
        <form action="<c:url value='/bookstore/updateCart'/>" method="post">
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Title</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Item Total</th>
                        <th>Remove</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${cart}">
                        <c:set var="book" value="${entry.key}"/>
                        <c:set var="quantity" value="${entry.value}"/>
                        <c:set var="itemTotal" value="${book.discountedPrice * quantity}"/>
                        
                        <tr>
                            <%-- FIX: Ensure entry.key (Book object) properties are accessed correctly --%>
                            <td><img src="<c:url value='${book.imageUrl}'/>" class="cart-image" alt="${book.title}"/></td>
                            
                            <%-- FIX: Display Book Title --%>
                            <td>${book.title}</td> 
                            
                            <%-- FIX: Display Book Price (Per Item) --%>
                            <td>₹<fmt:formatNumber value="${book.discountedPrice}" type="number" minFractionDigits="2" /></td>
                            
                            <td>
                                <div class="qty-control">
                                    <button type="button" class="qty-btn minus">–</button>
                                    <input type="number" name="quantity_${book.bookId}" value="${quantity}" min="1"
                                            class="qty-input"
                                            data-price="${book.discountedPrice}"
                                            data-bookid="${book.bookId}">
                                    <button type="button" class="qty-btn plus">+</button>
                                </div>
                            </td>
                            
                            <%-- FIX: Display Item Total (Price * Quantity) --%>
                            <td class="item-total">
                                ₹<span class="item-total-value"><fmt:formatNumber value="${itemTotal}" type="number" minFractionDigits="2" /></span>
                            </td>
                            
                            <td>
                                <a href="<c:url value='/bookstore/removeCart?bookId=${book.bookId}'/>" class="btn danger small">Remove</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </form>

        <div class="cart-summary">
            <%-- FIX: Added id="cart-total" for JavaScript update --%>
            <h3>Total: ₹<span id="cart-total"><fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" /></span></h3>
            <a href="<c:url value='/checkout'/>" class="btn primary">Proceed to Checkout</a>
        </div>
    </c:if>
</div>

<script>
    // The JavaScript logic remains the same for calculating totals, but I've added a call 
    // to update the cart badge after quantity changes.
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.qty-control').forEach(control => {
            const minus = control.querySelector('.minus');
            const plus = control.querySelector('.plus');
            const input = control.querySelector('.qty-input');

            // Pass the input element to updateQty
            minus.addEventListener('click', () => updateQty(input, -1));
            plus.addEventListener('click', () => updateQty(input, 1));
            input.addEventListener('change', () => updateQty(input, 0)); // Handle manual input
        });
    });

    function updateQty(input, change) {
        let qty = parseInt(input.value);
        const price = parseFloat(input.dataset.price);

        qty = isNaN(qty) ? 1 : qty + change;
        if (qty < 1) qty = 1;

        input.value = qty;

        // Update item total
        const row = input.closest('tr');
        const itemTotalValueSpan = row.querySelector('.item-total-value');
        if (itemTotalValueSpan) {
            itemTotalValueSpan.textContent = (qty * price).toFixed(2);
        }

        // Update cart total and cart count badge
        updateCartTotal();
        updateCartBadge(); // New function call
        
        // OPTIONAL: If you want to persist the change immediately (without refresh), 
        // you would use AJAX here to call your server's updateCart endpoint.
    }

    function updateCartTotal() {
        let total = 0;
        document.querySelectorAll('.qty-input').forEach(input => {
            const qty = parseInt(input.value) || 0;
            const price = parseFloat(input.dataset.price) || 0;
            total += qty * price;
        });
        
        const cartTotalElement = document.getElementById('cart-total');
        if(cartTotalElement) {
            cartTotalElement.textContent = total.toFixed(2);
        }
    }
    
    function updateCartBadge() {
        let totalItems = 0;
        // Calculate the total number of items from all quantity inputs
        document.querySelectorAll('.qty-input').forEach(input => {
            totalItems += parseInt(input.value) || 0;
        });
        
        // Find the badge element by its ID in the current document
        const badge = document.getElementById('cart-badge'); 
        
        if (badge) {
            badge.textContent = totalItems;
            // Show the badge if items > 0, otherwise hide it
            badge.style.display = totalItems > 0 ? 'inline-flex' : 'none';
        }
    }   
</script>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>