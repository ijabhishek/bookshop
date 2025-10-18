package com.bookshop.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookshop.model.dto.BookDTO;
import com.bookshop.repository.BookRepo;

import jakarta.servlet.http.HttpSession;

@Service
public class CartService {

    @Autowired
    private BookService bookService;
    public void addToCart(int bookId, HttpSession session) {
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
        }

        cart.put(bookId, cart.getOrDefault(bookId, 0)+1); // increase quantity

        session.setAttribute("cart", cart);
        
    }

    public Map<BookDTO, Integer> getCartDetails(HttpSession session) {
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if ( cart == null ) return new HashMap<>();

        Map<BookDTO, Integer> cartDetails = new HashMap<>();
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            BookDTO book = bookService.getBookById(entry.getKey());
            if(book != null) {
                cartDetails.put(book, entry.getValue());
            }

        }
        return cartDetails;

    }

    
}
