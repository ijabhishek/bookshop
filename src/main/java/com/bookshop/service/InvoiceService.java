package com.bookshop.service;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Service;

import com.bookshop.model.Order;
import com.bookshop.model.OrderItem;
import com.bookshop.model.User;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

// Builds a downloadable PDF invoice for a placed order.
@Service
public class InvoiceService {

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    public byte[] generateInvoice(Order order) {
        try {
            Document document = new Document(PageSize.A4, 40, 40, 50, 50);
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, out);
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, new Color(31, 41, 55));
            Font headingFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, new Color(31, 41, 55));
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.DARK_GRAY);
            Font tableHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.WHITE);

            // ---- Header ----
            Paragraph title = new Paragraph("BookShop - Invoice", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            Paragraph sub = new Paragraph("Order #" + order.getOrderNumber(), normalFont);
            sub.setAlignment(Element.ALIGN_CENTER);
            sub.setSpacingAfter(20);
            document.add(sub);

            // ---- Order + customer details ----
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.setSpacingAfter(20);

            User user = order.getUser();
            String customerBlock = "Bill To:\n"
                    + (user != null ? nullSafe(user.getFirstName()) : "Guest") + "\n"
                    + (user != null ? nullSafe(user.getEmail()) : "") + "\n"
                    + (user != null ? nullSafe(user.getPhoneNumber()) : "") + "\n"
                    + (user != null ? nullSafe(user.getAddress()) : "");

            String orderBlock = "Order Date: "
                    + (order.getOrderDate() != null ? order.getOrderDate().format(DATE_FMT) : "-") + "\n"
                    + "Status: " + order.getStatus() + "\n"
                    + "Order Number: " + order.getOrderNumber();

            PdfPCell customerCell = new PdfPCell(new Paragraph(customerBlock, normalFont));
            customerCell.setBorder(0);
            infoTable.addCell(customerCell);

            PdfPCell orderCell = new PdfPCell(new Paragraph(orderBlock, normalFont));
            orderCell.setBorder(0);
            orderCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            infoTable.addCell(orderCell);

            document.add(infoTable);

            // ---- Line items ----
            PdfPTable table = new PdfPTable(new float[]{4f, 1.2f, 1.4f, 1.4f});
            table.setWidthPercentage(100);

            String[] headers = {"Book", "Qty", "Unit Price (₹)", "Subtotal (₹)"};
            for (String h : headers) {
                PdfPCell cell = new PdfPCell(new Paragraph(h, tableHeaderFont));
                cell.setBackgroundColor(new Color(31, 41, 55));
                cell.setPadding(6);
                table.addCell(cell);
            }

            if (order.getOrderItems() != null) {
                for (OrderItem item : order.getOrderItems()) {
                    String bookTitle = item.getBook() != null ? item.getBook().getTitle() : "Unknown";
                    double subtotal = item.getPriceAtPurchase() * item.getQuantity();

                    table.addCell(cellOf(bookTitle, normalFont));
                    table.addCell(cellOf(String.valueOf(item.getQuantity()), normalFont));
                    table.addCell(cellOf(String.format("%.2f", item.getPriceAtPurchase()), normalFont));
                    table.addCell(cellOf(String.format("%.2f", subtotal), normalFont));
                }
            }

            document.add(table);

            // ---- Total ----
            Paragraph total = new Paragraph(
                    "\nTotal Amount: Rs. " + String.format("%.2f", order.getTotalAmount()), headingFont);
            total.setAlignment(Element.ALIGN_RIGHT);
            total.setSpacingBefore(15);
            document.add(total);

            Paragraph footer = new Paragraph(
                    "\nThank you for shopping with BookShop!", normalFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setSpacingBefore(30);
            document.add(footer);

            document.close();
            return out.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate invoice PDF for order " + order.getOrderNumber(), e);
        }
    }

    private PdfPCell cellOf(String text, Font font) {
        PdfPCell cell = new PdfPCell(new Paragraph(text, font));
        cell.setPadding(5);
        return cell;
    }

    private String nullSafe(String value) {
        return value == null ? "" : value;
    }
}
