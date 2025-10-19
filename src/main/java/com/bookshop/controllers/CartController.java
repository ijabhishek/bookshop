package com.bookshop.controllers;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookshop.model.dto.BookDTO;
import com.bookshop.model.dto.CartDTO;
import com.bookshop.service.CartService; // Now Session-Scoped

// NOTE: You no longer need to import jakarta.servlet.http.HttpSession

@Controller
@RequestMapping("/bookstore")
public class CartController {

    // Spring injects the session-specific instance of CartService
    @Autowired
    private CartService cartService;

    @PostMapping("/addToCart")
    public String addToCart(@RequestParam("bookId") int bookId) {
    
        cartService.addToCart(bookId); 
        
        // Use Post/Redirect/Get pattern
        return "redirect:/bookstore/mycart";
    }

    @GetMapping("/mycart")
    
    public String viewCart(Model model) {
        // Service call is cleaner
        Map<BookDTO, Integer> cart = cartService.getCartDetails();

        double totalPrice = cartService.getCartTotal();
        int itemCount = cartService.getTotalItems();

        model.addAttribute("itemCount", itemCount);
        
        model.addAttribute("cart", cart);
        
        
        // 6. View return remains the same
        return "cart"; 
    }
    @ModelAttribute("cartCount")
    public int populateCartCount() {
        return cartService.getTotalItems();
}
}