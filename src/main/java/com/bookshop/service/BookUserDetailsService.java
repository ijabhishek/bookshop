package com.bookshop.service;

import java.security.PrivateKey;
import java.util.PrimitiveIterator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.bookshop.model.User;
import com.bookshop.model.UserPrincipal;
import com.bookshop.repository.BookUserRepo;

@Service
public class BookUserDetailsService implements UserDetailsService{

    @Autowired
    private BookUserRepo bookUserRepo;
    

    @Override
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
        // TODO Auto-generated method stub

        User user = bookUserRepo.findByUserId(userId);

        if(user == null) {
            System.out.println("User not found");

            throw new UsernameNotFoundException("User 404");

        }

        return new UserPrincipal(user);
    }

    public User savUser(User user) {
        return bookUserRepo.save(user);
    }


    
}
