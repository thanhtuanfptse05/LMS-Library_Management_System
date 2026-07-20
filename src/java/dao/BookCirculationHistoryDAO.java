package dao;

import dto.BookCirculationHistoryDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DatabaseConnection;

public class BookCirculationHistoryDAO {

    public int countByBookCopyId(int bookCopyId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM BorrowRecord WHERE bookCopyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<BookCirculationHistoryDTO> findByBookCopyId(int bookCopyId, int offset, int pageSize)
            throws SQLException {
        String sql = "SELECT br.borrowRecordId, br.startDate, br.endDate, br.returnedAt, "
                + "CASE WHEN br.status = 'borrowed' AND br.endDate < NOW() THEN 'overdue' ELSE br.status END AS status, "
                + "br.extensionCount, "
                + "COALESCE(mp.fullName, u.email) AS memberName, "
                + "COALESCE(s.studentCode, l.lecturerCode, u.email) AS memberCode, "
                + "COALESCE(createdProfile.fullName, createdUser.email, 'Hệ thống') AS createdByName "
                + "FROM BorrowRecord br "
                + "JOIN \"User\" u ON br.userId = u.userId "
                + "LEFT JOIN MemberProfile mp ON br.userId = mp.userId "
                + "LEFT JOIN Student s ON br.userId = s.userId "
                + "LEFT JOIN Lecturer l ON br.userId = l.userId "
                + "LEFT JOIN \"User\" createdUser ON br.createdBy = createdUser.userId "
                + "LEFT JOIN MemberProfile createdProfile ON br.createdBy = createdProfile.userId "
                + "WHERE br.bookCopyId = ? "
                + "ORDER BY br.startDate DESC, br.borrowRecordId DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookCopyId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                List<BookCirculationHistoryDTO> histories = new ArrayList<>();
                while (rs.next()) {
                    histories.add(map(rs));
                }
                return histories;
            }
        }
    }

    private BookCirculationHistoryDTO map(ResultSet rs) throws SQLException {
        BookCirculationHistoryDTO item = new BookCirculationHistoryDTO();
        item.setBorrowRecordId(rs.getInt("borrowRecordId"));
        item.setMemberName(rs.getString("memberName"));
        item.setMemberCode(rs.getString("memberCode"));
        item.setStartDate(rs.getTimestamp("startDate"));
        item.setEndDate(rs.getTimestamp("endDate"));
        item.setReturnedAt(rs.getTimestamp("returnedAt"));
        item.setStatus(rs.getString("status"));
        item.setExtensionCount(rs.getInt("extensionCount"));
        item.setCreatedByName(rs.getString("createdByName"));
        return item;
    }
}
