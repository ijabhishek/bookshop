package com.bookshop.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bookshop.model.Order;
import com.bookshop.model.Status;
import com.bookshop.service.OrderService;

// Sales-staff area (ROLE_SALES / ROLE_ADMIN): see incoming orders together
// with the customer's delivery address and update fulfilment status.
@Controller
@RequestMapping("/bookstore/sales")
public class SalesController {

    @Autowired
    private OrderService orderService;

    @GetMapping({"", "/orders"})
    public String orders(@RequestParam(required = false) Status status, Model model) {
        List<Order> orders = (status != null)
                ? orderService.getAllOrders().stream().filter(o -> o.getStatus() == status).toList()
                : orderService.getAllOrders();

        model.addAttribute("orders", orders);
        model.addAttribute("statuses", Status.values());
        model.addAttribute("selectedStatus", status);
        return "sales-orders";
    }

    @PostMapping("/updateStatus")
    public String updateStatus(@RequestParam int orderId,
                                @RequestParam Status status,
                                RedirectAttributes redirectAttributes) {
        orderService.updateOrderStatus(orderId, status);
        redirectAttributes.addFlashAttribute("message", "Order #" + orderId + " marked as " + status);
        return "redirect:/bookstore/sales/orders";
    }
}
