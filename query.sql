--Query: Find phones by color with available stock
SELECT 
    mobile_id,
    brand,
    model,
    color,
    price,
    specifications,
    stock_quantity
FROM 
    Mobiles
WHERE 
    color = 'Silver'  -- Replace 'Silver' with the required color
    AND stock_quantity > 0
ORDER BY 
    price ASC;

-- Query: Find phones by model with available stock
SELECT 
    model AS `Model`,
    brand AS `Brand`,
    Color AS `Color`,
    price AS `Price`,
    stock_quantity AS `Available Stock`,
    specifications AS `Specifications`
FROM 
    Mobiles
WHERE 
    stock_quantity > 0
ORDER BY 
    model, Color;

-- Query: Find users who booked more than n times
SET @n = 1; -- Replace with your desired threshold (e.g., 1, 2, 3, etc.)

SELECT 
    user_name AS `User`,
    COUNT(*) AS `Number of Orders`
FROM 
    Orders
GROUP BY 
    user_name
HAVING 
    COUNT(*) > @n
ORDER BY 
    `Number of Orders` DESC;

-- Query: Find users who made payments using UPI
SELECT DISTINCT
    user_name AS `User`,
    amount AS `Amount`,
    order_id AS `Order ID`,
    payment_date AS `Payment Date`
FROM 
    Payments
WHERE 
    payment_method = 'UPI'
ORDER BY 
    payment_date;

-- Query: Find remaining quantity of a specific model and color
SELECT 
    model AS `Model`,
    Color AS `Color`,
    stock_quantity AS `Remaining Quantity`
FROM 
    Mobiles
WHERE 
    model = 'iPhone 14 Pro Max' -- Replace with your desired model
    AND Color = 'Silver'       -- Replace with your desired color
ORDER BY 
    model, Color;

-- Step 1: Drop the old procedure
DROP PROCEDURE IF EXISTS PlaceOrder;

-- Step 2: Re-create with pretty output
DELIMITER $$

CREATE PROCEDURE PlaceOrder()
BEGIN
    DECLARE available_stock INT DEFAULT 0;
    DECLARE userId INT;
    DECLARE mobileId INT;
    DECLARE orderId INT;

    -- Get user_id from user name
    SELECT user_id INTO userId FROM Users WHERE name = @user_name;

    -- Get mobile_id from model and color
    SELECT mobile_id, stock_quantity INTO mobileId, available_stock
    FROM Mobiles
    WHERE model = @model AND color = @color;

    IF available_stock >= @quantity THEN
        START TRANSACTION;

        -- Insert into Orders
        INSERT INTO Orders (user_id, order_date, status, total_price)
        VALUES (userId, NOW(), 'Pending', 1499.99);

        SET orderId = LAST_INSERT_ID();

        -- Insert into OrderDetails
        INSERT INTO OrderDetails (order_id, mobile_id, quantity, price)
        VALUES (orderId, mobileId, @quantity, 1499.99);

        -- Insert into Payments
        INSERT INTO Payments (order_id, user_name, amount, payment_method, status, payment_date)
        VALUES (orderId, @user_name, 1499.99, 'Credit Card', 'Successful', NOW());

        -- Update stock
        UPDATE Mobiles
        SET stock_quantity = stock_quantity - @quantity
        WHERE mobile_id = mobileId;

        COMMIT;

        -- Final Output
        SELECT CONCAT(
            'User: ', u.name, '\n',
            'Model: ', m.model, '\n',
            'Color: ', m.color, '\n',
            'Price: ', od.price, '\n',
            'Quantity: ', od.quantity, '\n',
            'Total: ', o.total_price, '\n',
            'Status: ', o.status, ' (awaiting shipment)', '\n',
            'Payment: ', p.payment_method, ', ', p.status, '\n',
            'Order Date: ', DATE_FORMAT(o.order_date, '%M %d, %Y, %H:%i:%s')
        ) AS OrderConfirmation
        FROM Orders o
        JOIN OrderDetails od ON o.order_id = od.order_id
        JOIN Payments p ON o.order_id = p.order_id
        JOIN Mobiles m ON od.mobile_id = m.mobile_id
        JOIN Users u ON o.user_id = u.user_id
        WHERE o.order_id = orderId;

    ELSE
        ROLLBACK;
        SELECT 'Insufficient stock for this model and color!' AS Message;
    END IF;
END$$
DELIMITER ;
SET @user_name = 'Vamsi';
SET @model = 'iPhone 15 plus';
SET @color = 'Pink';
SET @quantity = 2;
CALL PlaceOrder();

--Query with Subquery: Find Users Who Ordered More Than the Average Order Total

SELECT o.user_name, o.total_price
FROM Orders o
WHERE o.total_price > (SELECT AVG(total_price) FROM Orders)
ORDER BY o.total_price DESC;

--Query with Aggregate Function and Join: Total Revenue by Mobile Model

SELECT 
    od.mobile_model,
    SUM(od.price * od.quantity) AS total_revenue
FROM OrderDetails od
JOIN Orders o ON od.order_id = o.order_id
WHERE o.status IN ('Shipped', 'Delivered')
GROUP BY od.mobile_model
ORDER BY total_revenue DESC;

--Query with Subquery and Join: Users Who Reviewed High-Rated Mobiles (Rating >= 4)

SELECT DISTINCT r.user_name, r.mobile_model, r.rating
FROM Reviews r
WHERE r.mobile_model IN (
    SELECT mobile_model
    FROM Reviews
    GROUP BY mobile_model
    HAVING AVG(rating) >= 4
)
ORDER BY r.rating DESC;

--Query with Aggregate Function and Join: Stock Quantity and Order Count per Mobile Model

SELECT 
    m.model,
    SUM(m.stock_quantity) AS total_stock,
    COUNT(od.order_detail_id) AS order_count
FROM Mobiles m
LEFT JOIN OrderDetails od ON m.model = od.mobile_model
GROUP BY m.model
HAVING total_stock > 0
ORDER BY order_count DESC, total_stock DESC;

--Query with Subquery and Aggregate: Top-Spending User

SELECT 
    o.user_name,
    SUM(o.total_price) AS total_spent
FROM Orders o
GROUP BY o.user_name
HAVING SUM(o.total_price) = (
    SELECT SUM(total_price)
    FROM Orders
    GROUP BY user_name
    ORDER BY SUM(total_price) DESC
    LIMIT 1
);

--Query with Join and Aggregate: Average Rating per Mobile Model with Order Details

SELECT 
    m.model,
    AVG(r.rating) AS avg_rating,
    SUM(od.quantity) AS total_ordered
FROM Mobiles m
LEFT JOIN Reviews r ON m.model = r.mobile_model
LEFT JOIN OrderDetails od ON m.model = od.mobile_model
GROUP BY m.model
HAVING AVG(r.rating) IS NOT NULL OR SUM(od.quantity) IS NOT NULL
ORDER BY avg_rating DESC, total_ordered DESC;

--Query with Subquery and Join: Orders with Payments Above Average Amount

SELECT 
    o.order_id,
    o.user_name,
    p.amount,
    o.status
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id
WHERE p.amount > (SELECT AVG(amount) FROM Payments)
ORDER BY p.amount DESC;