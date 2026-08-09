//Controller For HomePage 

package com.bookshop.controllers;

import java.io.IOException;
import java.util.List;
import java.time.LocalDate;
import org.springframework.security.core.Authentication;
import com.bookshop.model.Category;
import com.bookshop.model.Order;
import com.bookshop.model.BookRequest;
import com.bookshop.model.RequestStatus;
import com.bookshop.model.Status;
import com.bookshop.repository.BookRequestRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bookshop.model.Author;
import com.bookshop.model.Book;
import com.bookshop.model.dto.BookDTO;
import com.bookshop.service.AuthorService;
import com.bookshop.service.BookService;

@Controller
@RequestMapping("/bookstore")
public class HomeWebController {

    @ModelAttribute
    public void commonCategories(Model model) { model.addAttribute("categories", Category.values()); }

    @Autowired
    private AuthorService authorService;

    @Autowired
    private BookService bookService;

    @Autowired
    private BookRequestRepository bookRequestRepository;

    @Autowired
    private com.bookshop.service.OrderService orderService;

    // 🏠 Load homepage with list of all books (including author names)
    @GetMapping({"/home"})
    public String getBooksWithAuthor(Authentication authentication, Model model) {
        if (authentication != null) {
            boolean seller = authentication.getAuthorities().stream().anyMatch(a -> "ROLE_SELLER".equals(a.getAuthority()));
            boolean admin = authentication.getAuthorities().stream().anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
            if (seller) return "redirect:/bookstore/seller";
            if (admin) return "redirect:/bookstore/admin";
        }
        model.addAttribute("books", bookService.getAllBooksWithAuthorName());
        return "home";
    }

    // 🛠️ Admin dashboard (catalogue + sales analytics + order/user tabs)
    // now lives in AdminController at GET /bookstore/admin.

    // 📝 Admin edit form for an existing book by ID
    @GetMapping({"admin/editBook/{bookId}"})
    public String editBookByAdmin(@PathVariable Integer bookId, Model model){
        BookDTO book = bookService.getBookById(bookId);
        model.addAttribute("book", book);

        List<Author> authors = authorService.getAllAuthors();
        model.addAttribute("authors", authors);

        return "editBook";
    }

    // ✅ Update book after admin edits (with image upload)
    @PostMapping({"admin/editBook/updateBook"})
    public String updateBookByAdmin(@ModelAttribute BookDTO bookDTO,
                               @RequestParam("image") MultipartFile imageFile,
                               RedirectAttributes redirectAttributes) {
        try {
            bookService.updateBook(bookDTO, imageFile);
            redirectAttributes.addFlashAttribute("message", "Book saved successfully!");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Error saving book.");
        }

        // Debug logs
        System.out.println("Received bookDTO: " + bookDTO);
        System.out.println("Received file: " + imageFile.getOriginalFilename());
        System.out.println("Book is Updated");

        return "redirect:/bookstore/admin";
    }

    // 🧑‍💼 Seller page
    @GetMapping({"/seller"})
    public String getSellerPage(Authentication authentication, Model model){
        String userId = authentication.getName();
        model.addAttribute("sellerBooks", bookService.getBooksForSeller(userId));
        model.addAttribute("receivedOrders", bookService.getOrdersReceivedBySeller(userId));
        model.addAttribute("authors", authorService.getAllAuthors());
        model.addAttribute("bookRequests", bookRequestRepository.findByStatusOrderByRequestedAtDesc(RequestStatus.PENDING));
        model.addAttribute("orderStatuses", Status.values());
        return "seller";
    }

    @PostMapping("/seller/updateOrderStatus")
    public String updateSellerOrderStatus(@RequestParam int orderId, @RequestParam Status status,
                                          Authentication authentication, RedirectAttributes redirectAttributes) {
        boolean ownsOrder = bookService.getOrdersReceivedBySeller(authentication.getName()).stream()
                .anyMatch(order -> order.getId() == orderId);
        if (!ownsOrder) {
            redirectAttributes.addFlashAttribute("error", "You can only update orders for your own books.");
            return "redirect:/bookstore/seller";
        }
        orderService.updateOrderStatus(orderId, status);
        redirectAttributes.addFlashAttribute("message", "Order status updated successfully.");
        return "redirect:/bookstore/seller";
    }

    // 📚 Page for seller to add a new book
    @GetMapping({"/addbook"})
    public String addNewBook(Model model){
        model.addAttribute("bookDTO", new BookDTO());
        List<Author> authors = authorService.getAllAuthors();  // Get all authors
        model.addAttribute("authors", authors); 
        model.addAttribute("categories", Category.values());
        return "add-book";
    }

    // 📖 Show detailed view of a single book (with suggestions)
    @GetMapping({"/bookdetails"})
    public String bookdetails(@RequestParam("bookId") Integer bookId, Model model){
        BookDTO book = bookService.getBookById(bookId);
        model.addAttribute("book", book);

        List<BookDTO> books = bookService.getAllBooksWithAuthorName();
        model.addAttribute("suggestedBooks", books);

        return "book-details";
    }

    // 👤 Show all books by a specific author
    @GetMapping({"/author/details"})
    public String authorDetails(@RequestParam("id") Integer authorId, Model model) {
        Author author = authorService.getAuthorById(authorId);
        if (author == null) {
            return "redirect:/bookstore/home"; // fallback if author not found
        }

        List<BookDTO> books = bookService.getAllBooksByAuthorId(authorId);
        model.addAttribute("author", author);
        model.addAttribute("books", books);

        System.out.println("getting author details");
        return "author-details";
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
            redirectAttributes.addFlashAttribute("message", "Writer " + author.getAuthorName() + " added successfully. Select the writer when uploading the book.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not add writer: " + e.getMessage());
        }
        return "redirect:/bookstore/addbook";
    }

    // 🏷️ Browse by category
    @GetMapping("/category/{category}")
    public String category(@PathVariable String category, Authentication authentication, Model model) {
        if (authentication != null) {
            boolean seller = authentication.getAuthorities().stream().anyMatch(a -> "ROLE_SELLER".equals(a.getAuthority()));
            boolean admin = authentication.getAuthorities().stream().anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
            if (seller) return "redirect:/bookstore/seller";
            if (admin) return "redirect:/bookstore/admin";
        }
        try {
            Category c = Category.valueOf(category.trim().toUpperCase().replace('-', '_'));
            model.addAttribute("category", c);
            model.addAttribute("books", bookService.getBooksByCategory(c));
            return "category";
        } catch (IllegalArgumentException ex) {
            return "redirect:/bookstore/home";
        }
    }

    // 📤 Save new book from seller (with image upload)
    @PostMapping("save")
    public String addNewBook(@ModelAttribute BookDTO bookDTO,
                            @RequestParam("image") MultipartFile imageFile,
                            RedirectAttributes redirectAttributes) {

        try {
            bookService.saveBook(bookDTO, imageFile);
            redirectAttributes.addFlashAttribute("message", "Book saved successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Could not save book: " + e.getMessage());
        }

        return "redirect:/bookstore/seller";
    }

    // ❌ Delete a book by ID (admin functionality)
    @GetMapping("admin/deleteBook/{bookId}")
    public String deleteBookById(@PathVariable("bookId") Integer bookId) {
        bookService.deleteBook(bookId);
        return "redirect:/bookstore/home";
    }

    // 🔍 Search for books by keyword (viewbook.jsp page)
    @GetMapping("/viewbook")
    public String viewBookResults(@RequestParam String keyword, Model model) {
        List<Book> searchedBooks = bookService.getBooksByKeyword(keyword);
        List<Book> suggestedBooks = bookService.getAllBooks(); // fallback suggestions

        model.addAttribute("keyword", keyword);
        model.addAttribute("searchedBooks", searchedBooks);
        model.addAttribute("suggestedBooks", suggestedBooks);

        return "viewbook";
    }

    @GetMapping("/purpose")
    public String purposePage() { return "purpose"; }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
    @GetMapping("/register")
    public String getRegisterPage() {
        return "register";
    }

}
