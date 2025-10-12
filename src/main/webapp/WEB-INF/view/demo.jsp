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

            <!-- New Buttons to Switch Views -->
            <div class="book-action-buttons">
                <button class="btn primary" onclick="showSection('add')">➕ Add New Book</button>
                <button class="btn edit" onclick="showSection('update')">✏️ Update Book</button>
                <button class="btn danger" onclick="showSection('delete')">🗑️ Delete Book</button>
            </div>

            <!-- Book Form Section -->
            <div id="bookFormSection" style="display: block;">
                <form action="save" method="post" enctype="multipart/form-data" class="admin-form">
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
                        </div>
                    </div>
                </form>
            </div>

            <!-- Book List Section for Update/Delete -->
            <div id="bookListSection" style="display: none;">
                <h4>Book Inventory</h4>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Cover</th>
                            <th>ISBN</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="book" items="${books}">
                            <tr>
                                <td>
                                    <img src="<c:url value='/uploads/${book.image}'/>" alt="Cover" style="width:50px;height:auto;">
                                </td>
                                <td>${book.isbn}</td>
                                <td>${book.title}</td>
                                <td>${book.author}</td>
                                <td>
                                    <a href="admin/editBook/${book.id}" class="btn small edit">Update</a>
                                    <a href="admin/deleteBook/${book.id}" class="btn small danger" onclick="return confirm('Are you sure?')">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
    

        <h4>Book Inventory List</h4>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th><th>Title</th><th>Author</th><th>Price (₹)</th><th>Stock</th><th>Available</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="book" items="${books}">
                    <tr>
                        <td>${book.id}</td>
                        <td>${book.title}</td>
                        <td>${book.author}</td>
                        <td>₹${book.price}</td>
                        <td>${book.stock}</td>
                        <td><span class="status-badge ${book.available ? 'status-active' : 'status-inactive'}">${book.available ? 'Yes' : 'No'}</span></td>
                        <td>
                            <a href="admin/editBook/${book.id}" class="btn small edit">Edit</a>
                            <a href="admin/deleteBook/${book.id}" class="btn small danger">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
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
    // Simple JavaScript for Tab Switching

    function showSection(action) {
        const formSection = document.getElementById('bookFormSection');
        const listSection = document.getElementById('bookListSection');

        if (action === 'add') {
            formSection.style.display = 'block';
            listSection.style.display = 'none';
        } else {
            formSection.style.display = 'none';
            listSection.style.display = 'block';
        }
    }
    function openTab(evt, tabName) {
        // Declare all variables
        var i, tabcontent, tablinks;

        // Get all elements with class="tab-content" and hide them
        tabcontent = document.getElementsByClassName("tab-content");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
            tabcontent[i].classList.remove("active");
        }

        // Get all elements with class="tab-link" and remove the class "active"
        tablinks = document.getElementsByClassName("tab-link");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }

        // Show the current tab, and add an "active" class to the button that opened the tab
        document.getElementById(tabName).style.display = "block";
        document.getElementById(tabName).classList.add("active");
        evt.currentTarget.className += " active";
    }

    // Set default tab on load
    document.addEventListener("DOMContentLoaded", function() {
        // Ensure the first tab's content is visible on load if not handled by CSS/JSP class
        var defaultTab = document.getElementById("Books");
        if (defaultTab) {
            defaultTab.style.display = "block";
        }
    });
</script>