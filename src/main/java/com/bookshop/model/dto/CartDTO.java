package com.bookshop.model.dto;

import java.util.List;

import com.bookshop.model.CartItem;
import com.bookshop.model.User;

public class CartDTO {
    private int id;
    private User user;
    private List<CartItem> items;
    private double totalPrice;
      
}
