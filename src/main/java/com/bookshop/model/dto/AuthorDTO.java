package com.bookshop.model.dto;

import java.time.LocalDate;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AuthorDTO {
    private int id;
    private String authorName;
    private String imageUrl;
    private String biography;
    private LocalDate birthDate;
    private String nationality;
    private List<String> bookNames; 
    
}
