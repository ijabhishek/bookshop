package com.bookshop.controllers;

import java.time.LocalDateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.bookshop.model.*;
import com.bookshop.repository.BookRequestRepository;
import com.bookshop.repository.FeedbackRepository;
import com.bookshop.service.BookUserDetailsService;

@Controller
@RequestMapping("/bookstore")
public class BookRequestController {
    @Autowired private BookRequestRepository repository;
    @Autowired private FeedbackRepository feedbackRepository;
    @Autowired private BookUserDetailsService userService;

    @PostMapping("/requestBook")
    public String requestBook(@RequestParam String title, @RequestParam String author,
                              @RequestParam String description, Authentication authentication,
                              RedirectAttributes redirectAttributes) {
        try {
            if (authentication == null || authentication.getName() == null) {
                throw new AccessDeniedException("Please log in before requesting a book.");
            }

            User requester = userService.findByUserId(authentication.getName());
            if (requester == null) {
                throw new IllegalArgumentException("Your user account could not be found.");
            }

            BookRequest request = new BookRequest();
            request.setTitle(title.trim());
            request.setAuthor(author.trim());
            request.setDescription(description.trim());
            request.setRequester(requester);
            request.setRequestedAt(LocalDateTime.now());
            request.setStatus(RequestStatus.PENDING);
            repository.save(request);
            redirectAttributes.addFlashAttribute("message", "Your book request was submitted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not submit book request: " + e.getMessage());
        }
        return "redirect:/bookstore/home";
    }

    @PostMapping("/feedback")
    public String submitFeedback(@RequestParam String name, @RequestParam String message,
                                 RedirectAttributes redirectAttributes) {
        String cleanName = name == null ? "Visitor" : name.trim();
        String cleanMessage = message == null ? "" : message.trim();

        if (cleanName.isEmpty() || cleanMessage.isEmpty()) {
            redirectAttributes.addFlashAttribute("error",
                    "Please enter your name and feedback before submitting.");
            return "redirect:/bookstore/home";
        }

        try {
            Feedback feedback = new Feedback();
            feedback.setName(cleanName);
            feedback.setMessage(cleanMessage);
            feedback.setSubmittedAt(LocalDateTime.now());
            feedbackRepository.save(feedback);

            redirectAttributes.addFlashAttribute("message",
                    "Thank you, " + cleanName + ". Your feedback was submitted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Could not submit feedback: " + e.getMessage());
        }

        return "redirect:/bookstore/home";
    }
}
