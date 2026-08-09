-- NOTE: The app runs with spring.jpa.hibernate.ddl-auto=update, so
-- Hibernate will create/adjust these tables automatically on startup.
-- This script is provided for manual database setup, upgrades, and seeding.

-- =====================================================================
-- 1. FRESH SCHEMA
-- =====================================================================

CREATE TABLE IF NOT EXISTS authors (
    id              SERIAL PRIMARY KEY,
    author_name     VARCHAR(255),
    image_url       VARCHAR(500),
    biography       TEXT,
    birth_date      DATE,
    birth_place     VARCHAR(255),
    nationality     VARCHAR(255),
    category        VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS users (
    user_id         VARCHAR(255) PRIMARY KEY,
    first_name      VARCHAR(255),
    password        VARCHAR(255) NOT NULL,
    email           VARCHAR(255),
    phone_number    VARCHAR(50),
    role            VARCHAR(20) NOT NULL DEFAULT 'USER',
    address         TEXT
);

CREATE TABLE IF NOT EXISTS book (
    book_id             SERIAL PRIMARY KEY,
    isbn                VARCHAR(50),
    title               VARCHAR(500),
    published_year      DATE,
    author_id           INTEGER NOT NULL REFERENCES authors(id),
    selling_price       DOUBLE PRECISION,
    discounted_price    DOUBLE PRECISION,
    book_description    TEXT,
    stock               INTEGER,
    image_url           VARCHAR(500),
    category            VARCHAR(50),
    book_available      BOOLEAN DEFAULT TRUE,
    seller_id           VARCHAR(255) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS book_requests (
    id              BIGSERIAL PRIMARY KEY,
    book_title      VARCHAR(500) NOT NULL,
    author          VARCHAR(255) NOT NULL,
    description     TEXT,
    user_id         VARCHAR(255) REFERENCES users(user_id),
    requested_at    TIMESTAMP,
    status          VARCHAR(20) NOT NULL DEFAULT 'PENDING'
);

-- IMPORTANT:
-- Status is SMALLINT because the current Java enum is stored by ordinal:
-- 0 = PENDING
-- 1 = IN_PROCESS
-- 2 = DISPATCHED
-- 3 = DELIVERED
-- 4 = CANCELLED

CREATE TABLE IF NOT EXISTS orders (
    id              SERIAL PRIMARY KEY,
    order_number    VARCHAR(100) UNIQUE NOT NULL,
    user_id         VARCHAR(255) REFERENCES users(user_id),
    order_date      TIMESTAMP,
    status          SMALLINT NOT NULL DEFAULT 0
                    CHECK (status IN (0, 1, 2, 3, 4)),
    total_amount    DOUBLE PRECISION NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS order_item (
    id                  SERIAL PRIMARY KEY,
    order_number        INTEGER NOT NULL REFERENCES orders(id),
    book_id             INTEGER REFERENCES book(book_id),
    quantity            INTEGER NOT NULL,
    price_at_purchase   DOUBLE PRECISION NOT NULL
);

-- =====================================================================
-- INDEXES
-- =====================================================================

CREATE INDEX IF NOT EXISTS idx_orders_user_id
    ON orders(user_id);

CREATE INDEX IF NOT EXISTS idx_orders_status
    ON orders(status);

CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON orders(order_date);

CREATE INDEX IF NOT EXISTS idx_order_item_order
    ON order_item(order_number);

CREATE INDEX IF NOT EXISTS idx_order_item_book
    ON order_item(book_id);


-- =====================================================================
-- 2. UPGRADE AN EXISTING DATABASE
-- =====================================================================

-- 2a. USER ROLE

ALTER TABLE users
ALTER COLUMN role SET DEFAULT 'USER';

UPDATE users
SET role = 'USER'
WHERE role IS NULL OR role = '';

ALTER TABLE users
ALTER COLUMN role SET NOT NULL;


-- 2b. AUTHOR / BOOK UPGRADES

ALTER TABLE authors
ADD COLUMN IF NOT EXISTS category VARCHAR(50);

ALTER TABLE authors
ADD COLUMN IF NOT EXISTS birth_place VARCHAR(255);

ALTER TABLE authors
ALTER COLUMN biography TYPE TEXT;

ALTER TABLE book
ADD COLUMN IF NOT EXISTS seller_id VARCHAR(255);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_book_seller'
    ) THEN
        ALTER TABLE book
        ADD CONSTRAINT fk_book_seller
        FOREIGN KEY (seller_id)
        REFERENCES users(user_id);
    END IF;
END $$;


-- 2c. BOOK REQUEST COMPATIBILITY

ALTER TABLE book_requests
ADD COLUMN IF NOT EXISTS book_title VARCHAR(500);

ALTER TABLE book_requests
ADD COLUMN IF NOT EXISTS author VARCHAR(255);

ALTER TABLE book_requests
ADD COLUMN IF NOT EXISTS description TEXT;

ALTER TABLE book_requests
ADD COLUMN IF NOT EXISTS user_id VARCHAR(255);

ALTER TABLE book_requests
ADD COLUMN IF NOT EXISTS requested_at TIMESTAMP;

ALTER TABLE book_requests
ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'PENDING';

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'book_requests'
        AND column_name = 'title'
    )
    AND NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'book_requests'
        AND column_name = 'book_title'
    ) THEN
        ALTER TABLE book_requests
        RENAME COLUMN title TO book_title;
    END IF;
END $$;


-- 2d. ADD USER LINK TO ORDERS

ALTER TABLE orders
ADD COLUMN IF NOT EXISTS user_id VARCHAR(255);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_orders_user'
    ) THEN
        ALTER TABLE orders
        ADD CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id);
    END IF;
END $$;


-- =====================================================================
-- 2e. FIX ORDER STATUS COLUMN AND CONSTRAINT
-- =====================================================================

-- Remove the old check constraint first.
ALTER TABLE orders
DROP CONSTRAINT IF EXISTS orders_status_check;

-- Ensure the status column is SMALLINT.
-- This works if the current values are numeric or null.
ALTER TABLE orders
ALTER COLUMN status TYPE SMALLINT
USING status::SMALLINT;

-- Replace invalid or null values with PENDING (0).
UPDATE orders
SET status = 0
WHERE status IS NULL
   OR status NOT IN (0, 1, 2, 3, 4);

-- Default for new orders is PENDING.
ALTER TABLE orders
ALTER COLUMN status SET DEFAULT 0;

-- Status is required.
ALTER TABLE orders
ALTER COLUMN status SET NOT NULL;

-- Add the correct constraint.
ALTER TABLE orders
ADD CONSTRAINT orders_status_check
CHECK (status IN (0, 1, 2, 3, 4));


-- =====================================================================
-- 2f. ORDER INDEXES
-- =====================================================================

CREATE INDEX IF NOT EXISTS idx_orders_user_id
    ON orders(user_id);

CREATE INDEX IF NOT EXISTS idx_orders_status
    ON orders(status);

CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON orders(order_date);


-- =====================================================================
-- 3. CREATE ADMIN / SELLER ACCOUNTS
-- =====================================================================

-- First register normal accounts through the application, then promote them.

UPDATE users
SET role = 'ADMIN'
WHERE user_id = 'admin1';

UPDATE users
SET role = 'SELLER'
WHERE user_id = 'seller1';


-- =====================================================================
-- 4. HANDY ANALYTICS QUERIES
-- =====================================================================

-- Status mapping:
-- 0 = PENDING
-- 1 = IN_PROCESS
-- 2 = DISPATCHED
-- 3 = DELIVERED
-- 4 = CANCELLED


-- Total revenue excluding CANCELLED orders.
SELECT COALESCE(SUM(total_amount), 0) AS total_revenue
FROM orders
WHERE status <> 4;


-- Orders grouped by status.
SELECT
    CASE status
        WHEN 0 THEN 'PENDING'
        WHEN 1 THEN 'IN_PROCESS'
        WHEN 2 THEN 'DISPATCHED'
        WHEN 3 THEN 'DELIVERED'
        WHEN 4 THEN 'CANCELLED'
        ELSE 'UNKNOWN'
    END AS status_name,
    COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY status;


-- Revenue during the last 30 days, excluding cancelled orders.
SELECT COALESCE(SUM(total_amount), 0) AS revenue_last_30_days
FROM orders
WHERE order_date >= NOW() - INTERVAL '30 days'
AND status <> 4;


-- Delivered orders revenue only.
SELECT COALESCE(SUM(total_amount), 0) AS delivered_revenue
FROM orders
WHERE status = 3;


-- Top-selling books by quantity.
SELECT
    b.title,
    SUM(oi.quantity) AS units_sold
FROM order_item oi
JOIN book b
    ON b.book_id = oi.book_id
GROUP BY b.title
ORDER BY units_sold DESC
LIMIT 10;


-- Orders with customer information.
SELECT
    o.order_number,
    u.first_name,
    u.phone_number,
    u.address,
    o.order_date,
    o.total_amount,
    CASE o.status
        WHEN 0 THEN 'PENDING'
        WHEN 1 THEN 'IN_PROCESS'
        WHEN 2 THEN 'DISPATCHED'
        WHEN 3 THEN 'DELIVERED'
        WHEN 4 THEN 'CANCELLED'
        ELSE 'UNKNOWN'
    END AS status
FROM orders o
JOIN users u
    ON u.user_id = o.user_id
ORDER BY o.order_date DESC;


-- =====================================================================
-- END
-- =====================================================================

-- Current Java enum mapping:
--
-- public enum Status {
--     PENDING,      -- 0
--     IN_PROCESS,   -- 1
--     DISPATCHED,   -- 2
--     DELIVERED,    -- 3
--     CANCELLED     -- 4
-- }