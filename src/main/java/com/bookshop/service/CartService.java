package com.bookshop.service;

import com.bookshop.model.dto.BookDTO;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.annotation.SessionScope; // Key change!

import java.util.HashMap;
import java.util.Map;

// Spring will create a new instance of this service for every new user session.
@Service
@SessionScope 
public class CartService {

    @Autowired
    private BookService bookService;

    // This map holds the cart state for the current session, managed by Spring.
    // Key: Book ID (Integer), Value: Quantity (Integer)
    private final Map<Integer, Integer> sessionCart = new HashMap<>();

    public void addToCart(int bookId) {
        // Quantity is increased directly on the sessionCart map
        sessionCart.put(bookId, sessionCart.getOrDefault(bookId, 0) + 1);
    }

    // 2. Service method to get display data (DTOs and quantity)
    public Map<BookDTO, Integer> getCartDetails() {
        if (sessionCart.isEmpty()) {
            return new HashMap<>();
        }

        Map<BookDTO, Integer> cartDetails = new HashMap<>();
        for (Map.Entry<Integer, Integer> entry : sessionCart.entrySet()) {
            // Retrieve full Book details
            BookDTO book = bookService.getBookById(entry.getKey());
            if (book != null) {
                cartDetails.put(book, entry.getValue());
            }
        }
        return cartDetails;
    }

    // You could also add a method to clear the cart:
    public void clearCart() {
        sessionCart.clear();
    }

    // Inside your CartService.java
    public double getCartTotal() {
        double total = 0.0;
        // Iterate over the sessionCart Map<BookId, Quantity>
        for (Map.Entry<Integer, Integer> entry : sessionCart.entrySet()) {
            BookDTO book = bookService.getBookById(entry.getKey());
            if (book != null) {
                total += book.getDiscountedPrice() * entry.getValue();
            }
        }
        return total;
    }

    public int getTotalItems(){
        // 🌟 CORRECTED: We iterate over the private sessionCart map directly! 🌟
        
        if (sessionCart.isEmpty()) {
            return 0;
        }

        // Sum the quantities (the Integer values) in the cart map
        int totalItems = 0;
        for (Integer quantity : sessionCart.values()) {
            // Note: quantity will never be null here if addToCart is used correctly,
            // but this check is good practice.
            if (quantity != null) {
                totalItems += quantity;
            }
        }
        
        return totalItems;
    }

}
        

