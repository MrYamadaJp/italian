package utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DB {
    private static String url;
    private static String user;
    private static String password;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Properties props = new Properties();
            try (InputStream in = DB.class.getClassLoader().getResourceAsStream("resources/database.properties")) {
                if (in != null) {
                    props.load(in);
                }
            }
            url = props.getProperty("db.url", "jdbc:mysql://127.0.0.1:3306/italian?useSSL=false&characterEncoding=utf8");
            user = props.getProperty("db.user", "root");
            password = props.getProperty("db.password", "root");
        } catch (Exception e) {
            throw new RuntimeException("DB init error", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}

