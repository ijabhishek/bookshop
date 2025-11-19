package com.bookshop.service;


import java.time.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookshop.model.Book;
import com.bookshop.model.Order;
import com.bookshop.model.OrderItem;
import com.bookshop.model.Status;
import com.bookshop.model.dto.BookDTO;

import com.bookshop.repository.OrderItemRepository;
import com.bookshop.repository.OrderRepository;

import jakarta.transaction.Transactional;

import java.util.UUID;

@Service
public class OrderService {

    @Autowired
    private CartService cartService;

    @Autowired
    private BookService bookService;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Transactional
    public Order placeOrder() {
        // Get all items from the cart
        Map<BookDTO, Integer> cartItems = cartService.getCartDetails();

        if(cartItems.isEmpty()) {
            throw new RuntimeException("Cart is empty. Cannot place order");
        
        }

        // Calculate total 
        double totalAmount = cartService.getCartTotal();

        // Create new order
        Order order = new Order();
        order.setStatus(Status.PENDING);
        order.setOrderDate(LocalDateTime.now());
        order.setTotalAmount(totalAmount);

        String orderNumber = "ORD-" 
        + LocalDate.now().toString().replace("-", "") + "-" 
        + UUID.randomUUID().toString().substring(0, 6).toUpperCase();        order.setOrderNumber(orderNumber);

        Order savedOrder = orderRepository.save(order);

        //Convert cart items -> Order items
        List<OrderItem> orderItems = new ArrayList<>();

        for (Map.Entry<BookDTO, Integer> entry : cartItems.entrySet()) {
            BookDTO bookDTO = entry.getKey();
            int quantity = entry.getValue();

            //Convert DTO -> enity
            Book book = bookService.getBookEntityById(bookDTO.getBookId());
            
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(savedOrder);
            orderItem.setBook(book);
            orderItem.setQuantity(quantity);
            orderItem.setPriceAtPurchase(book.getDiscountedPrice());
            orderItems.add(orderItem);

        }

        orderItemRepository.saveAll(orderItems);

        // Clear cart after successful order
        cartService.clearCart();

        return savedOrder;
          

    }

    


}
