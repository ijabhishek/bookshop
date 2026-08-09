package com.bookshop.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookshop.model.User;
import com.bookshop.model.UserPrincipal;
import com.bookshop.repository.BookUserRepo;
import com.bookshop.repository.BookRepo;
import com.bookshop.repository.OrderRepository;
import com.bookshop.model.Book;
import com.bookshop.model.Order;

@Service
public class BookUserDetailsService implements UserDetailsService{

    @Autowired
    private BookUserRepo bookUserRepo;

    @Autowired
    private BookRepo bookRepo;

    @Autowired
    private OrderRepository orderRepository;

    @Override
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {

        User user = bookUserRepo.findByUserId(userId);

        if(user == null) {
            System.out.println("User not found");

            throw new UsernameNotFoundException("User 404");

        }

        return new UserPrincipal(user);
    }

    public User savUser(User user) {
        return bookUserRepo.save(user);
    }

    public User findByUserId(String userId) {
        return bookUserRepo.findByUserId(userId);
    }

    @Transactional
    public void deleteUser(String userId) {
        User user = bookUserRepo.findByUserId(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found: " + userId);
        }

        // Unlink books owned by this seller before deleting the user.
        List<Book> sellerBooks = bookRepo.findBySeller_UserIdOrderByTitleAsc(userId);
        for (Book book : sellerBooks) {
            book.setSeller(null);
        }
        if (!sellerBooks.isEmpty()) {
            bookRepo.saveAll(sellerBooks);
        }

        // Orders have a foreign key to users, so remove them before the user.
        List<Order> orders = orderRepository.findByUser_UserIdOrderByOrderDateDesc(userId);
        if (!orders.isEmpty()) {
            orderRepository.deleteAll(orders);
        }

        bookUserRepo.delete(user);
    }

    public List<User> getAllUsers() {
        return bookUserRepo.findAll();
    }

}
