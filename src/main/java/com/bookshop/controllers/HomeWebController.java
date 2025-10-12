package com.bookshop.controllers;

import java.io.IOException;
import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bookshop.model.Author;
import com.bookshop.model.Book;
import com.bookshop.model.BookDTO;
import com.bookshop.service.AuthorService;
import com.bookshop.service.BookService;

@Controller
@RequestMapping("/bookstore")
public class HomeWebController {

    @Autowired
    private AuthorService authorService;
    @Autowired
    private BookService bookService;

    @GetMapping({"/home"})
    public String getBooksWithAuthor(Model model) {
        model.addAttribute("books", bookService.getAllBooksWithAuthorName());
        return "home";
    }
    @GetMapping({"/admin"})
    public String getAdminPage(Model model){
        List<BookDTO> books = bookService.getAllBooksWithAuthorName();
        model.addAttribute("books", books);
        List<Author> authors = authorService.getAllAuthors();  // Get all authors
        model.addAttribute("authors", authors);
        return "admin";
    }
    @GetMapping({"admin/editBook/{bookId}"})
    public String editBookByAdmin(@PathVariable Integer bookId, Model model){
        BookDTO book = bookService.getBookById(bookId);
        model.addAttribute("book", book);
        List<Author> authors = authorService.getAllAuthors();
        model.addAttribute("authors", authors);
        return "editBook";

    }

    // @PostMapping("{}")
    @GetMapping({"/seller"})
    public String getSellerPage(){
        return "seller";
    }
    @GetMapping({"/mycart"})
    public String getCart() {
        return "cart";
    }
    @GetMapping({"/addbook"})
    public String addNewBook(Model model){
        model.addAttribute("bookDTO", new BookDTO());
        List<Author> authors = authorService.getAllAuthors();  // Get all authors
        model.addAttribute("authors", authors); 
        return "add-book";
    }
    
    @GetMapping({"/bookdetails"})
    public String bookdetails(@RequestParam("bookId") Integer bookId, Model model){
        BookDTO book = bookService.getBookById(bookId);
        model.addAttribute("book", book);
        List<BookDTO> books = bookService.getAllBooksWithAuthorName();
        model.addAttribute("suggestedBooks", books);

        return "book-details";
    }
    @GetMapping({"/author/details"})
    public String authorDetails(@RequestParam("id") Integer authorId, Model model) {
        Author author = authorService.getAuthorById(authorId);
        if (author == null) {
            return "redirect:/bookstore/home"; // or a 404 page
        }

        List<BookDTO> books = bookService.getAllBooksByAuthorId(authorId);
        model.addAttribute("author", author);
        model.addAttribute("books", books);
        System.out.println("getting author details");
        return "author-details";
        

    }



     @PostMapping("save")
     public String addNewBook(@ModelAttribute BookDTO bookDTO,
                            @RequestParam("image") MultipartFile imageFile,
                            RedirectAttributes redirectAttributes ) {

                try {
                    bookService.saveBook(bookDTO, imageFile);
                    redirectAttributes.addFlashAttribute("message", "Book saved successfully!");

                }
                catch (IOException e) {
                    
                    redirectAttributes.addFlashAttribute("error", "Error saving book.");

                }
                System.out.println("Received bookDTO: " + bookDTO);
                System.out.println("Received file: " + imageFile.getOriginalFilename());

            System.out.println("Book is uploaded");

            return "seller";

                


     }


    
    
}
