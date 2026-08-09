package com.bookshop.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

// Makes plain http://localhost:9090/ work by sending people straight to the
// bookstore home page, instead of a 404.
@Controller
public class RootController {

    @GetMapping("/")
    public String root() {
        return "redirect:/bookstore/home";
    }
}
