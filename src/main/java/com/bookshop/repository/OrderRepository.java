package com.bookshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bookshop.model.Order;

public interface OrderRepository extends JpaRepository<Order, Integer> {
    
}
