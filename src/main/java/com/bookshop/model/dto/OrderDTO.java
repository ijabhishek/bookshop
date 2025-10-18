package com.bookshop.model.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.bookshop.model.Status;

import lombok.Data;

@Data
public class OrderDTO {
    private int orderId;
    private String customerName;
    private String userEmail;
    private List<OrderItemDTO> orderItems;
    private LocalDateTime orderDate;
    private Status status;
    private double totalAmount;
    
}
