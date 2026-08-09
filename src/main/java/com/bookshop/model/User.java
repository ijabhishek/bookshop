package com.bookshop.model;

import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.bookshop.model.Order;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "users")
public class User {

    @Id
    private String userId;
    private String firstName;
    private String password;
    private String email;
    private String phoneNumber;
    private String role;
    private String address;
    @OneToMany(mappedBy = "user")
    private List<Order> orders;

    
}
