-- ================================================================
-- CREATE A BOOKSHOP ADMIN ACCOUNT
-- ================================================================
-- Admin accounts are intentionally NOT created from the public
-- registration page. Run this script once in PostgreSQL.
--
-- Login after running:
--   User ID : admin
--   Password: password
-- Then change the password if you add a password-change feature.
--
-- The password below is a BCrypt hash accepted by Spring Security.
-- ================================================================

INSERT INTO users (user_id, first_name, password, email, phone_number, role, address)
VALUES (
    'admin',
    'Administrator',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'admin@bookshop.local',
    '0000000000',
    'ADMIN',
    'BookShop Admin'
)
ON CONFLICT (user_id) DO UPDATE SET
    first_name = EXCLUDED.first_name,
    password = EXCLUDED.password,
    email = EXCLUDED.email,
    phone_number = EXCLUDED.phone_number,
    role = 'ADMIN',
    address = EXCLUDED.address;
