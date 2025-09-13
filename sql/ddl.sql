-- Database: italian
-- Note: create DB if not exists
CREATE DATABASE IF NOT EXISTS italian CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE italian;

-- Customers (members)
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS course_dishes;
DROP TABLE IF EXISTS dishes;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS restaurant_tables;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS remember_tokens;

CREATE TABLE customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(255),
  phone VARCHAR(30),
  email VARCHAR(200) NOT NULL UNIQUE,
  password_hash VARBINARY(32) NOT NULL,
  salt VARBINARY(16) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Persistent login tokens for customers (remember-me)
CREATE TABLE remember_tokens (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  selector VARBINARY(16) NOT NULL,
  validator_hash VARBINARY(32) NOT NULL,
  expires_at DATETIME NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_token_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  UNIQUE KEY uk_selector (selector),
  INDEX idx_token_customer (customer_id)
) ENGINE=InnoDB;

CREATE TABLE admins (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARBINARY(32) NOT NULL,
  salt VARBINARY(16) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE dishes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price INT NOT NULL,
  category_id INT NOT NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT fk_dish_cat FOREIGN KEY (category_id) REFERENCES categories(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE courses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price INT NOT NULL,
  active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE course_dishes (
  course_id INT NOT NULL,
  dish_id INT NOT NULL,
  PRIMARY KEY (course_id, dish_id),
  CONSTRAINT fk_cd_course FOREIGN KEY (course_id) REFERENCES courses(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_cd_dish FOREIGN KEY (dish_id) REFERENCES dishes(id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE restaurant_tables (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL,
  capacity INT NOT NULL,
  active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE reservations (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  table_id INT NOT NULL,
  course_id INT NOT NULL,
  party_size INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  status ENUM('BOOKED','CANCELLED') NOT NULL DEFAULT 'BOOKED',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_resv_cust FOREIGN KEY (customer_id) REFERENCES customers(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_resv_table FOREIGN KEY (table_id) REFERENCES restaurant_tables(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_resv_course FOREIGN KEY (course_id) REFERENCES courses(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_resv_table_time (table_id, start_time),
  INDEX idx_resv_customer (customer_id, start_time)
) ENGINE=InnoDB;
