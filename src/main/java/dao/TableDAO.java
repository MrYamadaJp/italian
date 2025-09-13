package dao;

import beans.RestaurantTable;
import utils.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TableDAO {
    public List<RestaurantTable> findAllActive() throws SQLException {
        String sql = "SELECT id,name,capacity,active FROM restaurant_tables WHERE active=1 ORDER BY capacity, id";
        List<RestaurantTable> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RestaurantTable t = new RestaurantTable();
                t.setId(rs.getInt("id"));
                t.setName(rs.getString("name"));
                t.setCapacity(rs.getInt("capacity"));
                t.setActive(rs.getBoolean("active"));
                list.add(t);
            }
        }
        return list;
    }

    public static class TableStatus {
        public RestaurantTable table;
        public boolean occupied;
        public Integer reservationId;
        public java.util.Date startTime;
        public java.util.Date endTime;
        public Integer partySize;
    }

    public List<TableStatus> findStatusAt(java.util.Date at) throws SQLException {
        String sql = "SELECT t.id,t.name,t.capacity,t.active, r.id AS resv_id, r.start_time, r.end_time, r.party_size " +
                "FROM restaurant_tables t " +
                "LEFT JOIN reservations r ON r.table_id=t.id AND r.status='BOOKED' AND ? >= r.start_time AND ? < r.end_time " +
                "WHERE t.active=1 ORDER BY t.capacity, t.id";
        List<TableStatus> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            Timestamp ts = new Timestamp(at.getTime());
            ps.setTimestamp(1, ts);
            ps.setTimestamp(2, ts);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RestaurantTable t = new RestaurantTable();
                    t.setId(rs.getInt("id"));
                    t.setName(rs.getString("name"));
                    t.setCapacity(rs.getInt("capacity"));
                    t.setActive(rs.getBoolean("active"));
                    TableStatus s = new TableStatus();
                    s.table = t;
                    int resvId = rs.getInt("resv_id");
                    if (!rs.wasNull()) {
                        s.occupied = true;
                        s.reservationId = resvId;
                        java.sql.Timestamp st = rs.getTimestamp("start_time");
                        java.sql.Timestamp et = rs.getTimestamp("end_time");
                        s.startTime = st == null ? null : new java.util.Date(st.getTime());
                        s.endTime = et == null ? null : new java.util.Date(et.getTime());
                        int party = rs.getInt("party_size");
                        s.partySize = rs.wasNull() ? null : party;
                    } else {
                        s.occupied = false;
                    }
                    list.add(s);
                }
            }
        }
        return list;
    }
}
