-- ============================================================================
-- PRODUCT REVIEW AND RATING MANAGEMENT SYSTEM
-- ============================================================================

-- 1. CREATE DATABASE (Optional)
-- CREATE DATABASE review_management_system;
-- USE review_management_system;

-- ============================================================================
-- 2. CREATE TABLES
-- ============================================================================

-- Products Table
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    price DECIMAL(10, 2),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews Table
CREATE TABLE IF NOT EXISTS Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    review_text TEXT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    helpful_count INT DEFAULT 0,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_customer_id (customer_id),
    INDEX idx_rating (rating)
);

-- Ratings Table (Summary)
CREATE TABLE IF NOT EXISTS Ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL UNIQUE,
    average_rating DECIMAL(3, 2),
    total_reviews INT DEFAULT 0,
    five_star_count INT DEFAULT 0,
    four_star_count INT DEFAULT 0,
    three_star_count INT DEFAULT 0,
    two_star_count INT DEFAULT 0,
    one_star_count INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

-- ============================================================================
-- 3. INSERT SAMPLE DATA
-- ============================================================================

-- Insert Products
INSERT INTO Products (product_name, description, category, price) VALUES
('Wireless Headphones', 'High-quality wireless headphones with noise cancellation', 'Electronics', 79.99),
('USB-C Cable', 'Durable USB-C charging cable with fast data transfer', 'Electronics', 12.99),
('Laptop Stand', 'Adjustable aluminum laptop stand for ergonomic setup', 'Accessories', 49.99),
('Mechanical Keyboard', 'Premium mechanical keyboard with RGB lighting', 'Electronics', 129.99),
('Mouse Pad', 'Large extended mouse pad with non-slip base', 'Accessories', 24.99),
('Phone Case', 'Protective phone case with drop protection', 'Accessories', 19.99);

-- Insert Customers
INSERT INTO Customers (customer_name, email, phone) VALUES
('Ravi Kumar', 'ravi.kumar@email.com', '9876543210'),
('Priya Singh', 'priya.singh@email.com', '9876543211'),
('Amit Patel', 'amit.patel@email.com', '9876543212'),
('Sneha Sharma', 'sneha.sharma@email.com', '9876543213'),
('Deepak Gupta', 'deepak.gupta@email.com', '9876543214'),
('Ananya Joshi', 'ananya.joshi@email.com', '9876543215');

-- Insert Reviews
INSERT INTO Reviews (product_id, customer_id, review_text, rating, helpful_count) VALUES
-- Reviews for Wireless Headphones (Product 1)
(1, 1, 'Excellent sound quality and comfortable to wear for long hours!', 5, 45),
(1, 2, 'Great noise cancellation but battery could be better', 4, 32),
(1, 3, 'Amazing product, highly recommend!', 5, 28),
(1, 4, 'Good quality but a bit expensive', 4, 15),
(1, 5, 'Not satisfied with the connectivity', 2, 8),

-- Reviews for USB-C Cable (Product 2)
(2, 1, 'Durable and reliable cable, great value for money', 5, 52),
(2, 2, 'Best USB-C cable I have used so far', 5, 41),
(2, 3, 'Works perfectly, very satisfied', 4, 20),
(2, 6, 'Cable stopped working after 2 months', 2, 5),

-- Reviews for Laptop Stand (Product 3)
(3, 1, 'Sturdy and well-built, improves ergonomics', 5, 38),
(3, 3, 'Good quality aluminum construction', 4, 22),
(3, 4, 'A bit wobbly when fully extended', 3, 10),
(3, 5, 'Perfect for my workspace setup', 5, 35),

-- Reviews for Mechanical Keyboard (Product 4)
(4, 2, 'Best keyboard I ever owned, typing feels amazing', 5, 67),
(4, 4, 'Great RGB lighting but switches are loud', 4, 29),
(4, 6, 'Excellent build quality and responsiveness', 5, 48),

-- Reviews for Mouse Pad (Product 5)
(5, 1, 'Good size and material quality', 4, 18),
(5, 3, 'Smooth surface, great for gaming', 5, 34),
(5, 5, 'Average quality for the price', 3, 8),

-- Reviews for Phone Case (Product 6)
(6, 2, 'Perfect fit and good protection', 4, 24),
(6, 4, 'Great protection at affordable price', 5, 31),
(6, 6, 'Case started cracking after 3 months', 2, 6);

-- ============================================================================
-- 4. POPULATE RATINGS TABLE WITH AGGREGATE DATA
-- ============================================================================

INSERT INTO Ratings (product_id, average_rating, total_reviews)
SELECT 
    p.product_id,
    ROUND(AVG(r.rating), 2) as average_rating,
    COUNT(r.review_id) as total_reviews
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id;

-- Update star counts in Ratings table
UPDATE Ratings SET
    five_star_count = (SELECT COUNT(*) FROM Reviews WHERE product_id = Ratings.product_id AND rating = 5),
    four_star_count = (SELECT COUNT(*) FROM Reviews WHERE product_id = Ratings.product_id AND rating = 4),
    three_star_count = (SELECT COUNT(*) FROM Reviews WHERE product_id = Ratings.product_id AND rating = 3),
    two_star_count = (SELECT COUNT(*) FROM Reviews WHERE product_id = Ratings.product_id AND rating = 2),
    one_star_count = (SELECT COUNT(*) FROM Reviews WHERE product_id = Ratings.product_id AND rating = 1);

-- ============================================================================
-- 5. RETRIEVE PRODUCT REVIEW DETAILS
-- ============================================================================

-- Query 1: Get all reviews for a specific product with customer details
SELECT 
    r.review_id,
    r.product_id,
    p.product_name,
    c.customer_name,
    c.email,
    r.review_text,
    r.rating,
    r.helpful_count,
    r.review_date
FROM Reviews r
INNER JOIN Products p ON r.product_id = p.product_id
INNER JOIN Customers c ON r.customer_id = c.customer_id
WHERE p.product_id = 1  -- Replace with desired product_id
ORDER BY r.review_date DESC;

-- Query 2: Get detailed review statistics for each product
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    COUNT(r.review_id) as total_reviews,
    ROUND(AVG(r.rating), 2) as average_rating,
    MIN(r.rating) as lowest_rating,
    MAX(r.rating) as highest_rating,
    ROUND(STDDEV(r.rating), 2) as rating_std_deviation
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY average_rating DESC;

-- ============================================================================
-- 6. CALCULATE AVERAGE PRODUCT RATINGS (AGGREGATE FUNCTIONS)
-- ============================================================================

-- Query 3: Calculate average ratings using aggregate functions
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    COUNT(r.review_id) as number_of_reviews,
    ROUND(AVG(r.rating), 2) as average_rating,
    ROUND(MAX(r.rating), 2) as highest_rating,
    ROUND(MIN(r.rating), 2) as lowest_rating,
    ROUND(SUM(r.helpful_count), 0) as total_helpful_votes
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, p.price
HAVING COUNT(r.review_id) > 0
ORDER BY average_rating DESC;

-- Query 4: Rating distribution for all products
SELECT 
    p.product_id,
    p.product_name,
    COUNT(CASE WHEN r.rating = 5 THEN 1 END) as five_stars,
    COUNT(CASE WHEN r.rating = 4 THEN 1 END) as four_stars,
    COUNT(CASE WHEN r.rating = 3 THEN 1 END) as three_stars,
    COUNT(CASE WHEN r.rating = 2 THEN 1 END) as two_stars,
    COUNT(CASE WHEN r.rating = 1 THEN 1 END) as one_star,
    COUNT(r.review_id) as total_reviews
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;

-- ============================================================================
-- 7. IDENTIFY HIGHLY RATED PRODUCTS
-- ============================================================================

-- Query 5: Products with rating >= 4.0 (Highly Rated Products)
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    ra.average_rating,
    ra.total_reviews,
    ROUND((ra.five_star_count / ra.total_reviews * 100), 2) as five_star_percentage
FROM Products p
INNER JOIN Ratings ra ON p.product_id = ra.product_id
WHERE ra.average_rating >= 4.0
AND ra.total_reviews >= 3  -- Minimum 3 reviews for reliability
ORDER BY ra.average_rating DESC, ra.total_reviews DESC;

-- Query 6: Top 5 highest rated products
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    ra.average_rating,
    ra.total_reviews,
    ra.five_star_count,
    ra.four_star_count
FROM Products p
INNER JOIN Ratings ra ON p.product_id = ra.product_id
ORDER BY ra.average_rating DESC
LIMIT 5;

-- Query 7: Products below average rating (Need improvement)
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    ra.average_rating,
    ra.total_reviews,
    GROUP_CONCAT(DISTINCT c.customer_name ORDER BY c.customer_name SEPARATOR ', ') as negative_reviewers
FROM Products p
INNER JOIN Ratings ra ON p.product_id = ra.product_id
LEFT JOIN Reviews r ON p.product_id = r.product_id AND r.rating <= 2
LEFT JOIN Customers c ON r.customer_id = c.customer_id
WHERE ra.average_rating < 3.0
GROUP BY p.product_id, p.product_name, p.price, ra.average_rating, ra.total_reviews;

-- Query 8: Most helpful reviews (sorted by helpful count)
SELECT 
    r.review_id,
    r.product_id,
    p.product_name,
    c.customer_name,
    r.rating,
    r.review_text,
    r.helpful_count,
    r.review_date
FROM Reviews r
INNER JOIN Products p ON r.product_id = p.product_id
INNER JOIN Customers c ON r.customer_id = c.customer_id
ORDER BY r.helpful_count DESC
LIMIT 10;

-- ============================================================================
-- 8. VIEW DEFINITIONS FOR EASY ACCESS
-- ============================================================================

-- View: Product Review Summary
CREATE OR REPLACE VIEW vw_product_review_summary AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    ra.average_rating,
    ra.total_reviews,
    ra.five_star_count,
    ra.four_star_count,
    ra.three_star_count,
    ra.two_star_count,
    ra.one_star_count,
    CASE 
        WHEN ra.average_rating >= 4.5 THEN 'Excellent'
        WHEN ra.average_rating >= 4.0 THEN 'Very Good'
        WHEN ra.average_rating >= 3.0 THEN 'Good'
        WHEN ra.average_rating >= 2.0 THEN 'Fair'
        ELSE 'Poor'
    END as rating_category
FROM Products p
LEFT JOIN Ratings ra ON p.product_id = ra.product_id;

-- View: Highly Rated Products
CREATE OR REPLACE VIEW vw_highly_rated_products AS
SELECT 
    product_id,
    product_name,
    category,
    price,
    average_rating,
    total_reviews
FROM vw_product_review_summary
WHERE average_rating >= 4.0
AND total_reviews >= 3
ORDER BY average_rating DESC;

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
