-- Drop the existing database (if needed)
DROP DATABASE IF EXISTS OnlineMobileShopping;
CREATE DATABASE OnlineMobileShopping;
USE OnlineMobileShopping;

-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    address TEXT,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
) COMMENT 'Stores user information for the shopping platform';

-- Admins Table
CREATE TABLE Admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Stores admin credentials for managing the platform';

-- Categories Table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
) COMMENT 'Stores mobile categories (e.g., Smartphone, Feature Phone)';

-- Mobiles Table
CREATE TABLE Mobiles (
    mobile_id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    color VARCHAR(100) NOT NULL,
    specifications TEXT,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL,
    CONSTRAINT unique_brand_model_color UNIQUE (brand, model, color)
) COMMENT 'Stores mobile phone details';

-- Cart Table
CREATE TABLE Cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) COMMENT 'Stores user shopping carts';

-- CartItems Table
CREATE TABLE CartItems (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    mobile_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (mobile_id) REFERENCES Mobiles(mobile_id) ON DELETE CASCADE
) COMMENT 'Stores items added to user carts';

-- Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) COMMENT 'Stores user orders';

-- OrderDetails Table
CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    mobile_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (mobile_id) REFERENCES Mobiles(mobile_id) ON DELETE CASCADE
) COMMENT 'Stores details of items in each order';

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_method ENUM('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Cash on Delivery') NOT NULL,
    status ENUM('Successful', 'Failed') DEFAULT 'Successful',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (user_name) REFERENCES Users(name) ON DELETE CASCADE
) COMMENT 'Stores payment details for orders';

-- Reviews Table
CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    mobile_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_name) REFERENCES Users(name) ON DELETE CASCADE,
    FOREIGN KEY (mobile_id) REFERENCES Mobiles(mobile_id) ON DELETE CASCADE
) COMMENT 'Stores user reviews for mobiles';
-- Users data
INSERT INTO Users (name, email, password, address, phone_number) VALUES
('Tasneem', 'tasneem@example.com', 'hashedpass123', '123 Rose St, City A', '9876543210'),
('Prem', 'prem@example.com', 'hashedpass456', '456 Oak Ave, City B', '9876543211'),
('Bhanu', 'bhanu@example.com', 'hashedpass789', '789 Pine Rd, City C', '9876543212'),
('Karthikeya', 'karthikeya@example.com', 'hashedpass101', '101 Maple Ln, City D', '9876543213'),
('Nishanth', 'nishanth@example.com', 'hashedpass202', '202 Birch St, City E', '9876543214'),
('Lokesh', 'lokesh@example.com', 'hashedpass303', '303 Cedar Dr, City F', '9876543215'),
('Vamsi', 'vamsi@example.com', 'hashedpass404', '404 Elm St, City G', '9876543216'),
('Tharun', 'tharun@example.com', 'hashedpass505', '505 Willow Ct, City H', '9876543217');

-- Admins data
INSERT INTO Admins (name, email, password) VALUES
('Aisha Khan', 'aisha.khan@admin.com', 'adminpass901'),
('Rahul Sharma', 'rahul.sharma@admin.com', 'adminpass902'),
('Sophie Lee', 'sophie.lee@admin.com', 'adminpass903'),
('Carlos Rivera', 'carlos.rivera@admin.com', 'adminpass904'),
('Priya Patel', 'priya.patel@admin.com', 'adminpass905');

-- Categories data
INSERT INTO Categories (category_name) VALUES
('Smartphones'),
('Tablets'),
('Accessories'),
('Laptops'),
('Wearables');

-- Mobiles data
INSERT INTO Mobiles (brand, model, price, color, specifications, stock_quantity, category_id) VALUES
('Apple', 'iPhone', 399.99, 'White', '3.5-inch display, 2MP Camera, 16GB Storage', 20, 1),
('Apple', 'iPhone', 399.99, 'Black', '3.5-inch display, 2MP Camera, 16GB Storage', 20, 1),
('Apple', 'iPhone 3G', 499.99, 'Black', '3.5-inch display, 3G Connectivity, 16GB Storage', 25, 1),
('Apple', 'iPhone 3G', 499.99, 'White', '3.5-inch display, 3G Connectivity, 16GB Storage', 25, 1),
('Apple', 'iPhone 3GS', 599.99, 'Black', '3.5-inch display, 3MP Camera, 32GB Storage', 30, 1),
('Apple', 'iPhone 3GS', 599.99, 'White', '3.5-inch display, 3MP Camera, 32GB Storage', 30, 1),
('Apple', 'iPhone 4', 699.99, 'Black', '3.5-inch Retina display, 5MP Camera, 32GB Storage', 35, 1),
('Apple', 'iPhone 4', 699.99, 'White', '3.5-inch Retina display, 5MP Camera, 32GB Storage', 35, 1),
('Apple', 'iPhone 4S', 749.99, 'Black', '3.5-inch Retina display, Siri, 8MP Camera, 64GB Storage', 40, 1),
('Apple', 'iPhone 4S', 749.99, 'White', '3.5-inch Retina display, Siri, 8MP Camera, 64GB Storage', 40, 1),
('Apple', 'iPhone 5', 799.99, 'Black', '4-inch Retina display, 8MP Camera, 64GB Storage', 50, 1),
('Apple', 'iPhone 5', 799.99, 'White', '4-inch Retina display, 8MP Camera, 64GB Storage', 50, 1),
('Apple', 'iPhone 5', 799.99, 'Silver', '4-inch Retina display, 8MP Camera, 64GB Storage', 50, 1),
('Apple', 'iPhone 5c', 599.99, 'White', '4-inch Retina display, Colorful Plastic Body, 8MP Camera, 32GB Storage', 45, 1),
('Apple', 'iPhone 5c', 599.99, 'Black', '4-inch Retina display, Colorful Plastic Body, 8MP Camera, 32GB Storage', 45, 1),
('Apple', 'iPhone 5c', 599.99, 'Pink', '4-inch Retina display, Colorful Plastic Body, 8MP Camera, 32GB Storage', 45, 1),
('Apple', 'iPhone 5c', 599.99, 'Yellow', '4-inch Retina display, Colorful Plastic Body, 8MP Camera, 32GB Storage', 45, 1),
('Apple', 'iPhone 5s', 699.99, 'Silver', '4-inch Retina display, Touch ID, 8MP Camera, 64GB Storage', 50, 1),
('Apple', 'iPhone 5s', 699.99, 'Space Grey', '4-inch Retina display, Touch ID, 8MP Camera, 64GB Storage', 50, 1),
('Apple', 'iPhone 5s', 699.99, 'Gold', '4-inch Retina display, Touch ID, 8MP Camera, 64GB Storage', 50, 1),
('Apple', 'iPhone 6', 899.99, 'Silver', '4.7-inch Retina display, 8MP Camera, 128GB Storage', 55, 1),
('Apple', 'iPhone 6', 899.99, 'Space Grey', '4.7-inch Retina display, 8MP Camera, 128GB Storage', 55, 1),
('Apple', 'iPhone 6', 899.99, 'Gold', '4.7-inch Retina display, 8MP Camera, 128GB Storage', 55, 1),
('Apple', 'iPhone 6 Plus', 999.99, 'Silver', '5.5-inch Retina display, 8MP Camera, 128GB Storage', 60, 1),
('Apple', 'iPhone 6 Plus', 999.99, 'Gold', '5.5-inch Retina display, 8MP Camera, 128GB Storage', 60, 1),
('Apple', 'iPhone 6 Plus', 999.99, 'Space Grey', '5.5-inch Retina display, 8MP Camera, 128GB Storage', 60, 1),
('Apple', 'iPhone 6s', 749.99, 'Silver', '4.7-inch Retina display, 12MP Camera, 128GB Storage', 65, 1),
('Apple', 'iPhone 6s', 749.99, 'Gold', '4.7-inch Retina display, 12MP Camera, 128GB Storage', 65, 1),
('Apple', 'iPhone 6s', 749.99, 'Rose Gold', '4.7-inch Retina display, 12MP Camera, 128GB Storage', 65, 1),
('Apple', 'iPhone 6s', 749.99, 'Space Grey', '4.7-inch Retina display, 12MP Camera, 128GB Storage', 65, 1),
('Apple', 'iPhone 6s Plus', 849.99, 'Silver', '5.5-inch Retina display, 12MP Camera, 128GB Storage', 70, 1),
('Apple', 'iPhone 6s Plus', 849.99, 'Gold', '5.5-inch Retina display, 12MP Camera, 128GB Storage', 70, 1),
('Apple', 'iPhone 6s Plus', 849.99, 'Rose Gold', '5.5-inch Retina display, 12MP Camera, 128GB Storage', 70, 1),
('Apple', 'iPhone SE', 499.99, 'Silver', '4-inch Retina display, 12MP Camera, 128GB Storage', 80, 1),
('Apple', 'iPhone SE', 499.99, 'Gold', '4-inch Retina display, 12MP Camera, 128GB Storage', 80, 1),
('Apple', 'iPhone SE', 499.99, 'Rose Gold', '4-inch Retina display, 12MP Camera, 128GB Storage', 80, 1),
('Apple', 'iPhone 7', 899.99, 'Silver', '4.7-inch Retina display, No Headphone Jack, 12MP Camera, 256GB Storage', 75, 1),
('Apple', 'iPhone 7', 899.99, 'Black', '4.7-inch Retina display, No Headphone Jack, 12MP Camera, 256GB Storage', 75, 1),
('Apple', 'iPhone 7', 899.99, 'Jet Black', '4.7-inch Retina display, No Headphone Jack, 12MP Camera, 256GB Storage', 75, 1),
('Apple', 'iPhone 7', 899.99, 'Rose Gold', '4.7-inch Retina display, No Headphone Jack, 12MP Camera, 256GB Storage', 75, 1),
('Apple', 'iPhone 7 Plus', 999.99, 'Silver', '5.5-inch Retina display, Dual Camera, 256GB Storage', 80, 1),
('Apple', 'iPhone 7 Plus', 999.99, 'Black', '5.5-inch Retina display, Dual Camera, 256GB Storage', 80, 1),
('Apple', 'iPhone 7 Plus', 999.99, 'Jet Black', '5.5-inch Retina display, Dual Camera, 256GB Storage', 80, 1),
('Apple', 'iPhone 7 Plus', 999.99, 'Rose Gold', '5.5-inch Retina display, Dual Camera, 256GB Storage', 80, 1),
('Apple', 'iPhone 8', 799.99, 'Silver', '4.7-inch Retina display, Wireless Charging, 12MP Camera, 256GB Storage', 90, 1),
('Apple', 'iPhone 8', 799.99, 'Space Grey', '4.7-inch Retina display, Wireless Charging, 12MP Camera, 256GB Storage', 90, 1),
('Apple', 'iPhone 8', 799.99, 'Gold', '4.7-inch Retina display, Wireless Charging, 12MP Camera, 256GB Storage', 90, 1),
('Apple', 'iPhone 8', 799.99, 'Product(Red)', '4.7-inch Retina display, Wireless Charging, 12MP Camera, 256GB Storage', 90, 1),
('Apple', 'iPhone 8 Plus', 899.99, 'Silver', '5.5-inch Retina display, Wireless Charging, 12MP Camera, 256GB Storage', 85, 1),
('Apple', 'iPhone 8 Plus', 899.99, 'Space Grey', '5.5-inch Retina display, Wireless Charging, 12MP Camera, 256GB Storage', 85, 1),
('Apple', 'iPhone 8 Plus', 899.99, 'Gold', '5.5-inch Retina display, Wireless Charging, 12MP Camera, 256GB Storage', 85, 1),
('Apple', 'iPhone 8 Plus', 899.99, 'Product(Red)', '5.5-inch Retina display, Wireless Charging, 12MP Camera, 256GB Storage', 85, 1),
('Apple', 'iPhone X', 1099.99, 'Silver', '5.8-inch Super Retina OLED, Face ID, 256GB Storage', 50, 1),
('Apple', 'iPhone X', 1099.99, 'Space Grey', '5.8-inch Super Retina OLED, Face ID, 256GB Storage', 50, 1),
('Apple', 'iPhone XS', 1199.99, 'Silver', '5.8-inch Super Retina OLED, Dual Camera, 512GB Storage', 45, 1),
('Apple', 'iPhone XS', 1199.99, 'Space Grey', '5.8-inch Super Retina OLED, Dual Camera, 512GB Storage', 45, 1),
('Apple', 'iPhone XS', 1199.99, 'Gold', '5.8-inch Super Retina OLED, Dual Camera, 512GB Storage', 45, 1),
('Apple', 'iPhone XS Max', 1299.99, 'Silver', '6.5-inch Super Retina OLED, Dual Camera, 512GB Storage', 40, 1),
('Apple', 'iPhone XS Max', 1299.99, 'Space Grey', '6.5-inch Super Retina OLED, Dual Camera, 512GB Storage', 40, 1),
('Apple', 'iPhone XS Max', 1299.99, 'Gold', '6.5-inch Super Retina OLED, Dual Camera, 512GB Storage', 40, 1),
('Apple', 'iPhone XR', 999.99, 'Black', '6.1-inch Liquid Retina LCD, Single Camera, 256GB Storage', 55, 1),
('Apple', 'iPhone XR', 999.99, 'White', '6.1-inch Liquid Retina LCD, Single Camera, 256GB Storage', 55, 1),
('Apple', 'iPhone XR', 999.99, 'Blue', '6.1-inch Liquid Retina LCD, Single Camera, 256GB Storage', 55, 1),
('Apple', 'iPhone XR', 999.99, 'Yellow', '6.1-inch Liquid Retina LCD, Single Camera, 256GB Storage', 55, 1),
('Apple', 'iPhone XR', 999.99, 'Product(Red)', '6.1-inch Liquid Retina LCD, Single Camera, 256GB Storage', 55, 1),
('Apple', 'iPhone 11', 1099.99, 'White', '6.1-inch Liquid Retina LCD, Dual Camera, 256GB Storage', 60, 1),
('Apple', 'iPhone 11', 1099.99, 'Yellow', '6.1-inch Liquid Retina LCD, Dual Camera, 256GB Storage', 60, 1),
('Apple', 'iPhone 11', 1099.99, 'Product(Red)', '6.1-inch Liquid Retina LCD, Dual Camera, 256GB Storage', 60, 1),
('Apple', 'iPhone 11', 1099.99, 'Purple', '6.1-inch Liquid Retina LCD, Dual Camera, 256GB Storage', 60, 1),
('Apple', 'iPhone 11', 1099.99, 'Green', '6.1-inch Liquid Retina LCD, Dual Camera, 256GB Storage', 60, 1),
('Apple', 'iPhone 11 Pro', 1299.99, 'Silver', '5.8-inch Super Retina XDR, Triple Camera, 512GB Storage', 50, 1),
('Apple', 'iPhone 11 Pro', 1299.99, 'Space Grey', '5.8-inch Super Retina XDR, Triple Camera, 512GB Storage', 50, 1),
('Apple', 'iPhone 11 Pro', 1299.99, 'Midnight Green', '5.8-inch Super Retina XDR, Triple Camera, 512GB Storage', 50, 1),
('Apple', 'iPhone 11 Pro', 1299.99, 'Gold', '5.8-inch Super Retina XDR, Triple Camera, 512GB Storage', 50, 1),
('Apple', 'iPhone 11 Pro Max', 1399.99, 'Silver', '6.5-inch Super Retina XDR, Triple Camera, 512GB Storage', 45, 1),
('Apple', 'iPhone 11 Pro Max', 1399.99, 'Gold', '6.5-inch Super Retina XDR, Triple Camera, 512GB Storage', 45, 1),
('Apple', 'iPhone 11 Pro Max', 1399.99, 'Space Grey', '6.5-inch Super Retina XDR, Triple Camera, 512GB Storage', 45, 1),
('Apple', 'iPhone 11 Pro Max', 1399.99, 'Midnight Green', '6.5-inch Super Retina XDR, Triple Camera, 512GB Storage', 45, 1),
('Apple', 'iPhone SE (2nd Gen)', 599.99, 'Black', '4.7-inch Retina display, A13 Bionic Chip, 256GB Storage', 75, 1),
('Apple', 'iPhone SE (2nd Gen)', 599.99, 'White', '4.7-inch Retina display, A13 Bionic Chip, 256GB Storage', 75, 1),
('Apple', 'iPhone SE (2nd Gen)', 599.99, 'Product(Red)', '4.7-inch Retina display, A13 Bionic Chip, 256GB Storage', 75, 1),
('Apple', 'iPhone 12 mini', 999.99, 'Black', '5.4-inch Super Retina XDR, 5G, 256GB Storage', 70, 1),
('Apple', 'iPhone 12 mini', 999.99, 'White', '5.4-inch Super Retina XDR, 5G, 256GB Storage', 70, 1),
('Apple', 'iPhone 12 mini', 999.99, 'Product(Red)', '5.4-inch Super Retina XDR, 5G, 256GB Storage', 70, 1),
('Apple', 'iPhone 12 mini', 999.99, 'Green', '5.4-inch Super Retina XDR, 5G, 256GB Storage', 70, 1),
('Apple', 'iPhone 12 mini', 999.99, 'Blue', '5.4-inch Super Retina XDR, 5G, 256GB Storage', 70, 1),
('Apple', 'iPhone 12 mini', 999.99, 'Purple', '5.4-inch Super Retina XDR, 5G, 256GB Storage', 70, 1),
('Apple', 'iPhone 12', 1099.99, 'Black', '6.1-inch Super Retina XDR, 5G, 256GB Storage', 60, 1),
('Apple', 'iPhone 12', 1099.99, 'White', '6.1-inch Super Retina XDR, 5G, 256GB Storage', 60, 1),
('Apple', 'iPhone 12', 1099.99, 'Blue', '6.1-inch Super Retina XDR, 5G, 256GB Storage', 60, 1),
('Apple', 'iPhone 12', 1099.99, 'Product(Red)', '6.1-inch Super Retina XDR, 5G, 256GB Storage', 60, 1),
('Apple', 'iPhone 12', 1099.99, 'Purple', '6.1-inch Super Retina XDR, 5G, 256GB Storage', 60, 1),
('Apple', 'iPhone 12', 1099.99, 'Green', '6.1-inch Super Retina XDR, 5G, 256GB Storage', 60, 1),
('Apple', 'iPhone 12 Pro', 1299.99, 'Silver', '6.1-inch Super Retina XDR, LiDAR, 512GB Storage', 55, 1),
('Apple', 'iPhone 12 Pro', 1299.99, 'Gold', '6.1-inch Super Retina XDR, LiDAR, 512GB Storage', 55, 1),
('Apple', 'iPhone 12 Pro', 1299.99, 'Graphite', '6.1-inch Super Retina XDR, LiDAR, 512GB Storage', 55, 1),
('Apple', 'iPhone 12 Pro', 1299.99, 'Pacific Blue', '6.1-inch Super Retina XDR, LiDAR, 512GB Storage', 55, 1),
('Apple', 'iPhone 12 Pro Max', 1399.99, 'Silver', '6.7-inch Super Retina XDR, LiDAR, 512GB Storage', 50, 1),
('Apple', 'iPhone 12 Pro Max', 1399.99, 'Gold', '6.7-inch Super Retina XDR, LiDAR, 512GB Storage', 50, 1),
('Apple', 'iPhone 12 Pro Max', 1399.99, 'Graphite', '6.7-inch Super Retina XDR, LiDAR, 512GB Storage', 50, 1),
('Apple', 'iPhone 12 Pro Max', 1399.99, 'Pacific Blue', '6.7-inch Super Retina XDR, LiDAR, 512GB Storage', 50, 1),
('Apple', 'iPhone 13 mini', 999.99, 'Midnight', '5.4-inch Super Retina XDR, A15 Bionic, 512GB Storage', 65, 1),
('Apple', 'iPhone 13 mini', 999.99, 'Starlight', '5.4-inch Super Retina XDR, A15 Bionic, 512GB Storage', 65, 1),
('Apple', 'iPhone 13 mini', 999.99, 'Pink', '5.4-inch Super Retina XDR, A15 Bionic, 512GB Storage', 65, 1),
('Apple', 'iPhone 13 mini', 999.99, 'Blue', '5.4-inch Super Retina XDR, A15 Bionic, 512GB Storage', 65, 1),
('Apple', 'iPhone 13 mini', 999.99, 'Green', '5.4-inch Super Retina XDR, A15 Bionic, 512GB Storage', 65, 1),
('Apple', 'iPhone 13 mini', 999.99, 'Product(Red)', '5.4-inch Super Retina XDR, A15 Bionic, 512GB Storage', 65, 1),
('Apple', 'iPhone 13', 1099.99, 'Midnight', '6.1-inch Super Retina XDR, A15 Bionic, 512GB Storage', 60, 1),
('Apple', 'iPhone 13', 1099.99, 'Starlight', '6.1-inch Super Retina XDR, A15 Bionic, 512GB Storage', 60, 1),
('Apple', 'iPhone 13', 1099.99, 'Pink', '6.1-inch Super Retina XDR, A15 Bionic, 512GB Storage', 60, 1),
('Apple', 'iPhone 13', 1099.99, 'Blue', '6.1-inch Super Retina XDR, A15 Bionic, 512GB Storage', 60, 1),
('Apple', 'iPhone 13', 1099.99, 'Green', '6.1-inch Super Retina XDR, A15 Bionic, 512GB Storage', 60, 1),
('Apple', 'iPhone 13', 1099.99, 'Product(Red)', '6.1-inch Super Retina XDR, A15 Bionic, 512GB Storage', 60, 1),
('Apple', 'iPhone 13 Pro', 1299.99, 'Graphite', '6.1-inch ProMotion OLED, Triple Camera, 1TB Storage', 55, 1),
('Apple', 'iPhone 13 Pro', 1299.99, 'Gold', '6.1-inch ProMotion OLED, Triple Camera, 1TB Storage', 55, 1),
('Apple', 'iPhone 13 Pro', 1299.99, 'Silver', '6.1-inch ProMotion OLED, Triple Camera, 1TB Storage', 55, 1),
('Apple', 'iPhone 13 Pro', 1299.99, 'Sierra Blue', '6.1-inch ProMotion OLED, Triple Camera, 1TB Storage', 55, 1),
('Apple', 'iPhone 13 Pro', 1299.99, 'Alpine Green', '6.1-inch ProMotion OLED, Triple Camera, 1TB Storage', 55, 1),
('Apple', 'iPhone 13 Pro Max', 1399.99, 'Graphite', '6.7-inch ProMotion OLED, Triple Camera, 1TB Storage', 50, 1),
('Apple', 'iPhone 13 Pro Max', 1399.99, 'Gold', '6.7-inch ProMotion OLED, Triple Camera, 1TB Storage', 50, 1),
('Apple', 'iPhone 13 Pro Max', 1399.99, 'Silver', '6.7-inch ProMotion OLED, Triple Camera, 1TB Storage', 50, 1),
('Apple', 'iPhone 13 Pro Max', 1399.99, 'Sierra Blue', '6.7-inch ProMotion OLED, Triple Camera, 1TB Storage', 50, 1),
('Apple', 'iPhone 13 Pro Max', 1399.99, 'Alpine Green', '6.7-inch ProMotion OLED, Triple Camera, 1TB Storage', 50, 1),
('Apple', 'iPhone SE (3rd Gen)', 699.99, 'Product(Red)', '4.7-inch Retina display, A15 Bionic, 256GB Storage', 80, 1),
('Apple', 'iPhone SE (3rd Gen)', 699.99, 'Starlight', '4.7-inch Retina display, A15 Bionic, 256GB Storage', 80, 1),
('Apple', 'iPhone SE (3rd Gen)', 699.99, 'Midnight', '4.7-inch Retina display, A15 Bionic, 256GB Storage', 80, 1),
('Apple', 'iPhone 14', 1199.99, 'Starlight', '6.1-inch Super Retina XDR, Satellite SOS, 512GB Storage', 50, 1),
('Apple', 'iPhone 14', 1199.99, 'Midnight', '6.1-inch Super Retina XDR, Satellite SOS, 512GB Storage', 50, 1),
('Apple', 'iPhone 14', 1199.99, 'Product(Red)', '6.1-inch Super Retina XDR, Satellite SOS, 512GB Storage', 50, 1),
('Apple', 'iPhone 14', 1199.99, 'Blue', '6.1-inch Super Retina XDR, Satellite SOS, 512GB Storage', 50, 1),
('Apple', 'iPhone 14', 1199.99, 'Purple', '6.1-inch Super Retina XDR, Satellite SOS, 512GB Storage', 50, 1),
('Apple', 'iPhone 14', 1199.99, 'Yellow', '6.1-inch Super Retina XDR, Satellite SOS, 512GB Storage', 50, 1),
('Apple', 'iPhone 14 Plus', 1299.99, 'Starlight', '6.7-inch Super Retina XDR, Satellite SOS, 512GB Storage', 45, 1),
('Apple', 'iPhone 14 Plus', 1299.99, 'Midnight', '6.7-inch Super Retina XDR, Satellite SOS, 512GB Storage', 45, 1),
('Apple', 'iPhone 14 Plus', 1299.99, 'Blue', '6.7-inch Super Retina XDR, Satellite SOS, 512GB Storage', 45, 1),
('Apple', 'iPhone 14 Plus', 1299.99, 'Purple', '6.7-inch Super Retina XDR, Satellite SOS, 512GB Storage', 45, 1),
('Apple', 'iPhone 14 Plus', 1299.99, 'Yellow', '6.7-inch Super Retina XDR, Satellite SOS, 512GB Storage', 45, 1),
('Apple', 'iPhone 14 Plus', 1299.99, 'Product(Red)', '6.7-inch Super Retina XDR, Satellite SOS, 512GB Storage', 45, 1),
('Apple', 'iPhone 14 Pro', 1399.99, 'Space Black', '6.1-inch ProMotion OLED, Dynamic Island, 1TB Storage', 40, 1),
('Apple', 'iPhone 14 Pro', 1399.99, 'Silver', '6.1-inch ProMotion OLED, Dynamic Island, 1TB Storage', 40, 1),
('Apple', 'iPhone 14 Pro', 1399.99, 'Gold', '6.1-inch ProMotion OLED, Dynamic Island, 1TB Storage', 40, 1),
('Apple', 'iPhone 14 Pro', 1399.99, 'Deep Purple', '6.1-inch ProMotion OLED, Dynamic Island, 1TB Storage', 40, 1),
('Apple', 'iPhone 14 Pro Max', 1499.99, 'Silver', '6.7-inch ProMotion OLED, Dynamic Island, 1TB Storage', 35, 1),
('Apple', 'iPhone 14 Pro Max', 1499.99, 'Gold', '6.7-inch ProMotion OLED, Dynamic Island, 1TB Storage', 35, 1),
('Apple', 'iPhone 14 Pro Max', 1499.99, 'Space Black', '6.7-inch ProMotion OLED, Dynamic Island, 1TB Storage', 35, 1),
('Apple', 'iPhone 14 Pro Max', 1499.99, 'Deep Purple', '6.7-inch ProMotion OLED, Dynamic Island, 1TB Storage', 35, 1),
('Apple', 'iPhone 15', 1199.99, 'Yellow', '6.1-inch Super Retina XDR, USB-C, 512GB Storage', 50, 1),
('Apple', 'iPhone 15', 1199.99, 'Blue', '6.1-inch Super Retina XDR, USB-C, 512GB Storage', 50, 1),
('Apple', 'iPhone 15', 1199.99, 'Black', '6.1-inch Super Retina XDR, USB-C, 512GB Storage', 50, 1),
('Apple', 'iPhone 15', 1199.99, 'Pink', '6.1-inch Super Retina XDR, USB-C, 512GB Storage', 50, 1),
('Apple', 'iPhone 15', 1199.99, 'Green', '6.1-inch Super Retina XDR, USB-C, 512GB Storage', 50, 1),
('Apple', 'iPhone 15 Plus', 1299.99, 'Yellow', '6.7-inch Super Retina XDR, USB-C, 512GB Storage', 45, 1),
('Apple', 'iPhone 15 Plus', 1299.99, 'Blue', '6.7-inch Super Retina XDR, USB-C, 512GB Storage', 45, 1),
('Apple', 'iPhone 15 Plus', 1299.99, 'Black', '6.7-inch Super Retina XDR, USB-C, 512GB Storage', 45, 1),
('Apple', 'iPhone 15 Plus', 1299.99, 'Green', '6.7-inch Super Retina XDR, USB-C, 512GB Storage', 45, 1),
('Apple', 'iPhone 15 Plus', 1299.99, 'Pink', '6.7-inch Super Retina XDR, USB-C, 512GB Storage', 45, 1),
('Apple', 'iPhone 15 Pro', 1399.99, 'Blue Titanium', '6.1-inch ProMotion OLED, Titanium Frame, 1TB Storage', 40, 1),
('Apple', 'iPhone 15 Pro', 1399.99, 'Black Titanium', '6.1-inch ProMotion OLED, Titanium Frame, 1TB Storage', 40, 1),
('Apple', 'iPhone 15 Pro', 1399.99, 'White Titanium', '6.1-inch ProMotion OLED, Titanium Frame, 1TB Storage', 40, 1),
('Apple', 'iPhone 15 Pro', 1399.99, 'Natural Titanium', '6.1-inch ProMotion OLED, Titanium Frame, 1TB Storage', 40, 1),
('Apple', 'iPhone 15 Pro Max', 1499.99, 'Black Titanium', '6.7-inch ProMotion OLED, Periscope Camera, 1TB Storage', 35, 1),
('Apple', 'iPhone 15 Pro Max', 1499.99, 'Blue Titanium', '6.7-inch ProMotion OLED, Periscope Camera, 1TB Storage', 35, 1),
('Apple', 'iPhone 15 Pro Max', 1499.99, 'White Titanium', '6.7-inch ProMotion OLED, Periscope Camera, 1TB Storage', 35, 1),
('Apple', 'iPhone 15 Pro Max', 1499.99, 'Natural Titanium', '6.7-inch ProMotion OLED, Periscope Camera, 1TB Storage', 35, 1),
('Apple', 'iPhone 16', 1299.99, 'Blue', '6.1-inch Super Retina XDR, A18 Bionic, 512GB Storage', 30, 1),
('Apple', 'iPhone 16', 1299.99, 'Pink', '6.1-inch Super Retina XDR, A18 Bionic, 512GB Storage', 30, 1),
('Apple', 'iPhone 16', 1299.99, 'Green', '6.1-inch Super Retina XDR, A18 Bionic, 512GB Storage', 30, 1),
('Apple', 'iPhone 16', 1299.99, 'Black', '6.1-inch Super Retina XDR, A18 Bionic, 512GB Storage', 30, 1),
('Apple', 'iPhone 16', 1299.99, 'Yellow', '6.1-inch Super Retina XDR, A18 Bionic, 512GB Storage', 30, 1),
('Apple', 'iPhone 16 Plus', 1399.99, 'Blue', '6.7-inch Super Retina XDR, A18 Bionic, 512GB Storage', 25, 1),
('Apple', 'iPhone 16 Plus', 1399.99, 'Pink', '6.7-inch Super Retina XDR, A18 Bionic, 512GB Storage', 25, 1),
('Apple', 'iPhone 16 Plus', 1399.99, 'Yellow', '6.7-inch Super Retina XDR, A18 Bionic, 512GB Storage', 25, 1),
('Apple', 'iPhone 16 Plus', 1399.99, 'Green', '6.7-inch Super Retina XDR, A18 Bionic, 512GB Storage', 25, 1),
('Apple', 'iPhone 16 Plus', 1399.99, 'Black', '6.7-inch Super Retina XDR, A18 Bionic, 512GB Storage', 25, 1),
('Apple', 'iPhone 16 Pro', 1499.99, 'Natural Titanium', '6.1-inch ProMotion OLED, Under-Display Face ID, 1TB Storage', 20, 1),
('Apple', 'iPhone 16 Pro', 1499.99, 'White Titanium', '6.1-inch ProMotion OLED, Under-Display Face ID, 1TB Storage', 20, 1),
('Apple', 'iPhone 16 Pro', 1499.99, 'Blue Titanium', '6.1-inch ProMotion OLED, Under-Display Face ID, 1TB Storage', 20, 1),
('Apple', 'iPhone 16 Pro', 1499.99, 'Black Titanium', '6.1-inch ProMotion OLED, Under-Display Face ID, 1TB Storage', 20, 1),
('Apple', 'iPhone 16 Pro Max', 1599.99, 'Natural Titanium', '6.7-inch ProMotion OLED, Advanced Cameras, 1TB Storage', 15, 1),
('Apple', 'iPhone 16 Pro Max', 1599.99, 'White Titanium', '6.7-inch ProMotion OLED, Advanced Cameras, 1TB Storage', 15, 1),
('Apple', 'iPhone 16 Pro Max', 1599.99, 'Blue Titanium', '6.7-inch ProMotion OLED, Advanced Cameras, 1TB Storage', 15, 1),
('Apple', 'iPhone 16 Pro Max', 1599.99, 'Black Titanium', '6.7-inch ProMotion OLED, Advanced Cameras, 1TB Storage', 15, 1),
('Apple', 'iPhone 16e', 899.99, 'Blue', '5.4-inch OLED, Budget Model, 256GB Storage', 60, 1),
('Apple', 'iPhone 16e', 899.99, 'Starlight', '5.4-inch OLED, Budget Model, 256GB Storage', 60, 1),
('Apple', 'iPhone 16e', 899.99, 'Pink', '5.4-inch OLED, Budget Model, 256GB Storage', 60, 1),
('Apple', 'iPhone 16e', 899.99, 'Black', '5.4-inch OLED, Budget Model, 256GB Storage', 60, 1);

-- Cart data
INSERT INTO Cart (user_id, created_at) VALUES
(1, '2025-04-01 10:15:23'), -- Tasneem
(2, '2025-04-02 14:30:45'), -- Prem
(3, '2025-04-03 09:10:12'), -- Bhanu
(4, '2025-04-04 16:25:37'), -- Karthikeya
(5, '2025-04-05 11:45:00'), -- Nishanth
(6, '2025-04-05 20:15:19'), -- Lokesh
(7, '2025-04-06 08:30:55'), -- Vamsi
(8, '2025-04-06 13:20:40'); -- Tharun

-- CartItems data
INSERT INTO CartItems (cart_id, mobile_id, quantity) VALUES
(1, 1, 2),  -- Tasneem's cart: 2 iPhones (White)
(2, 7, 1),  -- Prem's cart: 1 iPhone 4 (Black)
(3, 11, 3), -- Bhanu's cart: 3 iPhone 5 (Black)
(4, 18, 1), -- Karthikeya's cart: 1 iPhone 5s (Silver)
(5, 21, 2), -- Nishanth's cart: 2 iPhone 6 (Silver)
(6, 27, 1), -- Lokesh's cart: 1 iPhone 6s (Silver)
(7, 37, 1), -- Vamsi's cart: 1 iPhone 7 (Silver)
(8, 45, 2); -- Tharun's cart: 2 iPhone 8 (Silver)

-- Orders data
INSERT INTO Orders (user_id, order_date, status, total_price) VALUES
(1, '2025-04-03 12:00:00', 'Shipped', 799.98),    -- Tasneem: 2 iPhones
(2, '2025-04-04 15:30:00', 'Delivered', 699.99),  -- Prem: 1 iPhone 4
(3, '2025-04-05 09:15:00', 'Pending', 2399.97),   -- Bhanu: 3 iPhone 5
(4, '2025-04-06 10:00:00', 'Cancelled', 699.99),  -- Karthikeya: 1 iPhone 5s
(5, '2025-04-06 14:45:00', 'Shipped', 1799.98);   -- Nishanth: 2 iPhone 6

-- OrderDetails data
INSERT INTO OrderDetails (order_id, mobile_id, quantity, price) VALUES
(1, 1, 2, 399.99),  -- Tasneem's order: 2 iPhones (White)
(2, 7, 1, 699.99),  -- Prem's order: 1 iPhone 4 (Black)
(3, 11, 3, 799.99), -- Bhanu's order: 3 iPhone 5 (Black)
(4, 18, 1, 699.99), -- Karthikeya's order: 1 iPhone 5s (Silver)
(5, 21, 2, 899.99); -- Nishanth's order: 2 iPhone 6 (Silver)

-- Payments data
INSERT INTO Payments (order_id, user_name, amount, payment_method, status, payment_date) VALUES
(1, 'Tasneem', 799.98, 'Credit Card', 'Successful', '2025-04-03 12:05:00'),    -- Tasneem
(2, 'Prem', 699.99, 'UPI', 'Successful', '2025-04-04 15:35:00'),              -- Prem
(3, 'Bhanu', 2399.97, 'Net Banking', 'Successful', '2025-04-05 09:20:00'),    -- Bhanu
(4, 'Karthikeya', 699.99, 'Cash on Delivery', 'Failed', '2025-04-06 10:05:00'), -- Karthikeya (cancelled)
(5, 'Nishanth', 1799.98, 'Debit Card', 'Successful', '2025-04-06 14:50:00');   -- Nishanth

-- Reviews data
INSERT INTO Reviews (user_name, mobile_id, rating, comment, review_date) VALUES
('Tasneem', 1, 4, 'Great phone for its time!', '2025-04-04 10:00:00'),         -- Tasneem on iPhone (White)
('Prem', 7, 5, 'Love the Retina display!', '2025-04-05 12:30:00'),             -- Prem on iPhone 4 (Black)
('Bhanu', 11, 3, 'Good, but battery life could be better.', '2025-04-06 08:15:00'), -- Bhanu on iPhone 5 (Black)
('Nishanth', 21, 4, 'Solid upgrade, sleek design.', '2025-04-06 15:00:00'),     -- Nishanth on iPhone 6 (Silver)
('Vamsi', 37, 5, 'No headphone jack, but amazing performance!', '2025-04-06 16:00:00'); -- Vamsi on iPhone 7 (Silver)