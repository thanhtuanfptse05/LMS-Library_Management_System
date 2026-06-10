package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Tag;
import util.DatabaseConnection;

public class TagDAO {

    public List<Tag> findAll() throws SQLException {
        String sql = "SELECT tagId, name FROM Tag ORDER BY name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Tag> tags = new ArrayList<>();
            while (rs.next()) {
                Tag tag = new Tag();
                tag.setTagId(rs.getInt("tagId"));
                tag.setName(rs.getString("name"));
                tags.add(tag);
            }
            return tags;
        }
    }
}
