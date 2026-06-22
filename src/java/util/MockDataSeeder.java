package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MockDataSeeder {
    public static void main(String[] args) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            System.out.println("Connected to the database. Generating mock data for Financial Trends...");
            
            // 1. Get a user
            int userId = -1;
            try (PreparedStatement ps = conn.prepareStatement("SELECT userId FROM \"User\" LIMIT 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    userId = rs.getInt("userId");
                }
            }
            
            // 2. Get a book copy
            int bookCopyId = -1;
            int bookId = -1;
            try (PreparedStatement ps = conn.prepareStatement("SELECT bookCopyId, bookId FROM BookCopy LIMIT 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    bookCopyId = rs.getInt("bookCopyId");
                    bookId = rs.getInt("bookId");
                }
            }
            
            if (userId == -1 || bookCopyId == -1) {
                System.out.println("Cannot generate mock data: No user or book copy found.");
                return;
            }
            
            // Arrays of days ago to create data for different months
            int[] daysAgo = {60, 45, 30, 15, 5, 2};
            
            for (int days : daysAgo) {
                // Insert BorrowRecord
                int borrowId = -1;
                String insertBorrow = "INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount) " +
                                      "VALUES (?, ?, ?, NOW() - INTERVAL '? days', NOW() - INTERVAL '? days', NULL, 'overdue', 0) RETURNING borrowRecordId";
                // We'll hardcode intervals to avoid prepared statement issues with intervals
                String sqlBorrow = "INSERT INTO BorrowRecord (userId, bookCopyId, bookId, startDate, endDate, returnedAt, status, extensionCount) " +
                                      "VALUES (?, ?, ?, NOW() - INTERVAL '" + (days + 20) + " days', NOW() - INTERVAL '" + (days + 10) + " days', NULL, 'overdue', 0) RETURNING borrowRecordId";
                
                try (PreparedStatement ps = conn.prepareStatement(sqlBorrow)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, bookCopyId);
                    ps.setInt(3, bookId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            borrowId = rs.getInt("borrowRecordId");
                        }
                    }
                }
                
                if (borrowId != -1) {
                    // Create Fine (Unpaid)
                    int fineId = -1;
                    String sqlFine = "INSERT INTO Fine (borrowRecordId, userId, amount, reason, status, createdAt) " +
                                     "VALUES (?, ?, ?, 'Quá hạn trả sách (tạo tự động)', 'unpaid', NOW() - INTERVAL '" + days + " days') RETURNING fineId";
                    try (PreparedStatement ps = conn.prepareStatement(sqlFine)) {
                        ps.setInt(1, borrowId);
                        ps.setInt(2, userId);
                        ps.setDouble(3, 50000.00); // 50,000 VND
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                fineId = rs.getInt("fineId");
                            }
                        }
                    }
                    
                    // Half of them get paid
                    if (fineId != -1 && days % 2 == 0) {
                        // Mark fine as paid
                        String updateFine = "UPDATE Fine SET status = 'paid' WHERE fineId = ?";
                        try (PreparedStatement ps = conn.prepareStatement(updateFine)) {
                            ps.setInt(1, fineId);
                            ps.executeUpdate();
                        }
                        
                        // Create Payment
                        String sqlPayment = "INSERT INTO Payment (fineId, paidAmount, paymentMethod, transactionReference, status, paidAt) " +
                                            "VALUES (?, ?, 'cash', 'MOCK_TXN_' || floor(random() * 1000000)::text, 'paid', NOW() - INTERVAL '" + (days - 1) + " days')";
                        try (PreparedStatement ps = conn.prepareStatement(sqlPayment)) {
                            ps.setInt(1, fineId);
                            ps.setDouble(2, 50000.00);
                            ps.executeUpdate();
                        }
                    }
                }
            }
            
            System.out.println("Mock data for Financial Trends successfully inserted!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
