package com.bookshop.model;

import java.time.LocalDateTime;
import java.util.List;
import java.util.PrimitiveIterator;

public class Order {
    private int orderId;
    private User user;
    private List<OrderItem> items;
    private LocalDateTime OrderDate;
    private Status status;
    private double totalAmount;

    

}
