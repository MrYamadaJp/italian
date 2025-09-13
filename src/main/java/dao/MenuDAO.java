package dao;

import beans.Category;
import beans.Course;
import beans.Dish;
import utils.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {
    public Category getCategoryById(int id) throws SQLException {
        String sql = "SELECT id,name FROM categories WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getInt("id"));
                    c.setName(rs.getString("name"));
                    return c;
                }
            }
        }
        return null;
    }
    public List<Category> getCategories() throws SQLException {
        String sql = "SELECT id,name FROM categories ORDER BY id";
        List<Category> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }
        }
        return list;
    }

    public List<Dish> getDishesByCategory(int categoryId) throws SQLException {
        String sql = "SELECT id,name,description,price,category_id,active FROM dishes WHERE active=1 AND category_id=? ORDER BY id";
        List<Dish> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dish d = new Dish();
                    d.setId(rs.getInt("id"));
                    d.setName(rs.getString("name"));
                    d.setDescription(rs.getString("description"));
                    d.setPrice(rs.getInt("price"));
                    d.setCategoryId(rs.getInt("category_id"));
                    d.setActive(rs.getBoolean("active"));
                    list.add(d);
                }
            }
        }
        return list;
    }

    public List<Course> getActiveCourses() throws SQLException {
        String sql = "SELECT id,name,description,price,active FROM courses WHERE active=1 ORDER BY id";
        List<Course> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setPrice(rs.getInt("price"));
                c.setActive(rs.getBoolean("active"));
                list.add(c);
            }
        }
        return list;
    }

    public Course getCourseById(int id) throws SQLException {
        String sql = "SELECT id,name,description,price,active FROM courses WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Course c = new Course();
                    c.setId(rs.getInt("id"));
                    c.setName(rs.getString("name"));
                    c.setDescription(rs.getString("description"));
                    c.setPrice(rs.getInt("price"));
                    c.setActive(rs.getBoolean("active"));
                    return c;
                }
            }
        }
        return null;
    }

    public Dish getDishById(int id) throws SQLException {
        String sql = "SELECT id,name,description,price,category_id,active FROM dishes WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Dish d = new Dish();
                    d.setId(rs.getInt("id"));
                    d.setName(rs.getString("name"));
                    d.setDescription(rs.getString("description"));
                    d.setPrice(rs.getInt("price"));
                    d.setCategoryId(rs.getInt("category_id"));
                    d.setActive(rs.getBoolean("active"));
                    return d;
                }
            }
        }
        return null;
    }

    // Admin maintenance operations
    public List<Dish> getAllDishesByCategory(int categoryId) throws SQLException {
        String sql = "SELECT id,name,description,price,category_id,active FROM dishes WHERE category_id=? ORDER BY id";
        List<Dish> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dish d = new Dish();
                    d.setId(rs.getInt("id"));
                    d.setName(rs.getString("name"));
                    d.setDescription(rs.getString("description"));
                    d.setPrice(rs.getInt("price"));
                    d.setCategoryId(rs.getInt("category_id"));
                    d.setActive(rs.getBoolean("active"));
                    list.add(d);
                }
            }
        }
        return list;
    }

    public List<Course> getAllCourses() throws SQLException {
        String sql = "SELECT id,name,description,price,active FROM courses ORDER BY id";
        List<Course> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Course c = new Course();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setPrice(rs.getInt("price"));
                c.setActive(rs.getBoolean("active"));
                list.add(c);
            }
        }
        return list;
    }

    public int insertCategory(String name) throws SQLException {
        String sql = "INSERT INTO categories(name) VALUES (?)";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        }
        return -1;
    }

    public void updateCategory(int id, String name) throws SQLException {
        String sql = "UPDATE categories SET name=? WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public void deleteCategory(int id) throws SQLException {
        String sql = "DELETE FROM categories WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public int insertDish(Dish d) throws SQLException {
        String sql = "INSERT INTO dishes(name,description,price,category_id,active) VALUES (?,?,?,?,?)";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, d.getName());
            ps.setString(2, d.getDescription());
            ps.setInt(3, d.getPrice());
            ps.setInt(4, d.getCategoryId());
            ps.setBoolean(5, d.isActive());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        }
        return -1;
    }

    public void updateDish(Dish d) throws SQLException {
        String sql = "UPDATE dishes SET name=?, description=?, price=?, category_id=?, active=? WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getName());
            ps.setString(2, d.getDescription());
            ps.setInt(3, d.getPrice());
            ps.setInt(4, d.getCategoryId());
            ps.setBoolean(5, d.isActive());
            ps.setInt(6, d.getId());
            ps.executeUpdate();
        }
    }

    public void deleteDish(int id) throws SQLException {
        String sql = "DELETE FROM dishes WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public int insertCourse(Course c) throws SQLException {
        String sql = "INSERT INTO courses(name,description,price,active) VALUES (?,?,?,?)";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getPrice());
            ps.setBoolean(4, c.isActive());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        }
        return -1;
    }

    public void updateCourse(Course c) throws SQLException {
        String sql = "UPDATE courses SET name=?, description=?, price=?, active=? WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getPrice());
            ps.setBoolean(4, c.isActive());
            ps.setInt(5, c.getId());
            ps.executeUpdate();
        }
    }

    public void deleteCourse(int id) throws SQLException {
        String sql = "DELETE FROM courses WHERE id=?";
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public List<Dish> getAllDishes() throws SQLException {
        String sql = "SELECT id,name,description,price,category_id,active FROM dishes ORDER BY category_id, id";
        List<Dish> list = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Dish d = new Dish();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setDescription(rs.getString("description"));
                d.setPrice(rs.getInt("price"));
                d.setCategoryId(rs.getInt("category_id"));
                d.setActive(rs.getBoolean("active"));
                list.add(d);
            }
        }
        return list;
    }

    public List<Integer> getDishIdsForCourse(int courseId) throws SQLException {
        String sql = "SELECT dish_id FROM course_dishes WHERE course_id=? ORDER BY dish_id";
        List<Integer> ids = new ArrayList<>();
        try (Connection con = DB.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt(1));
            }
        }
        return ids;
    }

    public void replaceCourseDishes(int courseId, List<Integer> dishIds) throws SQLException {
        try (Connection con = DB.getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement del = con.prepareStatement("DELETE FROM course_dishes WHERE course_id=?")) {
                    del.setInt(1, courseId);
                    del.executeUpdate();
                }
                if (dishIds != null && !dishIds.isEmpty()) {
                    try (PreparedStatement ins = con.prepareStatement("INSERT INTO course_dishes(course_id, dish_id) VALUES (?,?)")) {
                        for (Integer id : dishIds) {
                            ins.setInt(1, courseId);
                            ins.setInt(2, id);
                            ins.addBatch();
                        }
                        ins.executeBatch();
                    }
                }
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
}
