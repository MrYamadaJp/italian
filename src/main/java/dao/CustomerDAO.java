package dao;

import beans.Customer;
import utils.DB;
import utils.PasswordUtil;

import java.sql.*;

public class CustomerDAO {
    public Customer findByEmail(String email) throws SQLException {
        String sql = "SELECT id,name,address,phone,email,password_hash,salt FROM customers WHERE email=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public Customer findById(int id) throws SQLException {
        String sql = "SELECT id,name,address,phone,email,password_hash,salt FROM customers WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public int create(Customer c, String rawPassword) throws SQLException {
        byte[] salt = PasswordUtil.generateSalt();
        byte[] hash = PasswordUtil.hashPassword(salt, rawPassword);
        String sql = "INSERT INTO customers(name,address,phone,email,password_hash,salt) VALUES (?,?,?,?,?,?)";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getAddress());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getEmail());
            ps.setBytes(5, hash);
            ps.setBytes(6, salt);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public void updateProfile(Customer c) throws SQLException {
        String sql = "UPDATE customers SET name=?, address=?, phone=? WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getAddress());
            ps.setString(3, c.getPhone());
            ps.setInt(4, c.getId());
            ps.executeUpdate();
        }
    }

    public void updateProfileWithEmail(Customer c) throws SQLException {
        String sql = "UPDATE customers SET name=?, address=?, phone=?, email=? WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getAddress());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getEmail());
            ps.setInt(5, c.getId());
            ps.executeUpdate();
        }
    }

    public void updatePassword(int id, String rawPassword) throws SQLException {
        byte[] salt = PasswordUtil.generateSalt();
        byte[] hash = PasswordUtil.hashPassword(salt, rawPassword);
        String sql = "UPDATE customers SET password_hash=?, salt=? WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBytes(1, hash);
            ps.setBytes(2, salt);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM customers WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Customer map(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setAddress(rs.getString("address"));
        c.setPhone(rs.getString("phone"));
        c.setEmail(rs.getString("email"));
        c.setPasswordHash(rs.getBytes("password_hash"));
        c.setSalt(rs.getBytes("salt"));
        return c;
    }
}
