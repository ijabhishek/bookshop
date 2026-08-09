package com.bookshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bookshop.model.Author;
import java.util.Optional;

public interface AuthorRepo extends JpaRepository<Author, Integer>{
    
    Optional<Author> findByAuthorNameIgnoreCase(String authorName);
}
