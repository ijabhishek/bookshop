package com.bookshop.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.bookshop.model.Author;
import com.bookshop.model.Book;
import com.bookshop.model.BookDTO;
import com.bookshop.repository.AuthorRepo;
import com.bookshop.repository.BookRepo;

@Service
public class BookService {

    @Value("${images.books.cover}")
    private String uploadDir;

    @Autowired
    private AuthorService authorService;
    @Autowired
    private BookRepo bookRepo;

    @Autowired
    private ModelMapper modelMapper;

    public BookService(BookRepo bookrepo, ModelMapper modelMapper, AuthorService authorService) {
        this.bookRepo = bookrepo;
        this.modelMapper = modelMapper;
        this.authorService = authorService;
    }
    private BookDTO mapToDTO(Book book) {

        BookDTO dto = modelMapper.map(book, BookDTO.class);
        // Explicitly set fields to ensure correct mapping
        // Always map these (not inside any if block)
        dto.setBookId(book.getBookId());
        dto.setIsbn(book.getIsbn());
        dto.setTitle(book.getTitle());
        dto.setImageUrl(book.getImageUrl());
        dto.setSellingPrice(book.getSellingPrice());
        dto.setBookDescription(book.getBookDescription());
        dto.setCategory(book.getCategory());
        dto.setPublishedYear(book.getPublishedYear());
        dto.setStock(book.getStock());
        dto.setDiscountedPrice(book.getDiscountedPrice());
        dto.setBookAvailable(book.isBookAvailable());

        if (book.getAuthor() != null) {
            dto.setAuthorId(book.getAuthor().getId());
            dto.setAuthorName(book.getAuthor().getAuthorName());// assuming getName() exists

        }
        else {
            dto.setAuthorName("Unknown");
        }
        return dto;
    }
    public List<Book> getAllBooks(){
        return bookRepo.findAll();

    }
   
    public BookDTO getBookById(Integer id) {
        return bookRepo.findById(id).map(book-> mapToDTO(book)).orElse(null);
    }

    public List<BookDTO> getAllBooksWithAuthorName() {
        return bookRepo.findAll().stream().map(books-> mapToDTO(books)).toList();
    }

    public List<BookDTO> getAllBooksByAuthorId(int authorId) {
        return bookRepo.findByAuthorId(authorId).stream().map(this::mapToDTO).toList();
    }


    @Transactional
    public Book saveBook(BookDTO bookDTO, MultipartFile imageFile) throws IOException {
        // 1. Ensure directory exists
        File uploadDirectory = new File(uploadDir);
        if (!uploadDirectory.exists()) {
            uploadDirectory.mkdirs();
        }

        // 2. Extract file extension
        String extension = Optional.ofNullable(imageFile.getOriginalFilename())
                                   .filter(f -> f.contains("."))
                                   .map(f -> f.substring(f.lastIndexOf(".")))
                                   .orElse(".jpg");
        
        // 3. Create image file name using ISBN
        String fileName = bookDTO.getIsbn() + extension;
        Path imagePath = Paths.get(uploadDir, fileName);

        // 4. Save file to disk
        Files.copy(imageFile.getInputStream(), imagePath, StandardCopyOption.REPLACE_EXISTING);

        // 5. Set image path (used in frontend)
        bookDTO.setImageUrl("/images/books/cover/" + fileName);

         // 6. Manually map fields from DTO to entity
    
        Book book = new Book();
    
        book.setIsbn(bookDTO.getIsbn());
        book.setTitle(bookDTO.getTitle());
        book.setImageUrl(bookDTO.getImageUrl());
        book.setSellingPrice(bookDTO.getSellingPrice());
        book.setBookDescription(bookDTO.getBookDescription());
        book.setCategory(bookDTO.getCategory());
        book.setPublishedYear(bookDTO.getPublishedYear());
        book.setStock(bookDTO.getStock());
        book.setDiscountedPrice(bookDTO.getDiscountedPrice());
        book.setBookAvailable(bookDTO.isBookAvailable());
        
        // ✅ 4. Fetch the Author entity using authorId
        Author author = authorService.getAuthorById(bookDTO.getAuthorId());
        book.setAuthor(author); // This now works — types match
        return bookRepo.save(book);
        
    }

    // Inside com.bookshop.service.BookService.java

    @Transactional
    public Book updateBook(BookDTO bookDTO, MultipartFile imageFile) throws IOException {
        
        // 1. Fetch the existing Book entity
        // We assume the bookDTO already has the bookId set by the form.
        Book bookToUpdate = bookRepo.findById(bookDTO.getBookId())
                                    .orElseThrow(() -> new RuntimeException("Book with ID " + bookDTO.getBookId() + " not found for update."));
        
        // 2. Handle Image Upload (only if a new file is provided)
        if (imageFile != null && !imageFile.isEmpty()) {
            // Reuse your file upload logic
            String extension = Optional.ofNullable(imageFile.getOriginalFilename())
                                    .filter(f -> f.contains("."))
                                    .map(f -> f.substring(f.lastIndexOf(".")))
                                    .orElse(".jpg");
            
            // Use the new ISBN or existing one for file naming, ensuring replacement if same name
            String fileName = bookDTO.getIsbn() + extension; 
            Path imagePath = Paths.get(uploadDir, fileName);

            Files.copy(imageFile.getInputStream(), imagePath, StandardCopyOption.REPLACE_EXISTING);

            // Update the image URL in the entity
            bookToUpdate.setImageUrl("/images/books/cover/" + fileName);
        }
        // NOTE: If no new image is provided, bookToUpdate.getImageUrl() remains unchanged.


        // 3. Update the non-ID fields of the existing Book entity from the DTO
        
        // Update simple fields
        bookToUpdate.setIsbn(bookDTO.getIsbn());
        bookToUpdate.setTitle(bookDTO.getTitle());
        bookToUpdate.setSellingPrice(bookDTO.getSellingPrice());
        bookToUpdate.setBookDescription(bookDTO.getBookDescription());
        bookToUpdate.setCategory(bookDTO.getCategory());
        bookToUpdate.setPublishedYear(bookDTO.getPublishedYear());
        bookToUpdate.setStock(bookDTO.getStock());
        bookToUpdate.setDiscountedPrice(bookDTO.getDiscountedPrice());
        bookToUpdate.setBookAvailable(bookDTO.isBookAvailable());

        // Update the Author relationship
        Author author = authorService.getAuthorById(bookDTO.getAuthorId());
        bookToUpdate.setAuthor(author);


        // 4. Save the entity. Since the object has an existing ID, Spring Data JPA
        //    performs an UPDATE query instead of an INSERT.
        return bookRepo.save(bookToUpdate);
    }

    public void deleteBook(Integer bookId) {
        bookRepo.deleteById(bookId);
    }

    public List<Book> getBooksByKeyword(String keyword) {
        return bookRepo.findBookByKeyword(keyword);
    }

    


    
}
