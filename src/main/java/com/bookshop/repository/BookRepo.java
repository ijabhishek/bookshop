package com.bookshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bookshop.model.Book;

public interface BookRepo extends JpaRepository<Book ,Integer > {

    List<Book> findByAuthorId(int authorId);

    
    
}
