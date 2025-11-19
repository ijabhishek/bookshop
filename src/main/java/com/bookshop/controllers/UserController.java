package com.bookshop.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bookshop.model.User;
import com.bookshop.service.BookUserDetailsService;


@Controller
@RequestMapping("/bookstore")
public class UserController {

    @Autowired
    private BookUserDetailsService userService;
    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);


    @PostMapping("/registerUser")
    public String register(@ModelAttribute User user){
        user.setPassword(encoder.encode(user.getPassword()));
        System.out.println(user.getPassword());
        userService.savUser(user);

        return "login";
        

        
    }


    
}
