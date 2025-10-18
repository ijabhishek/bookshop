package com.bookshop.controllers;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookshop.model.dto.BookDTO;
import com.bookshop.service.CartService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/bookstore")
public class CartController {

    @Autowired
    private CartService cartService;

    @PostMapping("/addToCart")
    public String addToCart(@RequestParam("bookId") int bookId, HttpSession session) {
        cartService.addToCart(bookId, session);
        return "redirect:/cart";
    }

    @GetMapping("/mycart")
    public String viewCart(HttpSession session, Model model) {
        Map<BookDTO, Integer> cart = cartService.getCartDetails(session);
        model.addAttribute("cart", cart);
        return "cart";
    }
    
}
