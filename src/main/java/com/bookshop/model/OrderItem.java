package com.bookshop.model;

import lombok.Data;

@Data
public class OrderItem {
    private final int id;
    private final Order order;
    private final Book book;
    private final int quantity;
    private final double priceAtPurchase;

    

}
