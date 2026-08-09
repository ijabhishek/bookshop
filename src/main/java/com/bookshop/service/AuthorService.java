package com.bookshop.service;

import java.io.IOException;
import java.nio.file.*;
import java.util.*;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.bookshop.model.*;
import com.bookshop.model.dto.AuthorDTO;
import com.bookshop.repository.AuthorRepo;

@Service
public class AuthorService {
    @Autowired private AuthorRepo authorRepo;
    @Autowired private ModelMapper modelMapper;
    @Value("${images.books.cover}") private String uploadDir;

    public AuthorService(AuthorRepo authorRepo, ModelMapper modelMapper) {
        this.authorRepo = authorRepo; this.modelMapper = modelMapper;
    }
    public List<Author> getAllAuthors(){ return authorRepo.findAll(); }
    public Author getAuthorById(Integer id){ return id == null ? null : authorRepo.findById(id).orElse(null); }

    public Author createAuthor(String name, MultipartFile image, java.time.LocalDate dob,
                               String biography, String birthPlace, Category category) throws IOException {
        Author a = new Author();
        a.setAuthorName(name);
        a.setBirthDate(dob);
        a.setBirthPlace(birthPlace);
        a.setBiography(biography);
        a.setCategory(category);
        if (image != null && !image.isEmpty()) {
            Path dir = Paths.get(uploadDir);
            Files.createDirectories(dir);
            String ext = ".jpg";
            String original = image.getOriginalFilename();
            if (original != null && original.contains(".")) ext = original.substring(original.lastIndexOf('.'));
            String fileName = "author-" + UUID.randomUUID() + ext;
            Files.copy(image.getInputStream(), dir.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
            a.setImageUrl("/images/books/cover/" + fileName);
        }
        return authorRepo.save(a);
    }

    public Author getOrCreateSimpleAuthor(String name, Category category) {
        return authorRepo.findByAuthorNameIgnoreCase(name)
                .orElseGet(() -> {
                    Author a = new Author();
                    a.setAuthorName(name);
                    a.setCategory(category);
                    return authorRepo.save(a);
                });
    }

    public List<AuthorDTO> getAuthorsWithBookName() {
        return getAllAuthors().stream().map(author -> new AuthorDTO(
            author.getId(), author.getImageUrl(), author.getAuthorName(), author.getBiography(),
            author.getBirthDate(), author.getBirthPlace(), author.getNationality(),
            author.getBooks() == null ? List.of() : author.getBooks().stream().map(Book::getTitle).toList()
        )).toList();
    }

    public Author updateAuthor(int id, String name, MultipartFile image, java.time.LocalDate dob,
                               String biography, String birthPlace, Category category) throws IOException {
        Author a = authorRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Writer not found."));
        a.setAuthorName(name);
        a.setBirthDate(dob);
        a.setBirthPlace(birthPlace);
        a.setBiography(biography);
        a.setCategory(category);
        if (image != null && !image.isEmpty()) {
            Path dir = Paths.get(uploadDir);
            Files.createDirectories(dir);
            String ext = ".jpg";
            String original = image.getOriginalFilename();
            if (original != null && original.contains(".")) ext = original.substring(original.lastIndexOf('.'));
            String fileName = "author-" + UUID.randomUUID() + ext;
            Files.copy(image.getInputStream(), dir.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
            a.setImageUrl("/images/books/cover/" + fileName);
        }
        return authorRepo.save(a);
    }

}
