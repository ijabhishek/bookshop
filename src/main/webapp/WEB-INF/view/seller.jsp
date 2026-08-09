<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="includes/header.jsp"><jsp:param name="pageTitle" value="Seller Dashboard"/><jsp:param name="active" value="seller"/></jsp:include>
<link rel="stylesheet" href="<c:url value='/css/seller.css'/>">

<main class="seller-page">
  <section class="seller-hero">
    <div>
      <span class="eyebrow">SELLER CENTER</span>
      <h1>Manage your book business in one place</h1>
      <p>Upload books, manage writers, track received orders and review customer book requests.</p>
    </div>
    <a href="<c:url value='/bookstore/addbook'/>" class="seller-primary-action"><i class="fas fa-plus"></i> Upload New Book</a>
  </section>

  <c:if test="${not empty message}"><div class="seller-alert success">${message}</div></c:if>
  <c:if test="${not empty error}"><div class="seller-alert error">${error}</div></c:if>

  <div class="seller-stats">
    <article><i class="fas fa-book"></i><div><span>Uploaded Books</span><strong>${empty sellerBooks ? 0 : sellerBooks.size()}</strong></div></article>
    <article><i class="fas fa-box-open"></i><div><span>Received Orders</span><strong>${empty receivedOrders ? 0 : receivedOrders.size()}</strong></div></article>
    <article><i class="fas fa-pen-fancy"></i><div><span>Available Writers</span><strong>${empty authors ? 0 : authors.size()}</strong></div></article>
  </div>

  <section class="seller-section">
    <div class="section-heading"><div><h2><i class="fas fa-book-open"></i> My Uploaded Books</h2><p>Your current catalogue and stock information.</p></div></div>
    <div class="seller-books-grid">
      <c:forEach var="book" items="${sellerBooks}">
        <article class="seller-book-card">
          <img src="${book.imageUrl}" alt="${book.title}" class="seller-thumb" onerror="this.style.display='none'"/>
          <div class="seller-book-content"><h3>${book.title}</h3><p class="seller-book-meta">${book.category}</p><div class="price-line"><strong>₹${book.discountedPrice}</strong><span>Original ₹${book.sellingPrice}</span></div><p class="stock-line"><i class="fas fa-cubes"></i> ${book.stock} in stock</p></div>
        </article>
      </c:forEach>
      <c:if test="${empty sellerBooks}"><div class="seller-empty"><i class="fas fa-book"></i><h3>No books uploaded yet</h3><p>Start building your catalogue by uploading your first book.</p><a href="<c:url value='/bookstore/addbook'/>" class="seller-link-btn">Upload a Book</a></div></c:if>
    </div>
  </section>

  <section class="seller-section seller-writer-card">
    <div class="section-heading"><div><h2><i class="fas fa-feather-pointed"></i> Writer Management</h2><p>Add writers now so they are available in the writer dropdown when uploading a book.</p></div></div>
    <form action="<c:url value='/bookstore/author/save'/>" method="post" enctype="multipart/form-data" class="seller-writer-form">
      <div class="seller-form-grid">
        <div class="seller-field"><label>Writer Name *</label><input type="text" name="authorName" placeholder="Enter writer name" required></div>
        <div class="seller-field"><label>Book Category *</label><select name="category" required><option value="">Select category</option><c:forEach var="cat" items="${categories}"><option value="${cat}">${cat}</option></c:forEach></select></div>
        <div class="seller-field"><label>Date of Birth</label><input type="date" name="birthDate"></div>
        <div class="seller-field"><label>Writer Photo</label><input type="file" name="authorImage" accept="image/*"></div>
        <div class="seller-field seller-field-wide"><label>Birth Place</label><input type="text" name="birthPlace" placeholder="City, Country"></div>
        <div class="seller-field seller-field-full"><label>Biography</label><textarea name="biography" rows="5" placeholder="Write a biography for this writer. Long biographies are supported."></textarea></div>
      </div>
      <div class="seller-form-actions"><button type="submit" class="seller-primary-action"><i class="fas fa-user-plus"></i> Add Writer</button></div>
    </form>
    <div class="writer-chip-area"><span class="writer-label">Available writers</span><c:forEach var="author" items="${authors}"><span class="writer-chip"><i class="fas fa-user"></i> ${author.authorName}</span></c:forEach><c:if test="${empty authors}"><span class="muted-text">No writers added yet.</span></c:if></div>
  </section>

  <section class="seller-section">
    <div class="section-heading"><div><h2><i class="fas fa-truck"></i> Orders Received</h2><p>Orders containing books from your catalogue.</p></div></div>
    <div class="seller-table-wrap"><table class="seller-table"><thead><tr><th>Order</th><th>Customer</th><th>Books</th><th>Total</th><th>Status</th><th>Date</th></tr></thead><tbody><c:forEach var="order" items="${receivedOrders}"><tr><td>${order.orderNumber}</td><td>${order.user.firstName}<br><span class="muted-text">${order.user.userId}</span></td><td><c:forEach var="item" items="${order.orderItems}">${item.book.title} × ${item.quantity}<br/></c:forEach></td><td>₹<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/></td><td><span class="seller-status">${order.status}</span></td><td><fmt:formatDate value="${order.orderDateAsDate}" pattern="dd MMM yyyy"/></td></tr></c:forEach><c:if test="${empty receivedOrders}"><tr><td colspan="6" class="table-empty">No orders for your books yet.</td></tr></c:if></tbody></table></div>
  </section>

  <section class="seller-section">
    <div class="section-heading"><div><h2><i class="fas fa-bell"></i> Requested Books</h2><p>Customer requests you may want to upload to your catalogue.</p></div></div>
    <div class="seller-table-wrap"><table class="seller-table"><thead><tr><th>Book</th><th>Requested Author</th><th>Customer</th><th>Reason</th><th>Status</th></tr></thead><tbody><c:forEach var="r" items="${bookRequests}"><tr><td>${r.title}</td><td>${r.author}</td><td>${r.requester.firstName}<br><span class="muted-text">${r.requester.userId}</span></td><td>${r.description}</td><td><span class="seller-status">${r.status}</span></td></tr></c:forEach><c:if test="${empty bookRequests}"><tr><td colspan="5" class="table-empty">No pending book requests.</td></tr></c:if></tbody></table></div>
  </section>

    <section class="seller-section">
        <h2>Received Orders</h2>
        <table class="admin-table"><thead><tr><th>Order #</th><th>Customer</th><th>Total</th><th>Status</th><th>Update</th></tr></thead><tbody>
        <c:forEach var="order" items="${receivedOrders}"><tr><td>${order.orderNumber}</td><td>${order.user.firstName}</td><td>₹${order.totalAmount}</td><td>${order.status}</td><td><c:choose><c:when test="${order.status == 'DELIVERED' || order.status == 'CANCELLED'}"><span class="seller-status">${order.status}</span></c:when><c:otherwise><form action="<c:url value='/bookstore/seller/updateOrderStatus'/>" method="post"><input type="hidden" name="orderId" value="${order.id}"><select name="status"><option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>PENDING</option><option value="IN_PROCESS" ${order.status == 'IN_PROCESS' ? 'selected' : ''}>IN PROCESS</option><option value="DISPATCHED" ${order.status == 'DISPATCHED' ? 'selected' : ''}>DISPATCHED</option><option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option></select><button class="btn small primary" type="submit">Update</button></form></c:otherwise></c:choose></td></tr></c:forEach>
        <c:if test="${empty receivedOrders}"><tr><td colspan="5">No orders received yet.</td></tr></c:if></tbody></table>
    </section>
</main>
<jsp:include page="includes/footer.jsp"/>
