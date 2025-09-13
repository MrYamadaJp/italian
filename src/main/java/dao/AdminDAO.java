package dao;

import beans.Admin;
import utils.DB;

import java.sql.*;

public class AdminDAO {
    public Admin findByUsername(String username) throws SQLException {
        String sql = "SELECT id,username,password_hash,salt FROM admins WHERE username=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin a = new Admin();
                    a.setId(rs.getInt("id"));
                    a.setUsername(rs.getString("username"));
                    a.setPasswordHash(rs.getBytes("password_hash"));
                    a.setSalt(rs.getBytes("salt"));
                    return a;
                }
            }
        }
        return null;
    }
}

