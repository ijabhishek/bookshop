package com.bookshop.controllers;

import java.util.List;

import org.eclipse.tags.shaded.org.apache.regexp.recompile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bookshop.model.dto.AuthorDTO;
import com.bookshop.model.dto.BookDTO;
import com.bookshop.service.AuthorService;
import com.bookshop.service.BookService;

@RestController
@RequestMapping("/api")
public class HomeController {

    @Autowired
    private BookService bookService;
    @Autowired
    private AuthorService authorService;
    @GetMapping({"/books"})
    public ResponseEntity<List<BookDTO>> getBooks(){
       return new ResponseEntity<>(bookService.getAllBooksWithAuthorName(), HttpStatus.OK);
    }
    @GetMapping({"/book/authors"})
    public ResponseEntity<List<AuthorDTO>> getAuthors(){
       return new ResponseEntity<>(authorService.getAuthorsWithBookName(), HttpStatus.OK);
    }

   
    
}
