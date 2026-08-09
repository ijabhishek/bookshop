package com.bookshop.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import com.bookshop.model.Book;
import com.bookshop.model.Category;

public interface BookRepo extends JpaRepository<Book,Integer> {
    List<Book> findByAuthorId(int authorId);
    List<Book> findByCategoryOrderByTitleAsc(Category category);
    List<Book> findBySeller_UserIdOrderByTitleAsc(String userId);

    @Query("SELECT b FROM Book b WHERE LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR LOWER(b.author.authorName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR LOWER(str(b.category)) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR str(b.publishedYear) LIKE CONCAT('%', :keyword, '%')")
    List<Book> findBookByKeyword(String keyword);

    @Query("SELECT DISTINCT oi.order FROM OrderItem oi WHERE oi.book.seller.userId = :sellerId ORDER BY oi.order.orderDate DESC")
    List<com.bookshop.model.Order> findOrdersReceivedBySeller(String sellerId);
}
