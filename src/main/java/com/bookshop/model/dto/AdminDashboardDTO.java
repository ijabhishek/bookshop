package com.bookshop.model.dto;

import java.util.List;
import java.util.Map;

import com.bookshop.model.Order;
import com.bookshop.model.Status;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// Aggregated numbers shown on the Admin analytics dashboard: catalogue size,
// order volume, revenue, best sellers and a status breakdown for the
// "purchase sales and orders received" overview.
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminDashboardDTO {
    private long totalBooks;
    private long totalOrders;
    private long totalUsers;
    private double totalRevenue;
    private double revenueLast30Days;
    private Map<Status, Long> ordersByStatus;
    private List<TopSellingBook> topSellingBooks;
    private List<Order> recentOrders;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TopSellingBook {
        private String title;
        private long quantitySold;
    }
}
