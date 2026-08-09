package com.bookshop.config;

import jakarta.annotation.PostConstruct;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/** Keeps the PostgreSQL order status constraint in sync with the application statuses. */
@Component
public class OrderStatusConstraintMigration {
    private final JdbcTemplate jdbcTemplate;
    public OrderStatusConstraintMigration(JdbcTemplate jdbcTemplate) { this.jdbcTemplate = jdbcTemplate; }

@PostConstruct
public void updateConstraint() {
    jdbcTemplate.execute(
        "ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_status_check"
    );

    jdbcTemplate.execute(
        "ALTER TABLE orders " +
        "ADD CONSTRAINT orders_status_check " +
        "CHECK (status IN (0, 1, 2, 3, 4))"
    );
}
}
