package com.bookshop.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bookshop.model.Order;
import com.bookshop.model.Status;
import com.bookshop.model.dto.AdminDashboardDTO;
import com.bookshop.repository.BookRepo;
import com.bookshop.repository.BookUserRepo;
import com.bookshop.repository.OrderRepository;

// Builds the numbers behind the Admin "analyse purchase sales and orders
// received" dashboard: totals, revenue, order-status breakdown and best
// sellers.
@Service
public class AdminService {

    @Autowired
    private BookRepo bookRepo;

    @Autowired
    private BookUserRepo bookUserRepo;

    @Autowired
    private OrderRepository orderRepository;

    public AdminDashboardDTO buildDashboard() {
        long totalBooks = bookRepo.count();
        long totalUsers = bookUserRepo.count();
        long totalOrders = orderRepository.count();
        double totalRevenue = orderRepository.getTotalRevenue();
        double revenueLast30Days = orderRepository.getRevenueSince(LocalDateTime.now().minusDays(30));

        Map<Status, Long> ordersByStatus = new EnumMap<>(Status.class);
        for (Status status : Status.values()) {
            ordersByStatus.put(status, orderRepository.countByStatus(status));
        }

        List<AdminDashboardDTO.TopSellingBook> topSellers = new ArrayList<>();
        for (Object[] row : orderRepository.findTopSellingBooks()) {
            String title = (String) row[0];
            long qty = ((Number) row[1]).longValue();
            topSellers.add(new AdminDashboardDTO.TopSellingBook(title, qty));
            if (topSellers.size() >= 5) {
                break;
            }
        }

        List<Order> recentOrders = orderRepository.findAllByOrderByOrderDateDesc();
        if (recentOrders.size() > 10) {
            recentOrders = recentOrders.subList(0, 10);
        }

        return new AdminDashboardDTO(totalBooks, totalOrders, totalUsers, totalRevenue,
                revenueLast30Days, ordersByStatus, topSellers, recentOrders);
    }
}
