package dao;

import utils.DB;

import java.sql.*;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

public class RememberTokenDAO {
    public static class TokenRecord {
        public long id;
        public int customerId;
        public byte[] selector;
        public byte[] validatorHash;
        public Timestamp expiresAt;
    }

    public TokenRecord findBySelector(byte[] selector) throws SQLException {
        String sql = "SELECT id, customer_id, selector, validator_hash, expires_at FROM remember_tokens WHERE selector=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBytes(1, selector);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TokenRecord rec = new TokenRecord();
                    rec.id = rs.getLong("id");
                    rec.customerId = rs.getInt("customer_id");
                    rec.selector = rs.getBytes("selector");
                    rec.validatorHash = rs.getBytes("validator_hash");
                    rec.expiresAt = rs.getTimestamp("expires_at");
                    return rec;
                }
            }
        }
        return null;
    }

    public long create(int customerId, byte[] selector, byte[] validatorHash, Instant expiresAt) throws SQLException {
        String sql = "INSERT INTO remember_tokens(customer_id, selector, validator_hash, expires_at) VALUES (?,?,?,?)";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerId);
            ps.setBytes(2, selector);
            ps.setBytes(3, validatorHash);
            ps.setTimestamp(4, Timestamp.from(expiresAt));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        return -1;
    }

    public void deleteById(long id) throws SQLException {
        String sql = "DELETE FROM remember_tokens WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    public void deleteByCustomer(int customerId) throws SQLException {
        String sql = "DELETE FROM remember_tokens WHERE customer_id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.executeUpdate();
        }
    }

    public void purgeExpired() throws SQLException {
        String sql = "DELETE FROM remember_tokens WHERE expires_at < ?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.from(Instant.now().truncatedTo(ChronoUnit.SECONDS)));
            ps.executeUpdate();
        }
    }
}

