package com.bookshop.controllers;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.http.ResponseEntity;

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

    // 🛒 AJAX version: adds the book but does NOT navigate away from the
    // current page. Used by the "Add to Cart" buttons on Home / Book Details.
    @PostMapping("/api/cart/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addToCartAjax(@RequestParam("bookId") int bookId,
                                              @RequestParam(value = "quantity", defaultValue = "1") int quantity) {
        try {
            if (quantity < 1 || quantity > 20) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Invalid quantity."));
            }
            for (int i = 0; i < quantity; i++) {
                cartService.addToCart(bookId);
            }
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "itemCount", cartService.getTotalItems(),
                    "cartTotal", cartService.getCartTotal()
            ));
        } catch (IllegalStateException | IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", ex.getMessage()));
        }
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

    @GetMapping("removeCart/{bookId}")
    public String removeBookFromCart(@PathVariable("bookId") int bookId ){
        cartService.removeItemFromCart(bookId);
        return "redirect:/bookstore/mycart";


    }
}