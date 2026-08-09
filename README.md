# 📚 BookShop – Online Bookstore Management System

BookShop is a full-stack web-based **Online Bookstore Management System** built with **Java, Spring Boot, Spring Security, Spring Data JPA, JSP, PostgreSQL, HTML, CSS, and JavaScript**.

The application supports multiple user roles including **Purchaser, Seller, Sales, and Administrator**. Each role has its own features, permissions, and dashboard functionality.

---

## ✨ Features

### 👤 Multi-Role Authentication

The system supports the following user roles:

| Role                 | Description                                                                                                    |
| -------------------- | -------------------------------------------------------------------------------------------------------------- |
| **Purchaser / User** | Browse books, search books, add books to cart, place orders, cancel orders, submit feedback, and request books |
| **Seller**           | Upload and manage books, add writers, and view received orders                                                 |
| **Sales**            | View and manage sales-related orders                                                                           |
| **Admin**            | Manage users, books, writers, orders, book requests, and system information                                    |

The application uses **Spring Security** for authentication and authorization.

After successful login, users are automatically redirected based on their role:

```text
ADMIN  → Admin Dashboard
SELLER → Seller Dashboard
SALES  → Sales Orders Dashboard
USER   → Bookstore Home Page
```

---

# 🔐 User Roles and Permissions

## 🛒 Purchaser

Purchasers can:

* Browse all available books
* Search books by name
* Search books by category
* View book details
* Add books to cart
* Remove books from cart
* Update cart quantities
* Place orders
* View their order history
* Cancel eligible orders
* Submit feedback
* Submit book requests
* View writer information

When an order is cancelled:

* The order status changes to `CANCELED`
* The order remains in the database for order history
* The cancelled status is visible to the administrator
* Book stock is restored

---

## 📖 Seller

Sellers have access to a dedicated seller dashboard.

Seller features include:

* Upload new books
* Add book cover/photo
* Set actual price
* Set discounted price
* Set stock quantity
* Select a book category
* Select an existing writer
* Add a new writer
* Use the **Other Writer** option for a free-form writer name
* View uploaded books
* View orders received for their books
* View relevant book requests
* Manage writer information

Seller accounts are automatically redirected to:

```text
/bookstore/seller
```

after successful login.

---

## ✍️ Writer Management

Both **Seller** and **Admin** users can add writers.

A writer can contain the following information:

* Writer name
* Date of birth
* Birth place
* Biography
* Photo
* Book category

When uploading a book, the writer appears in a dropdown list.

The upload form also provides:

```text
Other Writer
```

If the required writer is not available in the dropdown, the user can select **Other Writer** and enter the writer's name manually.

The system creates and stores the new writer so that the writer can be reused for future books.

---

## 📊 Admin

The administrator has access to a complete management dashboard.

Admin features include:

### 📚 Book Management

* View all books
* View book prices
* View actual and discounted prices
* View available stock
* Manage books
* Upload books
* Assign categories
* Assign writers

### 👥 User Management

* View all registered users
* View user details
* View user roles
* Delete users

The system prevents an administrator from accidentally deleting their own currently logged-in account.

### 📦 Order Management

The administrator can view:

* All placed orders
* Purchaser information
* Book information
* Order status
* Cancelled orders

Cancelled orders are displayed with:

```text
CANCELED
```

instead of being permanently removed from the order history.

### ✍️ Writer Management

Administrators can:

* Add writers
* View writers
* Add writer photos
* Add biography
* Add date of birth
* Add birth place
* Assign writer categories

### 📩 Book Request Management

Administrators can view book requests submitted by users.

A book request may include:

* Requested book title
* Category
* User information
* Request status

The administrator can manage the request status, such as:

```text
PENDING
FULFILLED
REJECTED
```

---

## 💼 Sales

Sales users have access to sales-related order information.

Sales users are redirected to:

```text
/bookstore/sales/orders
```

after login.

The Sales role can view and manage the orders permitted by the application security configuration.

---

# 🛍️ Book Features

Each book can contain:

* Book name
* Book description
* Book photo/cover
* Actual price
* Discounted price
* Stock quantity
* Book category
* Writer/Author
* Seller information

The application validates stock before allowing users to place an order.

---

# 🗂️ Book Categories

Books can be organized by category.

Example categories include:

* Fantasy
* Mystery
* Thriller
* History
* Technology
* Romance
* Philosophy
* Science

The category navigation is available in the navigation bar.

When a user selects a category, the system displays books belonging to that category, similar to book name searching.

Example:

```text
Fantasy
   ↓
Display all Fantasy books
```

---

# 🛒 Shopping Cart

Purchasers can manage their shopping cart.

Cart features include:

* Add a book to cart
* View cart
* View cart item count
* Update quantity
* Remove books from cart
* Validate stock availability

The application includes a dedicated Cart navigation option for purchaser accounts.

The Add to Cart functionality uses the application's cart endpoints and provides error handling for:

* Invalid requests
* Out-of-stock books
* Quantity errors

---

# 📦 Order Management

The order process includes:

```text
Select Book
      ↓
Add to Cart
      ↓
Checkout
      ↓
Place Order
      ↓
Order Created
```

Purchasers can view their orders from **My Orders**.

---

## ❌ Order Cancellation

When a purchaser cancels an order:

```text
Order
   ↓
Status changes to CANCELED
   ↓
Stock is restored
   ↓
Cancelled order remains in database
   ↓
Admin can see cancelled order
```

This preserves order history and allows administrators to track cancellations.

---

# 📩 Book Request Feature

If a book is not available on the website, a user can submit a book request.

The request is stored in the database and can be viewed by:

* Admin
* Seller

Book requests include appropriate validation and error handling.

After successful submission, the user is redirected correctly instead of receiving a **404 Not Found** page.

---

# 💬 Feedback

The feedback feature is available only to purchasers.

Purchasers can submit feedback through the application.

Feedback submission is handled by a dedicated endpoint and redirects the user correctly after submission.

The Feedback option is not displayed on:

* Admin pages
* Seller pages
* Sales pages

---

# 🔒 Security

The application uses **Spring Security** for authentication and authorization.

## Role-Based Access Control

| URL/Feature      | USER |  SELLER |  SALES  |  ADMIN  |
| ---------------- | :--: | :-----: | :-----: | :-----: |
| Browse Books     |   ✅  | Limited | Limited | Limited |
| Shopping Cart    |   ✅  |    ❌    |    ❌    |    ❌    |
| My Orders        |   ✅  |    ❌    |    ❌    |    ❌    |
| Cancel Order     |   ✅  |    ❌    |    ❌    |    ❌    |
| Submit Feedback  |   ✅  |    ❌    |    ❌    |    ❌    |
| Request Book     |   ✅  |    ✅    |    ❌    |    ❌    |
| Seller Dashboard |   ❌  |    ✅    |    ❌    |    ✅    |
| Upload Book      |   ❌  |    ✅    |    ❌    |    ✅    |
| Manage Writers   |   ❌  |    ✅    |    ❌    |    ✅    |
| Sales Orders     |   ❌  |    ❌    |    ✅    |    ✅    |
| Admin Dashboard  |   ❌  |    ❌    |    ❌    |    ✅    |
| Delete Users     |   ❌  |    ❌    |    ❌    |    ✅    |

---

# 🔑 Login Authentication

The application uses Spring Security's `DaoAuthenticationProvider`.

Authentication flow:

```text
Login Form
    ↓
/bookstore/loginUser
    ↓
BookUserDetailsService
    ↓
BookUserRepo
    ↓
UserPrincipal
    ↓
BCrypt Password Verification
    ↓
Role Detection
    ↓
Redirect to Appropriate Dashboard
```

The login form uses:

```text
User ID
Password
Login As:
- Purchaser
- Seller
- Sales
- Admin
```

> **Note:** The selected login type does not grant permissions by itself. The actual role is verified from the database.

---

# 🔐 Password Security

Passwords are protected using:

```text
BCryptPasswordEncoder
```

The application configuration uses BCrypt with strength:

```java
new BCryptPasswordEncoder(12)
```

Passwords stored in the database should therefore be BCrypt hashes.

Passwords should **not** be stored as plain text.

Example:

```text
Correct:
$2a$12$..................................................

Incorrect:
password
123456
admin123
```

---

# ⚠️ Login Error Handling

If a user enters an invalid User ID or Password, the login page displays:

```text
Incorrect User ID or Password.
```

instead of silently returning to the login page.

---

# 🏗️ Technology Stack

## Backend

* Java
* Spring Boot
* Spring MVC
* Spring Security
* Spring Data JPA
* Hibernate
* Maven

## Frontend

* JSP
* JSTL
* HTML5
* CSS3
* JavaScript

## Database

* PostgreSQL

## Security

* Spring Security
* BCrypt Password Encryption
* Role-Based Authorization

---

# 📁 Project Structure

```text
BookShop
│
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── bookshop
│   │   │           │
│   │   │           ├── configration
│   │   │           │   └── SecurityConfig.java
│   │   │           │
│   │   │           ├── controller
│   │   │           │   ├── BookController.java
│   │   │           │   ├── AdminController.java
│   │   │           │   └── ...
│   │   │           │
│   │   │           ├── model
│   │   │           │   ├── User.java
│   │   │           │   ├── UserPrincipal.java
│   │   │           │   ├── Book.java
│   │   │           │   ├── Author.java
│   │   │           │   ├── Order.java
│   │   │           │   └── BookRequest.java
│   │   │           │
│   │   │           ├── repository
│   │   │           │   ├── BookUserRepo.java
│   │   │           │   ├── BookRepository.java
│   │   │           │   └── ...
│   │   │           │
│   │   │           └── service
│   │   │               ├── BookUserDetailsService.java
│   │   │               └── ...
│   │   │
│   │   ├── resources
│   │   │   ├── application.properties
│   │   │   └── static
│   │   │       ├── css
│   │   │       ├── js
│   │   │       └── images
│   │   │
│   │   └── webapp
│   │       └── WEB-INF
│   │           └── view
│   │               ├── home.jsp
│   │               ├── login.jsp
│   │               ├── seller.jsp
│   │               ├── admin.jsp
│   │               └── ...
│
├── sql
│   ├── schema_updates.sql
│   └── create_admin.sql
│
├── pom.xml
└── README.md
```

> Some file names may differ slightly depending on the version of the project.

---

# 🗄️ Database Setup

The application uses PostgreSQL.

## 1. Create the Database

Open PostgreSQL and create a database:

```sql
CREATE DATABASE BookStoreApp;
```

## 2. Configure Database Connection

Open:

```text
src/main/resources/application.properties
```

Configure your PostgreSQL details:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/BookStoreApp
spring.datasource.username=YOUR_POSTGRES_USERNAME
spring.datasource.password=YOUR_POSTGRES_PASSWORD

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

Replace:

```text
YOUR_POSTGRES_USERNAME
YOUR_POSTGRES_PASSWORD
```

with your PostgreSQL credentials.

---

# 👑 Creating an Admin Account

An administrator can be created directly in the database.

The application uses BCrypt password encryption, so the password must be stored as a BCrypt hash.

The project may include:

```text
sql/create_admin.sql
```

You can run that script in PostgreSQL.

Example administrator:

```text
User ID: admin
Role: ADMIN
```

Before using a password, ensure that the stored password is BCrypt encoded.

You can generate a BCrypt password hash in Java:

```java
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);

System.out.println(encoder.encode("password"));
```

Then update the administrator:

```sql
UPDATE users
SET password = 'PASTE_YOUR_BCRYPT_HASH_HERE',
    role = 'ADMIN'
WHERE user_id = 'admin';
```

Verify the administrator:

```sql
SELECT user_id, role
FROM users
WHERE user_id = 'admin';
```

Expected result:

```text
user_id | role
--------|------
admin   | ADMIN
```

---

# 🚀 Running the Application

## Prerequisites

Install:

* Java JDK
* Maven
* PostgreSQL
* Eclipse / IntelliJ IDEA / VS Code (optional)

## Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Navigate into the project:

```bash
cd BookShop
```

## Configure the Database

Update:

```text
src/main/resources/application.properties
```

with your PostgreSQL configuration.

## Run the Application

Using Maven:

```bash
mvn spring-boot:run
```

Or run the main Spring Boot application class directly from your IDE.

After the application starts, open:

```text
http://localhost:8080/bookstore/home
```

> The exact port or context path may differ depending on your `application.properties` configuration.

---

# 🧪 Testing Different Roles

You can test the application with users having the following roles:

```text
USER
SELLER
SALES
ADMIN
```

Example database query:

```sql
SELECT user_id, role
FROM users;
```

Make sure the role values are correct:

```text
USER
SELLER
SALES
ADMIN
```

The application converts roles into Spring Security authorities:

```text
USER   → ROLE_USER
SELLER → ROLE_SELLER
SALES  → ROLE_SALES
ADMIN  → ROLE_ADMIN
```

---

# 🔄 Authentication Redirect Flow

```text
                    ┌──────────────┐
                    │    LOGIN     │
                    └──────┬───────┘
                           │
                           ▼
                ┌────────────────────┐
                │ Verify Credentials │
                └─────────┬──────────┘
                          │
              ┌───────────┴────────────┐
              │                        │
              ▼                        ▼
        Authentication             Authentication
          Successful                 Failed
              │                        │
              ▼                        ▼
        Check User Role        Show Login Error
              │
     ┌────────┼─────────┬─────────┐
     │        │         │         │
     ▼        ▼         ▼         ▼
   USER     SELLER     SALES     ADMIN
     │        │         │         │
     ▼        ▼         ▼         ▼
   Home    Seller      Sales     Admin
           Dashboard   Orders    Dashboard
```

---

# 📈 Future Improvements

Possible future improvements include:

* Payment gateway integration
* Email notifications
* Order tracking
* Book reviews and ratings
* Wishlist
* Seller analytics
* Sales reports
* Dashboard charts
* Profile picture upload
* Forgot password functionality
* Email verification
* Pagination
* Advanced filtering
* REST API support
* Mobile-responsive improvements
* Docker support
* Cloud deployment

---

# 🐛 Troubleshooting

## Admin Login Returns to Login Page

Check the following:

### Verify the User Exists

```sql
SELECT user_id, role
FROM users
WHERE user_id = 'admin';
```

### Verify the Role

The role should be:

```text
ADMIN
```

### Verify the Password

The password must be BCrypt encoded.

The application uses:

```java
new BCryptPasswordEncoder(12)
```

Do not store the password as plain text.

---

## Seller Sees the Normal User Page

Check the seller role:

```sql
SELECT user_id, role
FROM users
WHERE user_id = 'SELLER_USER_ID';
```

The role should be:

```text
SELLER
```

After changing the role, log out and log in again.

---

## Book Request Shows Data Type Error

Check that:

* Database column types match the entity field types
* The book request relationship uses the correct user ID
* Request fields are validated before saving
* The database schema updates have been applied

---

## Page Shows 404 After Form Submission

Check:

* Controller `@PostMapping`
* Form `action`
* Application context path
* Redirect path
* Required request parameters

The form action should match the controller endpoint exactly.

---

# 🤝 Contributing

Contributions, suggestions, and improvements are welcome.

To contribute:

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Commit your changes
5. Push the branch
6. Create a Pull Request

Example:

```bash
git checkout -b feature/new-feature
git add .
git commit -m "Add new feature"
git push origin feature/new-feature
```

---

# 📝 License

This project is currently intended for educational and personal use.

You can add your preferred license, such as:

* MIT License
* Apache License 2.0
* GPL License

---

# 👨‍💻 Author

**Your Name**

Online Bookstore Management System built using Java and Spring Boot.

---

## ⭐ Support

If you found this project useful, please consider giving the repository a **star ⭐** on GitHub.

---

# 📸 Screenshots

You can add screenshots of the following pages here:

* Home Page
* Login Page
* Purchaser Dashboard
* Seller Dashboard
* Admin Dashboard
* Sales Dashboard
* Shopping Cart
* Order Page
* Writer Management
* Book Request Page

Example:

```markdown
![Home Page](screenshots/home.png)
![Login Page](screenshots/login.png)
![Seller Dashboard](screenshots/seller.png)
![Admin Dashboard](screenshots/admin.png)
```

---

## 🎯 Project Summary

BookShop is a role-based online bookstore application designed to provide a complete book purchasing and management experience.

The project includes:

```text
📚 Book Management
👤 Multi-Role Users
🔐 Secure Authentication
🛒 Shopping Cart
📦 Order Management
❌ Order Cancellation
📊 Admin Dashboard
📖 Seller Dashboard
💼 Sales Management
✍️ Writer Management
🗂️ Category Filtering
📩 Book Requests
💬 Purchaser Feedback
👥 User Management
🔒 Role-Based Security
```

The system demonstrates the use of modern Java web development concepts including **Spring Boot, Spring Security, JPA/Hibernate, PostgreSQL, JSP, authentication, authorization, database relationships, and role-based application design**.

**Thank you for checking out BookShop! 📚❤️**
