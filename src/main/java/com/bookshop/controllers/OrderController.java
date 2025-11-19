package com.bookshop.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bookshop.model.Order;
import com.bookshop.model.dto.OrderDTO;
import com.bookshop.service.BookService;
import com.bookshop.service.OrderService;

//Controller class that handle the all mapping related to order processing
@Controller
@RequestMapping("/bookstore")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // Checkout enpoint
    @PostMapping("/checkout")
    public String checkOutOrder(Model model) {
        try {
            // Place the order
            Order order = orderService.placeOrder();

            //Add order details to model(for confirmation page)
            model.addAttribute("order",order);
            model.addAttribute("message", "your order has been placed successfully");

            // Redirect to confirmation view
            return "checkout-success";

        } catch (RuntimeException exception) {
            // Handle errors(Like empty cart)
            model.addAttribute("error",exception.getMessage());
            return "checkout-failure";
        }

        
    }



    



    
}
