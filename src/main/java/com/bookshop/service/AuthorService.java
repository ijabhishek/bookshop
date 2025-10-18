package com.bookshop.service;

import java.util.List;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookshop.model.Author;
import com.bookshop.model.dto.AuthorDTO;
import com.bookshop.model.Book;
import com.bookshop.repository.AuthorRepo;

@Service
public class AuthorService {
    @Autowired
    private AuthorRepo authorRepo;

    @Autowired
    private ModelMapper modelMapper;

    public AuthorService(AuthorRepo authorRepo, ModelMapper modelMapper) {
        this.authorRepo = authorRepo;
        this.modelMapper = modelMapper;
    }
    
    public List<Author> getAllAuthors(){
        return authorRepo.findAll();
    }
    public Author getAuthorById(Integer id){
        return authorRepo.findById(id).orElse(null);
    }
    public List<AuthorDTO> getAuthorsWithBookName() {
        return getAllAuthors().stream()
            .map(author -> new AuthorDTO(
                author.getId(),
                author.getImageUrl(),
                author.getAuthorName(),
                author.getBiography(),
                author.getBirthDate(),
                author.getNationality(),
                author.getBooks().stream().map(Book::getTitle).toList()

            )).toList();
    }
    
}
