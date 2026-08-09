package com.bookshop.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bookshop.model.Order;
import com.bookshop.model.User;
import com.bookshop.repository.OrderRepository;
import com.bookshop.service.BookUserDetailsService;

import java.util.List;

@Controller
@RequestMapping("/bookstore")
public class UserController {

    @Autowired
    private BookUserDetailsService userService;
    @Autowired
    private OrderRepository orderRepository;
    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);


    @PostMapping("/registerUser")
    public String register(@ModelAttribute User user){
        user.setPassword(encoder.encode(user.getPassword()));
        // Only "USER" (purchaser) and "SELLER" can be chosen at signup.
        // ADMIN / SALES accounts are provisioned separately (see
        // sql/schema_and_updates.sql) - never trust a role from the client
        // beyond these two options.
        String requestedRole = user.getRole() == null ? "" : user.getRole().trim().toUpperCase();
        user.setRole(requestedRole.equals("SELLER") ? "SELLER" : "USER");
        userService.savUser(user);

        return "login";
    }

    // 📦 Logged-in user's order history ("My Orders")
    @GetMapping("/myorders")
    public String myOrders(Authentication authentication, Model model) {
        String userId = authentication.getName();
        List<Order> orders = orderRepository.findByUser_UserIdOrderByOrderDateDesc(userId);
        model.addAttribute("orders", orders);
        return "my-orders";
    }

    // 👤 Logged-in user's profile
    @GetMapping("/profile")
    public String profile(Authentication authentication, Model model) {
        User user = userService.findByUserId(authentication.getName());
        model.addAttribute("user", user);
        return "profile";
    }

    // ✏️ Update the editable parts of a profile (not userId / password / role)
    @PostMapping("/profile/update")
    public String updateProfile(Authentication authentication,
                                 @RequestParam String firstName,
                                 @RequestParam String email,
                                 @RequestParam String phoneNumber,
                                 @RequestParam String address,
                                 RedirectAttributes redirectAttributes) {
        User user = userService.findByUserId(authentication.getName());
        user.setFirstName(firstName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setAddress(address);
        userService.savUser(user);

        redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
        return "redirect:/bookstore/profile";
    }

}
