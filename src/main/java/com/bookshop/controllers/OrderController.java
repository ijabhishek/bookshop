package com.bookshop.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bookshop.model.Order;
import com.bookshop.service.InvoiceService;
import com.bookshop.service.OrderService;

//Controller class that handle the all mapping related to order processing
@Controller
@RequestMapping("/bookstore")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private InvoiceService invoiceService;

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

    @PostMapping("/cancelOrder/{orderNumber}")
    public String cancelOrder(@PathVariable String orderNumber, Authentication authentication,
                              RedirectAttributes redirectAttributes) {
        try {
            orderService.cancelOrder(orderNumber, authentication.getName());
            redirectAttributes.addFlashAttribute("message", "Order " + orderNumber + " canceled successfully.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/bookstore/myorders";
    }

    // 🔎 View a single order's detail (owner, or ADMIN/SALES staff)
    @GetMapping("/order/{orderNumber}")
    public String viewOrder(@PathVariable String orderNumber, Authentication authentication, Model model) {
        Order order = orderService.getOrderByNumber(orderNumber);
        if (order == null) {
            return "redirect:/bookstore/myorders";
        }
        assertCanAccessOrder(order, authentication);

        model.addAttribute("order", order);
        return "order-details";
    }

    // 🧾 Download a PDF invoice for an order (owner, or ADMIN/SALES staff)
    @GetMapping("/order/{orderNumber}/invoice")
    public ResponseEntity<byte[]> downloadInvoice(@PathVariable String orderNumber, Authentication authentication) {
        Order order = orderService.getOrderByNumber(orderNumber);
        if (order == null) {
            return ResponseEntity.notFound().build();
        }
        assertCanAccessOrder(order, authentication);

        byte[] pdf = invoiceService.generateInvoice(order);

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"invoice-" + orderNumber + ".pdf\"")
                .body(pdf);
    }

    private void assertCanAccessOrder(Order order, Authentication authentication) {
        boolean isOwner = order.getUser() != null
                && order.getUser().getUserId().equals(authentication.getName());
        boolean isStaff = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_SALES"));

        if (!isOwner && !isStaff) {
            throw new AccessDeniedException("You are not allowed to view this order.");
        }
    }

}
