package com.bookshop.model;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity

public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int bookId;
    private String isbn;
    private String title;
    private LocalDate publishedYear;
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "author_id", nullable = false)
    // Use DTOs for all responses. It’s more flexible, prevents infinite
    @JsonIgnoreProperties({"books", "biography", "birthDate", "nationality"})

    private Author author;
    private double sellingPrice;
    private double discountedPrice;
    @Column(name="book_description")
    private String bookDescription;
    private int stock;
    private String imageUrl;
    @Enumerated(EnumType.STRING)
    private Category category;
    private boolean bookAvailable;






    
}
