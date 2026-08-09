package com.bookshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bookshop.model.User;

// NOTE: User's @Id (userId) is a String, so the repository must be typed
// JpaRepository<User, String>. It was previously typed <User, Integer>,
// which does not match the entity's actual primary key type.
public interface BookUserRepo extends JpaRepository<User, String> {
    User findByUserId(String userId);

}
