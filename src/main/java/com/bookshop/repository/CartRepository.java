package com.bookshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bookshop.model.Cart;

@Repository
public interface CartRepository extends JpaRepository<Cart, Integer> {
    
}
