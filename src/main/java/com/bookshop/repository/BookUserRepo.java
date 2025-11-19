package com.bookshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bookshop.model.User;

public interface BookUserRepo extends JpaRepository<User, Integer> {
    User findByUserId(String userId);
    
}
