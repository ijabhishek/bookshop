package com.bookshop.model;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookDTO {
    private int bookId;
    private String isbn;
    private String title;
    private String imageUrl;
    private Author author;
    private int authorId;
    private String authorName;
    private double sellingPrice;
    private String bookDescription;
    private Category category;
    private LocalDate publishedYear;
    private int stock;
    private double discountedPrice;
    private boolean bookAvailable;
}

