package com.bookshop.service;


import java.time.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.bookshop.model.Book;
import com.bookshop.model.Order;
import com.bookshop.model.OrderItem;
import com.bookshop.model.Status;
import com.bookshop.model.User;
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
    private BookUserDetailsService userService;

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

        // Look up the currently authenticated customer so the order (and its
        // invoice / shipping address) can actually be tied back to them.
        String currentUserId = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userService.findByUserId(currentUserId);
        if (user == null) {
            throw new RuntimeException("Unable to place order: logged-in user not found");
        }

        // Create new order
        Order order = new Order();
        order.setUser(user);
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

            // Convert DTO -> entity and reserve stock atomically.
            Book book = bookService.getBookEntityById(bookDTO.getBookId());
            if (!book.isBookAvailable() || book.getStock() < quantity) {
                throw new RuntimeException("Not enough stock for: " + book.getTitle());
            }
            book.setStock(book.getStock() - quantity);
            book.setBookAvailable(book.getStock() > 0);

            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(savedOrder);
            orderItem.setBook(book);
            orderItem.setQuantity(quantity);
            orderItem.setPriceAtPurchase(book.getDiscountedPrice());
            orderItems.add(orderItem);

        }

        orderItemRepository.saveAll(orderItems);
        savedOrder.setOrderItems(orderItems);

        // Clear cart after successful order
        cartService.clearCart();

        return savedOrder;

    }

    public List<Order> getOrdersForUser(String userId) {
        return orderRepository.findByUser_UserIdOrderByOrderDateDesc(userId);
    }

    public Order getOrderByNumber(String orderNumber) {
        return orderRepository.findByOrderNumber(orderNumber);
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAllByOrderByOrderDateDesc();
    }


    @Transactional
    public void cancelOrder(String orderNumber, String userId) {
        Order order = orderRepository.findByOrderNumber(orderNumber);
        if (order == null) throw new RuntimeException("Order not found.");
        if (order.getUser() == null || !order.getUser().getUserId().equals(userId)) {
            throw new org.springframework.security.access.AccessDeniedException("You can only cancel your own orders.");
        }
        if (order.getStatus() == Status.CANCELLED || order.getStatus() == Status.DELIVERED) {
            throw new IllegalStateException("This order cannot be canceled.");
        }
        if (order.getOrderItems() != null) {
            for (OrderItem item : order.getOrderItems()) {
                Book book = item.getBook();
                if (book != null) {
                    book.setStock(book.getStock() + item.getQuantity());
                    book.setBookAvailable(book.getStock() > 0);
                }
            }
        }
        // Keep the canceled order in the database so Admin/Sales can see the
        // cancellation in the order history and status dashboard.
        order.setStatus(Status.CANCELLED);
        orderRepository.save(order);
    }

    @Transactional
    public Order updateOrderStatus(int orderId, Status status) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found with ID: " + orderId));
        if (order.getStatus() == Status.DELIVERED || order.getStatus() == Status.CANCELLED) {
            throw new IllegalStateException("Delivered or cancelled orders cannot be changed.");
        }
        order.setStatus(status);
        return orderRepository.save(order);
    }

}
