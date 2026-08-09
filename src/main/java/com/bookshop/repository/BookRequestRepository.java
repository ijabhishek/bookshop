package com.bookshop.repository;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.bookshop.model.BookRequest;
import com.bookshop.model.RequestStatus;
public interface BookRequestRepository extends JpaRepository<BookRequest, Long> {
    List<BookRequest> findAllByOrderByRequestedAtDesc();
    List<BookRequest> findByStatusOrderByRequestedAtDesc(RequestStatus status);
}
