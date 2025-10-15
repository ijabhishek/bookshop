package com.bookshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.bookshop.model.Book;
import com.bookshop.model.BookDTO;

public interface BookRepo extends JpaRepository<Book ,Integer > {

    List<Book> findByAuthorId(int authorId);


    @Query(" SELECT b FROM Book b WHERE " +
            "LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR "+
            "LOWER(b.author.authorName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR "+
            "LOWER(b.category) LIKE LOWER(CONCAT('%', :keyword, '%')) OR "+
            "str(b.publishedYear) LIKE str(CONCAT('%', :keyword, '%'))")
    List<Book> findBookByKeyword(String keyword);

    
    
}
