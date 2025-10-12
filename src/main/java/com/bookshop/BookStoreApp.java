package com.bookshop;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.bookshop")
public class BookStoreApp {
    public static void main(String[] args) {
        SpringApplication.run(BookStoreApp.class, args);
        
    }
}
