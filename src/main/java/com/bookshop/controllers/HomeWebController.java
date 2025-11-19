//Controller For HomePage 

package com.bookshop.controllers;

import java.io.IOException;
import java.util.List;

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

    @Autowired
    private AuthorService authorService;

    @Autowired
    private BookService bookService;

    // 🏠 Load homepage with list of all books (including author names)
    @GetMapping({"/home"})
    public String getBooksWithAuthor(Model model) {
        model.addAttribute("books", bookService.getAllBooksWithAuthorName());
        return "home";
    }

    // 🛠️ Admin panel: load admin page with all books and authors
    @GetMapping({"/admin"})
    public String getAdminPage(Model model){
        List<BookDTO> books = bookService.getAllBooksWithAuthorName();
        model.addAttribute("books", books);

        List<Author> authors = authorService.getAllAuthors();  // Get all authors
        model.addAttribute("authors", authors);

        return "admin";
    }

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
    public String getSellerPage(){
        return "seller";
    }

    // 📚 Page for seller to add a new book
    @GetMapping({"/addbook"})
    public String addNewBook(Model model){
        model.addAttribute("bookDTO", new BookDTO());
        List<Author> authors = authorService.getAllAuthors();  // Get all authors
        model.addAttribute("authors", authors); 
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

    // 📤 Save new book from seller (with image upload)
    @PostMapping("save")
    public String addNewBook(@ModelAttribute BookDTO bookDTO,
                            @RequestParam("image") MultipartFile imageFile,
                            RedirectAttributes redirectAttributes) {

        try {
            bookService.saveBook(bookDTO, imageFile);
            redirectAttributes.addFlashAttribute("message", "Book saved successfully!");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Error saving book.");
        }

        // Debug logs
        System.out.println("Received bookDTO: " + bookDTO);
        System.out.println("Received file: " + imageFile.getOriginalFilename());
        System.out.println("Book is uploaded");

        return "seller";
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

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
    @GetMapping("/register")
    public String getRegisterPage() {
        return "register";
    }

}
