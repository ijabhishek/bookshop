package com.bookshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.bookshop.model.Order;
import com.bookshop.model.Status;

public interface OrderRepository extends JpaRepository<Order, Integer> {

    // Orders placed by one customer, most recent first (used by "My Orders")
    List<Order> findByUser_UserIdOrderByOrderDateDesc(String userId);

    Order findByOrderNumber(String orderNumber);

    List<Order> findAllByOrderByOrderDateDesc();

    List<Order> findByStatusOrderByOrderDateDesc(Status status);

    long countByStatus(Status status);

    // ---- Admin analytics ----

    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM orders o WHERE o.status = com.bookshop.model.Status.DELIVERED")
    double getTotalRevenue();

    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM orders o WHERE o.orderDate >= :since AND o.status = com.bookshop.model.Status.DELIVERED")
    double getRevenueSince(@Param("since") java.time.LocalDateTime since);

    @Query("SELECT oi.book.title, SUM(oi.quantity) as qty FROM OrderItem oi GROUP BY oi.book.title ORDER BY qty DESC")
    List<Object[]> findTopSellingBooks();

}
