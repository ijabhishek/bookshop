package com.bookshop.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bookshop.model.Author;
import com.bookshop.model.Category;
import com.bookshop.model.Order;
import com.bookshop.model.Status;
import com.bookshop.model.User;
import com.bookshop.model.dto.AdminDashboardDTO;
import com.bookshop.model.dto.BookDTO;
import com.bookshop.service.AdminService;
import com.bookshop.service.AuthorService;
import com.bookshop.service.BookService;
import com.bookshop.service.BookUserDetailsService;
import com.bookshop.service.OrderService;
import com.bookshop.repository.BookRequestRepository;
import com.bookshop.repository.FeedbackRepository;
import com.bookshop.model.BookRequest;
import java.io.IOException;
import java.time.LocalDate;
import com.bookshop.model.RequestStatus;

// Admin-only area: catalogue management (existing) plus sales analytics,
// order processing and user oversight (new).
@Controller
@RequestMapping("/bookstore/admin")
public class AdminController {

    @Autowired
    private BookService bookService;

    @Autowired
    private AuthorService authorService;

    @Autowired
    private AdminService adminService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private BookUserDetailsService userService;
    @Autowired
    private BookRequestRepository bookRequestRepository;

    @Autowired
    private FeedbackRepository feedbackRepository;

    // 📊 Main admin dashboard: catalogue + sales analytics + order & user tabs
    @GetMapping({"", "/"})
    public String getAdminPage(Model model) {
        List<BookDTO> books = bookService.getAllBooksWithAuthorName();
        model.addAttribute("books", books);

        List<Author> authors = authorService.getAllAuthors();
        model.addAttribute("authors", authors);
        model.addAttribute("categories", Category.values());

        AdminDashboardDTO stats = adminService.buildDashboard();
        model.addAttribute("stats", stats);
        model.addAttribute("totalBooks", stats.getTotalBooks());
        model.addAttribute("totalOrders", stats.getTotalOrders());
        model.addAttribute("totalRevenue", String.format("%.2f", stats.getTotalRevenue()));
        model.addAttribute("totalUsers", stats.getTotalUsers());

        model.addAttribute("orders", orderService.getAllOrders());
        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("bookRequests", bookRequestRepository.findAllByOrderByRequestedAtDesc());
        model.addAttribute("feedbacks", feedbackRepository.findAllByOrderBySubmittedAtDesc());

        return "admin";
    }

    @PostMapping("/save")
    public String saveBook(@org.springframework.web.bind.annotation.ModelAttribute BookDTO bookDTO,
                           @RequestParam("image") MultipartFile imageFile,
                           RedirectAttributes redirectAttributes) {
        try {
            bookService.saveBook(bookDTO, imageFile);
            redirectAttributes.addFlashAttribute("message", "Book saved successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not save book: " + e.getMessage());
        }
        return "redirect:/bookstore/admin";
    }

    // ✅ Update an order's fulfilment status from the admin Orders tab
    @PostMapping("/updateOrder")
    public String updateOrder(@RequestParam int orderId,
                               @RequestParam Status status,
                               RedirectAttributes redirectAttributes) {
        orderService.updateOrderStatus(orderId, status);
        redirectAttributes.addFlashAttribute("message", "Order #" + orderId + " marked as " + status);
        return "redirect:/bookstore/admin";
    }

    // 🔎 Order detail view (reuses the same page customers/sales see)
    @GetMapping("/viewOrder/{orderId}")
    public String viewOrder(@PathVariable int orderId, Model model) {
        Order order = orderService.getAllOrders().stream()
                .filter(o -> o.getId() == orderId)
                .findFirst()
                .orElse(null);
        model.addAttribute("order", order);
        return "order-details";
    }

    @PostMapping("/requestStatus")
    public String updateRequestStatus(@RequestParam Long requestId, @RequestParam RequestStatus status,
                                      RedirectAttributes redirectAttributes) {
        BookRequest request = bookRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));
        request.setStatus(status);
        bookRequestRepository.save(request);
        redirectAttributes.addFlashAttribute("message", "Book request updated.");
        return "redirect:/bookstore/admin";
    }

    @PostMapping("/author/save")
    public String saveAuthor(@RequestParam String authorName,
                             @RequestParam(required = false) MultipartFile authorImage,
                             @RequestParam(required = false) LocalDate birthDate,
                             @RequestParam(required = false) String birthPlace,
                             @RequestParam(required = false) String biography,
                             @RequestParam Category category,
                             RedirectAttributes redirectAttributes) {
        try {
            Author author = authorService.createAuthor(authorName, authorImage, birthDate, biography, birthPlace, category);
            redirectAttributes.addFlashAttribute("message", "Writer " + author.getAuthorName() + " added successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not add writer: " + e.getMessage());
        }
        return "redirect:/bookstore/admin";
    }

    @PostMapping("/author/update")
    public String updateAuthor(@RequestParam int id,
                               @RequestParam String authorName,
                               @RequestParam(required = false) MultipartFile authorImage,
                               @RequestParam(required = false) LocalDate birthDate,
                               @RequestParam(required = false) String birthPlace,
                               @RequestParam(required = false) String biography,
                               @RequestParam Category category,
                               RedirectAttributes redirectAttributes) {
        try {
            Author author = authorService.updateAuthor(id, authorName, authorImage, birthDate,
                    biography, birthPlace, category);
            redirectAttributes.addFlashAttribute("message",
                    "Writer " + author.getAuthorName() + " updated successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not update writer: " + e.getMessage());
        }
        return "redirect:/bookstore/admin";
    }

    @PostMapping("/saveUser")
    public String saveUser(@RequestParam String userId, @RequestParam String firstName, @RequestParam String email,
                           @RequestParam String phoneNumber, @RequestParam String address, @RequestParam String role,
                           @RequestParam(required = false) String password, RedirectAttributes redirectAttributes) {
        try {
            String safeRole = ("ADMIN".equalsIgnoreCase(role) || "SELLER".equalsIgnoreCase(role))
                    ? role.toUpperCase() : "USER";
            User user = userService.findByUserId(userId);
            if (user == null) {
                if (password == null || password.isBlank()) throw new IllegalArgumentException("Password is required for a new user.");
                user = new User(); user.setUserId(userId); user.setPassword(new BCryptPasswordEncoder(12).encode(password));
            }
            user.setFirstName(firstName); user.setEmail(email); user.setPhoneNumber(phoneNumber);
            user.setAddress(address); user.setRole(safeRole);
            userService.savUser(user);
            redirectAttributes.addFlashAttribute("message", "User saved successfully.");
        } catch (Exception e) { redirectAttributes.addFlashAttribute("error", "Could not save user: " + e.getMessage()); }
        return "redirect:/bookstore/admin";
    }

    @PostMapping("/deleteUser")
    public String deleteUser(@RequestParam String userId, Authentication authentication, RedirectAttributes redirectAttributes) {
        try {
            if (authentication != null && authentication.getName().equals(userId)) {
                throw new IllegalStateException("You cannot delete the currently logged-in admin account.");
            }
            userService.deleteUser(userId);
            redirectAttributes.addFlashAttribute("message", "User " + userId + " deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not delete user: " + e.getMessage());
        }
        return "redirect:/bookstore/admin";
    }

    // 💸 Apply a flat discount percentage across the whole catalogue
    @PostMapping("/discount")
    public String applyGlobalDiscount(@RequestParam double discount, RedirectAttributes redirectAttributes) {
        bookService.applyGlobalDiscount(discount);
        redirectAttributes.addFlashAttribute("message", "Applied a " + discount + "% discount to all books.");
        return "redirect:/bookstore/admin";
    }

}
