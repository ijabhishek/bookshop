package com.bookshop.model;

import java.time.LocalDateTime;
import java.util.List;
import java.util.PrimitiveIterator;

import lombok.Data;

@Data
public class Order {
    private final int orderId;
    private final User user;
    private final List<OrderItem> orderItems;
    private final LocalDateTime orderDate;
    private final Status status;
    private final double totalAmount;

    

}
