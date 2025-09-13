USE italian;

-- Tables
INSERT INTO restaurant_tables(name, capacity, active) VALUES
 ('T1',4,1),('T2',4,1),('T3',4,1),('T4',4,1),('T5',4,1),('T6',6,1),('T7',6,1);

-- Categories & sample dishes
INSERT INTO categories(name) VALUES ('Antipasto'),('Pasta'),('Main'),('Dolce');
INSERT INTO dishes(name, description, price, category_id) VALUES
 ('Bruschetta','Tomato & basil',600,1),
 ('Caprese','Mozzarella & tomato',800,1),
 ('Carbonara','Classic Roman',1200,2),
 ('Bolognese','Rich meat sauce',1100,2),
 ('Tagliata','Sliced steak',2200,3),
 ('Tiramisu','Classic dessert',700,4);

INSERT INTO courses(name, description, price, active) VALUES
 ('Corso A','Antipasto + Pasta + Dolce',2500,1),
 ('Corso B','Antipasto + Pasta + Main + Dolce',3800,1);

-- map courses to dishes (simple sample mapping)
INSERT INTO course_dishes(course_id, dish_id)
SELECT c.id, d.id FROM courses c, dishes d WHERE (c.name='Corso A' AND d.name IN ('Bruschetta','Carbonara','Tiramisu'))
   OR (c.name='Corso B' AND d.name IN ('Caprese','Bolognese','Tagliata','Tiramisu'));

-- Admin user (username: admin / password: admin1234)
-- パスワードは salt + SHA-256 で保存。
SET @salt = UNHEX('73616c7473616c7473616c7473616c74'); -- 'saltsaltsaltsalt'
INSERT INTO admins(username, password_hash, salt)
VALUES ('admin', UNHEX(SHA2(CONCAT(@salt, 'admin1234'),256)), @salt);
