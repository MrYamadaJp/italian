package dao;

import beans.Reservation;
import utils.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ReservationDAO {
    public Integer findAvailableTableId(Date start, Date end, int partySize) throws SQLException {
        String sql = "SELECT t.id FROM restaurant_tables t " +
                "LEFT JOIN reservations r ON r.table_id=t.id AND r.status='BOOKED' AND NOT (r.end_time <= ? OR r.start_time >= ?) " +
                "WHERE t.active=1 AND t.capacity >= ? AND r.id IS NULL ORDER BY t.capacity ASC, t.id ASC LIMIT 1";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(start.getTime()));
            ps.setTimestamp(2, new Timestamp(end.getTime()));
            ps.setInt(3, partySize);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }

    public int createReservation(Reservation r) throws SQLException {
        String sql = "INSERT INTO reservations(customer_id, table_id, course_id, party_size, start_time, end_time, status) " +
                     "VALUES (?,?,?,?,?,?, 'BOOKED')";
        try (Connection con = DB.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, r.getCustomerId());
                ps.setInt(2, r.getTableId());
                ps.setInt(3, r.getCourseId());
                ps.setInt(4, r.getPartySize());
                ps.setTimestamp(5, new Timestamp(r.getStartTime().getTime()));
                ps.setTimestamp(6, new Timestamp(r.getEndTime().getTime()));
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        con.commit();
                        return id;
                    }
                }
                con.commit();
                return -1;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public List<Reservation> listByCustomer(int customerId) throws SQLException {
        String sql = "SELECT id, customer_id, table_id, course_id, party_size, start_time, end_time, status FROM reservations WHERE customer_id=? ORDER BY start_time DESC";
        List<Reservation> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public void cancel(int id, int customerId) throws SQLException {
        String sql = "UPDATE reservations SET status='CANCELLED' WHERE id=? AND customer_id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, customerId);
            ps.executeUpdate();
        }
    }

    public Reservation findById(int id) throws SQLException {
        String sql = "SELECT id, customer_id, table_id, course_id, party_size, start_time, end_time, status FROM reservations WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public Integer findAvailableTableIdForUpdate(Date start, Date end, int partySize, int excludeReservationId) throws SQLException {
        String sql = "SELECT t.id FROM restaurant_tables t " +
                "LEFT JOIN reservations r ON r.table_id=t.id AND r.status='BOOKED' AND r.id<>? AND NOT (r.end_time <= ? OR r.start_time >= ?) " +
                "WHERE t.active=1 AND t.capacity >= ? AND r.id IS NULL ORDER BY t.capacity ASC, t.id ASC LIMIT 1";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, excludeReservationId);
            ps.setTimestamp(2, new Timestamp(start.getTime()));
            ps.setTimestamp(3, new Timestamp(end.getTime()));
            ps.setInt(4, partySize);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }

    public void updateReservation(Reservation r) throws SQLException {
        String sql = "UPDATE reservations SET table_id=?, course_id=?, party_size=?, start_time=?, end_time=? WHERE id=? AND customer_id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, r.getTableId());
            ps.setInt(2, r.getCourseId());
            ps.setInt(3, r.getPartySize());
            ps.setTimestamp(4, new Timestamp(r.getStartTime().getTime()));
            ps.setTimestamp(5, new Timestamp(r.getEndTime().getTime()));
            ps.setInt(6, r.getId());
            ps.setInt(7, r.getCustomerId());
            ps.executeUpdate();
        }
    }

    private Reservation map(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setCustomerId(rs.getInt("customer_id"));
        r.setTableId(rs.getInt("table_id"));
        r.setCourseId(rs.getInt("course_id"));
        r.setPartySize(rs.getInt("party_size"));
        r.setStartTime(new Date(rs.getTimestamp("start_time").getTime()));
        r.setEndTime(new Date(rs.getTimestamp("end_time").getTime()));
        r.setStatus(rs.getString("status"));
        return r;
    }
}
