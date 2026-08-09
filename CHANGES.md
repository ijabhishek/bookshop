# BookShop — What was added / fixed

I read through the whole project (controllers, services, repos, entities, security
config, and JSPs) before changing anything. Below is exactly what's new, what was
fixed, and what you need to do to run it. I could not run `mvn compile` in this
environment (no internet access to resolve dependencies), so please build it once
locally (`mvnw spring-boot:run`) and let me know if anything doesn't compile — happy
to fix immediately.

## 1. Bugs I found and fixed (these were blocking your requested features)

| Bug | File | Fix |
|---|---|---|
| Orders were **never linked to the buyer** | `OrderService.placeOrder()` | Now reads the logged-in user from the security context and sets `order.setUser(user)` |
| Every user's role was hardcoded to `"USER"` | `UserPrincipal.getAuthorities()` | Now reads `user.getRole()` and grants `ROLE_<role>` |
| Wrong repository ID type (`User`'s id is `String`, repo declared `Integer`) | `BookUserRepo` | Changed to `JpaRepository<User, String>` |
| No real login flow — every request required an HTTP Basic popup, incompatible with your `login.jsp` | `SecurityConfig` | Switched to `formLogin()` wired to your existing `login.jsp` (`loginUser`, params `userId`/`password`), added `logout()`, added role-based URL rules |
| `admin.jsp` already had markup for an Orders/Users tab and analytics cards, but nothing populated them, and field names didn't match your entities (`order.total`, `order.date`, `user.username`, `user.createdAt` don't exist) | `admin.jsp` | Rebound every field to the real `Order`/`User` properties |

## 2. Invoice generation

- Added **OpenPDF** (`com.github.librepdf:openpdf`) to `pom.xml` — a lightweight,
  actively-maintained iText fork, no extra native dependencies.
- **New class:** `service/InvoiceService.java` — builds a PDF invoice (customer
  details, order number/date/status, line items, total).
- **New endpoint:** `GET /bookstore/order/{orderNumber}/invoice` in `OrderController`
  — streams the PDF as a download. Only the order's owner, or an ADMIN/SALES
  account, can access it.
- "Download Invoice" links added to the checkout-success page, My Orders, and the
  order-details page.

## 3. Admin analytics dashboard ("analyse purchase sales and orders received")

- **New class:** `model/dto/AdminDashboardDTO.java` — total books/orders/users,
  total revenue, revenue in the last 30 days, an orders-by-status breakdown, and
  a top-5 best-sellers list.
- **New class:** `service/AdminService.java` — runs the aggregate queries.
- **New queries** in `OrderRepository` (revenue sum, revenue since a date, top
  selling books via `OrderItem` grouping, counts by status).
- `AdminController` (was an empty stub) now serves the full dashboard at
  `GET /bookstore/admin`: book/author management (existing), the new analytics
  cards, an **Orders tab** you can filter/update status from, a **Users tab**,
  and the discount panel that the JSP already referenced but had no backing
  endpoint (`POST /bookstore/admin/discount`, `POST /bookstore/admin/updateOrder`).
- Restricted to `ROLE_ADMIN` via `SecurityConfig`.

## 4. Sales role — orders + delivery addresses

- **New class:** `controllers/SalesController.java` at `/bookstore/sales/orders`
  (`ROLE_SALES` or `ROLE_ADMIN` only) — lists every order together with the
  customer's phone number and delivery address, filterable by status, with a
  status-update action per row (`POST /bookstore/sales/updateStatus`).
- **New view:** `sales-orders.jsp`.
- Header nav shows a "Sales" link automatically for SALES/ADMIN accounts.

## 5. User login → orders + profile

- **New endpoints in `UserController`:**
  - `GET /bookstore/myorders` — the logged-in user's order history, each with
    its items, status, total, and a "View Details" / "Download Invoice" action.
  - `GET /bookstore/profile` — view profile (user ID and role are read-only;
    name/email/phone/address are editable).
  - `POST /bookstore/profile/update` — saves profile edits.
- **New views:** `my-orders.jsp`, `profile.jsp`, `order-details.jsp`.
- Header nav now shows **My Orders**, **Profile**, and a **Logout** button
  whenever someone is logged in (and just **Login** when they're not).
- New users who self-register are defaulted to `role = "USER"` (see below for
  how to make an ADMIN/SALES account — there's intentionally no self-service
  way to grant yourself elevated access).

## 6. SQL

`sql/schema_and_updates.sql` contains:
1. The **full schema** (all tables) if you're starting fresh.
2. **ALTER statements** for an existing database (role defaults/NOT NULL,
   the `orders.user_id` foreign key, indexes for the new queries).
3. How to **promote a user to ADMIN or SALES** (register normally, then run
   one `UPDATE`).
4. The raw SQL behind the analytics dashboard, in case you want to run it
   from a DB client or BI tool directly.

Note: the app already runs with `spring.jpa.hibernate.ddl-auto=update`, so
Hibernate will create/adjust these tables for you automatically — the SQL
file is there so you have it in hand, for review, or for a manual deploy.

## Files touched

**Modified:** `pom.xml`, `SecurityConfig.java`, `UserPrincipal.java`,
`BookUserRepo.java`, `BookUserDetailsService.java`, `UserController.java`,
`OrderService.java`, `OrderRepository.java`, `OrderController.java`,
`BookService.java`, `HomeWebController.java`, `admin.jsp`, `header.jsp`,
`header.css`, `checkout-success.jsp`

**New:** `AdminController.java` (was an empty stub), `SalesController.java`,
`AdminService.java`, `InvoiceService.java`, `AdminDashboardDTO.java`,
`my-orders.jsp`, `profile.jsp`, `order-details.jsp`, `sales-orders.jsp`,
`account.css`, `sql/schema_and_updates.sql`

## To run it

1. `psql` — create the `BookStoreApp` database if it doesn't exist yet
   (credentials are in `application.properties`).
2. `./mvnw spring-boot:run`
3. Register an account, then in `psql`:
   `UPDATE users SET role='ADMIN' WHERE user_id='<your id>';`
4. Log back in (or restart the session) — you'll now see the Admin link.

## One judgment call worth flagging

Your original `SecurityConfig` required authentication for almost every
route (it just used a browser popup instead of a real login page). I kept
that same "must be logged in to shop" behavior — cart/checkout/my-orders all
require login — just replaced the broken popup-based auth with proper form
login. If you'd rather let people browse and build a cart anonymously and
only require login at checkout, that's a quick follow-up change — just say
the word.

## UI / Login / Cart Fixes (2026-08-09)

- Seller login now redirects to the Seller Dashboard and opening Home/Category while logged in as a seller also returns to the Seller Dashboard.
- Added a clear Seller account indicator on the seller dashboard.
- Moved Book Categories into a dedicated navigation-bar Categories tab with a clean dropdown; removed the old category links from the header row.
- Fixed category labels such as "Fantasy Books" and prevented the category dropdown from overlapping the main content.
- Restored the purchaser Cart tab and cart badge in the navigation bar.
- Changed all Add to Cart AJAX forms to use the JSON endpoint.
- Improved cart AJAX error handling so server errors no longer appear as JSON parsing errors.
- Removed duplicate/nested HTML document wrappers from pages using the shared header/footer.
- Added `sql/create_admin.sql` and README instructions for provisioning an ADMIN account without exposing public admin registration.
