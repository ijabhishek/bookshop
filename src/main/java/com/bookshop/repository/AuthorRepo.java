package com.bookshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bookshop.model.Author;

public interface AuthorRepo extends JpaRepository<Author, Integer>{
    
}
