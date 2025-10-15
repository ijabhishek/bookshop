<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Admin Panel"/>
    <jsp:param name="active" value="admin"/>
</jsp:include>

<link rel="stylesheet" href="<c:url value='/css/admin.css'/>">

<div class="admin-container">
    <h2>📊 Admin Dashboard</h2>

    <div class="dashboard-summary">
        <div class="summary-card">Total Books: <strong>${totalBooks}</strong></div>
        <div class="summary-card">Total Orders: <strong>${totalOrders}</strong></div>
        <div class="summary-card">Revenue: <strong>₹${totalRevenue}</strong></div>
        <div class="summary-card">Users: <strong>${totalUsers}</strong></div>
    </div>

    <div class="tab-nav">
        <button class="tab-link active" onclick="openTab(event, 'Books')">📚 Manage Books</button>
        <button class="tab-link" onclick="openTab(event, 'Orders')">📦 Manage Orders</button>
        <button class="tab-link" onclick="openTab(event, 'Users')">👥 Manage Users</button>
        <button class="tab-link" onclick="openTab(event, 'Discounts')">💸 Manage Discounts</button>
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
            <form action="admin/save" method="post" enctype="multipart/form-data" class="admin-form" id="bookForm">
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
                            <select id="authorId" name="authorId" required>
                                <option value="">-- Select Author --</option>
                                <c:forEach var="author" items="${authors}">
                                    <option value="${author.id}">${author.authorName}</option>
                                </c:forEach>
                            </select>
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
                    <th>Order ID</th><th>User</th><th>Total (₹)</th><th>Date</th><th>Status</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.id}</td>
                        <td>${order.user}</td>
                        <td>₹${order.total}</td>
                        <td>${order.date}</td>
                        <td>
                            <form action="admin/updateOrder" method="post" class="order-update-form">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <select name="status" class="status-select status-${order.status.toLowerCase()}">
                                    <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                    <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                                    <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                    <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                </select>
                                <button type="submit" class="btn small primary update-btn">Update</button>
                            </form>
                        </td>
                        <td>
                            <a href="admin/viewOrder/${order.id}" class="btn small secondary">View Details</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="Users" class="tab-content">
        <h3>User Accounts</h3>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>User ID</th><th>Username</th><th>Email</th><th>Role</th><th>Created At</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td><span class="role-badge role-${user.role.toLowerCase()}">${user.role}</span></td>
                        <td>${user.createdAt}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div id="Discounts" class="tab-content">
        <h3>Global Discount Management</h3>
        <form action="admin/discount" method="post" class="admin-form form-inline">
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

    // document.addEventListener("DOMContentLoaded", function() {
    //     document.getElementById("Books").style.display = "block";
    //     showSection('list'); // Show book list by default
    // });
</script>