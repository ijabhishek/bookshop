<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Admin Panel"/>
    <jsp:param name="active" value="admin"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
<link rel="stylesheet" href="<c:url value='/css/account.css'/>">

<div class="admin-container">
    <h2>📊 Admin Dashboard</h2>

    <c:if test="${not empty message}">
        <div class="flash-message">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="flash-message error">${error}</div>
    </c:if>

    <div class="dashboard-summary">
        <div class="summary-card">Total Books: <strong>${totalBooks}</strong></div>
        <div class="summary-card">Total Orders: <strong>${totalOrders}</strong></div>
        <div class="summary-card">Revenue: <strong>₹${totalRevenue}</strong></div>
        <div class="summary-card">Users: <strong>${totalUsers}</strong></div>
    </div>

    <%-- 📈 Sales analytics: order status breakdown + best sellers --%>
    <div class="admin-form" style="margin-bottom: 30px;">
        <div class="form-grid">
            <div class="form-group-section">
                <h4>Orders by Status</h4>
                <table class="admin-table">
                    <thead><tr><th>Status</th><th>Count</th></tr></thead>
                    <tbody>
                        <c:forEach var="entry" items="${stats.ordersByStatus}">
                            <tr>
                                <td><span class="status-badge status-${entry.key.toString().toLowerCase()}">${entry.key}</span></td>
                                <td>${entry.value}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <p class="order-meta">Revenue (last 30 days): ₹<fmt:formatNumber value="${stats.revenueLast30Days}" type="number" minFractionDigits="2"/></p>
            </div>
            <div class="form-group-section">
                <h4>Top Selling Books</h4>
                <table class="admin-table">
                    <thead><tr><th>Book</th><th>Units Sold</th></tr></thead>
                    <tbody>
                        <c:forEach var="b" items="${stats.topSellingBooks}">
                            <tr><td>${b.title}</td><td>${b.quantitySold}</td></tr>
                        </c:forEach>
                        <c:if test="${empty stats.topSellingBooks}">
                            <tr><td colspan="2">No sales yet.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="tab-nav">
        <button class="tab-link active" onclick="openTab(event, 'Books')">📚 Manage Books</button>
        <button class="tab-link" onclick="openTab(event, 'Orders')">📦 Manage Orders</button>
        <button class="tab-link" onclick="openTab(event, 'Users')">👥 Manage Users</button>
        <button class="tab-link" onclick="openTab(event, 'Discounts')">💸 Manage Discounts</button>
        <button class="tab-link" onclick="openTab(event, 'Writers')">✍️ Writers</button>
        <button class="tab-link" onclick="openTab(event, 'Feedback')">💬 Feedback Received</button>
        <button class="tab-link" onclick="openTab(event, 'BookRequests')">📖 Book Requests</button>
    </div>

    <div id="Books" class="tab-content active">
        <h3>Manage Books</h3>

        <!-- Action Buttons -->
        <div class="book-action-buttons">
            <button class="btn primary" onclick="showSection('add')">➕ Add New Book</button>
            <button class="btn edit" onclick="toggleSection('bookListSection', this)" data-show-label="📋 View Books" data-hide-label="🔽 Hide Books">📋 View Books</button>

        </div>

        <!-- Book Form Section -->
        <div id="bookFormSection" style="display: none;">
            <form action="<c:url value='/bookstore/admin/save'/>" method="post" enctype="multipart/form-data" class="admin-form" id="bookForm">
                <div class="form-grid">
                    <div class="form-group-section">
                        <h4>Book Information</h4>
                        <div class="form-group">
                            <label for="isbn">ISBN</label>
                            <input type="text" id="isbn" name="isbn" required placeholder="e.g. 9781234567890">
                        </div>
                        <div class="form-group">
                            <label for="title">Book Title</label>
                            <input type="text" id="title" name="title" required placeholder="Enter book title">
                        </div>
                        <div class="form-group">
                            <label for="authorId">Author</label>
                            <select id="authorId" name="authorId" required onchange="toggleAdminOtherWriter(this)">
                                <option value="">-- Select Author --</option>
                                <c:forEach var="author" items="${authors}">
                                    <option value="${author.id}">${author.authorName}</option>
                                </c:forEach>
                                <option value="0">Other</option>
                            </select>
                            <div id="adminOtherWriter" style="display:none;margin-top:10px;">
                                <input type="text" name="otherAuthorName" placeholder="Enter writer name">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="category">Category</label>
                            <select id="category" name="category" required>
                                <option value="">-- Select Category --</option>
                                <option value="FANTASY">Fantasy</option>
                                <option value="MYSTERY">Mystery</option>
                                <option value="THRILLER">Thriller</option>
                                <option value="HISTORY">History</option>
                                <option value="TECHNOLOGY">Technology</option>
                                <option value="ROMANCE">Romance</option>
                                <option value="PHILOSOPHY">Philosophy</option>
                                <option value="SCIENCE">Science</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group-section">
                        <h4>Pricing & Stock</h4>
                        <div class="form-group">
                            <label for="sellingPrice">Selling Price (₹)</label>
                            <input type="number" id="sellingPrice" name="sellingPrice" required placeholder="Enter selling price">
                        </div>
                        <div class="form-group">
                            <label for="discountedPrice">Discounted Price (₹)</label>
                            <input type="number" id="discountedPrice" name="discountedPrice" placeholder="Optional discounted price">
                        </div>
                        <div class="form-group">
                            <label for="stock">Stock Quantity</label>
                            <input type="number" id="stock" name="stock" required placeholder="Current stock">
                        </div>
                        <div class="form-group">
                            <label for="publishedYear">Published Date</label>
                            <input type="date" id="publishedYear" name="publishedYear" required>
                        </div>
                    </div>
                </div>

                <div class="form-group form-group-full">
                    <label for="bookDescription">Book Description</label>
                    <textarea id="bookDescription" name="bookDescription" rows="5" placeholder="Write a short description..." required></textarea>
                </div>

                <div class="form-footer">
                    <div class="form-group">
                        <label for="image">Book Cover</label>
                        <input type="file" id="image" name="image" accept="image/*" required>
                    </div>
                    <div class="form-group form-group-checkbox">
                        <input type="checkbox" id="bookAvailable" name="bookAvailable" value="true" checked>
                        <label for="bookAvailable">Available for Sale</label>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn primary">💾 Save New Book</button>
                        <button type="button" class="btn secondary" onclick="showSection('list')">Cancel</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Book List Section -->
        <div id="bookListSection" style="display: none;">
            <h4>Book Inventory</h4>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Cover</th>
                        <th>ISBN</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Price (₹)</th>
                        <th>Stock</th>
                        <th>Available</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="book" items="${books}">
                        <tr>
                            <td>
                                <a href="/bookstore/bookdetails?bookId=${book.bookId}" class="book-link">
                                    <img src="${book.imageUrl}" alt="Cover" style="width:50px;height:auto;">
                                </a>
                                   
                            </td>
        
                            <td>${book.isbn}</td>
                            <td>${book.title}</td>
                            <td>${book.authorName}</td>
                            <td>₹${book.discountedPrice}</td>
                            <td>${book.stock}</td>
                            <td><span class="status-badge ${book.bookAvailable ? 'status-active' : 'status-inactive'}">${book.bookAvailable ? 'Yes' : 'No'}</span></td>
                            <td>
                                <a href="admin/editBook/${book.bookId}" class="btn small edit">Edit</a>
                                <a href="admin/deleteBook/${book.bookId}" class="btn small danger" onclick="return confirm('Are you sure you want to delete this book?')">Delete</a>
                            </td>
                        </tr>

                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div id="Orders" class="tab-content">
        <h3>Order Processing</h3>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Order #</th><th>User</th><th>Total (₹)</th><th>Date</th><th>Status</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.orderNumber}</td>
                        <td>${order.user.firstName} (${order.user.userId})</td>
                        <td>₹<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2"/></td>
                        <td><fmt:formatDate value="${order.orderDateAsDate}" pattern="dd MMM yyyy"/></td>
                        <td>
                            <c:choose><c:when test="${order.status == 'DELIVERED' || order.status == 'CANCELLED'}"><span class="status-badge status-${order.status.toString().toLowerCase()}">${order.status}</span></c:when><c:otherwise>
                            <form action="<c:url value='/bookstore/admin/updateOrder'/>" method="post" class="order-update-form">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <select name="status" class="status-select status-${order.status.toString().toLowerCase()}">
                                    <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                    <option value="IN_PROCESS" ${order.status == 'IN_PROCESS' ? 'selected' : ''}>IN PROCESS</option>
                                    <option value="DISPATCHED" ${order.status == 'DISPATCHED' ? 'selected' : ''}>DISPATCHED</option>
                                    <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                    <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                </select>
                                <button type="submit" class="btn small primary update-btn">Update</button>
                            </form>
                            </c:otherwise></c:choose>
                        </td>
                        <td>
                            <a href="admin/viewOrder/${order.id}" class="btn small secondary">View Details</a>
                            <a href="${pageContext.request.contextPath}/bookstore/order/${order.orderNumber}/invoice" class="btn small secondary">Invoice</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr><td colspan="6">No orders yet.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <div id="Users" class="tab-content">
        <h3>User Accounts</h3>
        <form action="<c:url value='/bookstore/admin/saveUser'/>" method="post" class="admin-form" style="margin-bottom:20px;">
            <h4>Add or Edit User</h4>
            <input name="userId" placeholder="User ID" required>
            <input name="firstName" placeholder="Full name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input name="phoneNumber" placeholder="Phone number" required>
            <input name="address" placeholder="Address" required>
            <input type="password" name="password" placeholder="Password (required for new user)">
            <select name="role"><option value="ADMIN">Admin</option><option value="SELLER">Seller</option></select>
            <button type="submit" class="btn primary">Save User</button>
            <p class="info-text">To edit a user, enter the same User ID and update the details.</p>
        </form>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>User ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>${u.userId}</td>
                        <td>${u.firstName}</td>
                        <td>${u.email}</td>
                        <td>${u.phoneNumber}</td>
                        <td><span class="role-badge role-${empty u.role ? 'user' : u.role.toLowerCase()}">${empty u.role ? 'USER' : u.role}</span></td>
                        <td>
                            <form action="<c:url value='/bookstore/admin/deleteUser'/>" method="post" onsubmit="return confirm('Delete user ${u.userId}? This also removes their orders and unlinks their seller books.');">
                                <input type="hidden" name="userId" value="${u.userId}">
                                <button type="submit" class="btn small danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty users}">
                    <tr><td colspan="6">No registered users yet.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>




    <div id="Writers" class="tab-content">
        <h3>Writer Management</h3>
        <div class="admin-form">
            <h4>Add New Writer</h4>
            <form action="<c:url value='/bookstore/admin/author/save'/>" method="post" enctype="multipart/form-data">
                <div class="form-grid">
                    <div class="form-group-section">
                        <div class="form-group"><label>Writer Name</label><input type="text" name="authorName" required></div>
                        <div class="form-group"><label>Date of Birth</label><input type="date" name="birthDate"></div>
                        <div class="form-group"><label>Birth Place</label><input type="text" name="birthPlace" placeholder="City, Country"></div>
                    </div>
                    <div class="form-group-section">
                        <div class="form-group"><label>Book Category</label><select name="category" required><c:forEach var="cat" items="${categories}"><option value="${cat}">${cat}</option></c:forEach></select></div>
                        <div class="form-group"><label>Photo</label><input type="file" name="authorImage" accept="image/*"></div>
                    </div>
                </div>
                <div class="form-group form-group-full"><label>Biography</label><textarea name="biography" rows="5"></textarea></div>
                <button type="submit" class="btn primary">Save Writer</button>
            </form>
        </div>

        <h4>Writer List</h4>
        <p class="info-text">Click Edit to update a writer's name, photo, date of birth, birth place, biography or category.</p>
        <table class="admin-table">
            <thead><tr><th>Photo</th><th>Name</th><th>DOB</th><th>Birth Place</th><th>Category</th><th>Biography</th><th>Action</th></tr></thead>
            <tbody>
                <c:forEach var="author" items="${authors}">
                    <tr>
                        <td><c:if test="${not empty author.imageUrl}"><img src="${author.imageUrl}" alt="Writer" style="width:45px;height:55px;object-fit:cover;"></c:if></td>
                        <td>${author.authorName}</td>
                        <td>${author.birthDate}</td>
                        <td>${author.birthPlace}</td>
                        <td>${author.category}</td>
                        <td>${author.biography}</td>
                        <td><button type="button" class="btn small edit" onclick="toggleWriterEdit('${author.id}')">Edit</button></td>
                    </tr>
                    <tr id="writer-edit-${author.id}" style="display:none;">
                        <td colspan="7">
                            <form action="<c:url value='/bookstore/admin/author/update'/>" method="post" enctype="multipart/form-data" class="admin-form">
                                <input type="hidden" name="id" value="${author.id}">
                                <div class="form-grid">
                                    <div class="form-group-section">
                                        <div class="form-group"><label>Writer Name</label><input type="text" name="authorName" value="${author.authorName}" required></div>
                                        <div class="form-group"><label>Date of Birth</label><input type="date" name="birthDate" value="${author.birthDate}"></div>
                                        <div class="form-group"><label>Birth Place</label><input type="text" name="birthPlace" value="${author.birthPlace}"></div>
                                    </div>
                                    <div class="form-group-section">
                                        <div class="form-group"><label>Book Category</label><select name="category" required>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat}" ${author.category == cat ? 'selected' : ''}>${cat}</option>
                                            </c:forEach>
                                        </select></div>
                                        <div class="form-group"><label>Replace Photo (optional)</label><input type="file" name="authorImage" accept="image/*"></div>
                                    </div>
                                </div>
                                <div class="form-group"><label>Biography</label><textarea name="biography" rows="5">${author.biography}</textarea></div>
                                <button type="submit" class="btn primary">Save Changes</button>
                                <button type="button" class="btn" onclick="toggleWriterEdit('${author.id}')">Cancel</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty authors}"><tr><td colspan="7">No writers yet.</td></tr></c:if>
            </tbody>
        </table>
    </div>

    <div id="Requests" class="tab-content">
        <h3>Requested Books</h3>
        <table class="admin-table">
            <thead><tr><th>Book</th><th>Author</th><th>Customer</th><th>Reason</th><th>Requested</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
                <c:forEach var="r" items="${bookRequests}">
                    <tr>
                        <td>${r.title}</td><td>${r.author}</td>
                        <td>${r.requester.firstName} (${r.requester.userId})</td>
                        <td>${r.description}</td>
                        <td><fmt:formatDate value="${r.requestedAtAsDate}" pattern="dd MMM yyyy"/></td>
                        <td>${r.status}</td>
                        <td>
                            <form action="<c:url value='/bookstore/admin/requestStatus'/>" method="post">
                                <input type="hidden" name="requestId" value="${r.id}">
                                <select name="status">
                                    <option value="PENDING" ${r.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                    <option value="FULFILLED" ${r.status == 'FULFILLED' ? 'selected' : ''}>FULFILLED</option>
                                    <option value="REJECTED" ${r.status == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
                                </select>
                                <button class="btn small primary">Update</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty bookRequests}"><tr><td colspan="7">No book requests.</td></tr></c:if>
            </tbody>
        </table>
    </div>


    <div id="Feedback" class="tab-content">
        <h3>💬 Feedback Received</h3>
        <p class="info-text">Feedback submitted by visitors and logged-in users.</p>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Feedback</th>
                    <th>Submitted</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="feedback" items="${feedbacks}">
                    <tr>
                        <td>${feedback.id}</td>
                        <td><strong>${feedback.name}</strong></td>
                        <td>${feedback.message}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty feedback.submittedAt}">
                                    ${feedback.submittedAt}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty feedbacks}">
                    <tr><td colspan="4">No feedback received yet.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
    <section class="admin-section">
        <div class="section-heading"><div><h2><i class="fas fa-bell"></i> Requested Books</h2><p>Customer requests you may want to upload to your catalogue.</p></div></div>
        <div class="admin-table-wrap"><table class="admin-table"><thead><tr><th>Book</th><th>Requested Author</th><th>Customer</th><th>Reason</th><th>Status</th></tr></thead><tbody><c:forEach var="r" items="${bookRequests}"><tr><td>${r.title}</td><td>${r.author}</td><td>${r.requester.firstName}<br><span class="muted-text">${r.requester.userId}</span></td><td>${r.description}</td><td><span class="seller-status">${r.status}</span></td></tr></c:forEach><c:if test="${empty bookRequests}"><tr><td colspan="5" class="table-empty">No pending book requests.</td></tr></c:if></tbody></table></div>
      </section>

    <div id="Discounts" class="tab-content">
        <h3>Global Discount Management</h3>
        <form action="<c:url value='/bookstore/admin/discount'/>" method="post" class="admin-form form-inline">
            <div class="form-group form-inline-input">
                <label for="discount">Apply Global Discount (%):</label>
                <input type="number" id="discount" name="discount" min="0" max="90" required placeholder="0 - 90" />
            </div>
            <div class="form-actions">
                <button type="submit" class="btn primary">Apply Discount</button>
            </div>
        </form>
        <p class="info-text">⚠️ **Warning:** This will update the discounted price for all books. Use with caution.</p>
    </div>
</div>

<jsp:include page="includes/footer.jsp"/>

<script>
    function openTab(evt, tabName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tab-content");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
            tabcontent[i].classList.remove("active");
        }
        tablinks = document.getElementsByClassName("tab-link");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        document.getElementById(tabName).classList.add("active");
        evt.currentTarget.className += " active";

        // Reset to book list when switching to Books tab
        if (tabName === 'Books') {
            showSection('list');
        }
    }
    function toggleSection(sectionId, button) {
    const section = document.getElementById(sectionId);
    const isVisible = section.style.display === 'block';

    if (isVisible) {
        section.style.display = 'none';
        if (button) button.textContent = button.dataset.showLabel;
    } else {
        section.style.display = 'block';
        if (button) button.textContent = button.dataset.hideLabel;
    }
}

    function showSection(section) {
        const formSection = document.getElementById('bookFormSection');
        const listSection = document.getElementById('bookListSection');
        const form = document.getElementById('bookForm');

        if (section === 'add') {
            formSection.style.display = 'block';
            listSection.style.display = 'none';
            form.reset(); // Clear form for new book
        } else {
            formSection.style.display = 'none';
            listSection.style.display = 'block';
        }
    }

    function toggleAdminOtherWriter(select) {
        const box = document.getElementById('adminOtherWriter');
        const input = box ? box.querySelector('input[name="otherAuthorName"]') : null;
        const isOther = select.value === '0';
        if (box) box.style.display = isOther ? 'block' : 'none';
        if (input) input.required = isOther;
    }

    // document.addEventListener("DOMContentLoaded", function() {
    //     document.getElementById("Books").style.display = "block";
    //     showSection('list'); // Show book list by default
    // });
    function toggleWriterEdit(id) {
        const row = document.getElementById('writer-edit-' + id);
        row.style.display = row.style.display === 'none' || row.style.display === '' ? 'table-row' : 'none';
    }
</script>