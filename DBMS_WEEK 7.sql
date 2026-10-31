CREATE DATABASE EcommerceDB;
USE EcommerceDB;

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Email VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

INSERT INTO Customer VALUES
(1, 'Ravi', 'ravi@gmail.com', 'Chennai'),
(2, 'Arun', 'arun@gmail.com', 'Pondicherry'),
(3, 'Kumar', 'kumar@gmail.com', 'Bangalore'),
(4, 'Priya', 'priya@gmail.com', 'Chennai');

INSERT INTO Product VALUES
(101, 'Laptop', 'Electronics', 75000, 10),
(102, 'Mobile', 'Electronics', 20000, 25),
(103, 'Python Book', 'Books', 800, 30),
(104, 'Mens Shirt', 'Cloths', 1000, 20),
(105, 'Mens Pant', 'Cloths', 2000, 15),
(106, 'DBMS Book', 'Books', 1500, 8);

SELECT * FROM Product;


SELECT * FROM Product
WHERE Price > 10000;

SELECT * FROM Product
ORDER BY Price ASC;

SELECT DISTINCT Category
FROM Product;

SELECT * FROM Product
WHERE Price BETWEEN 1000 AND 20000;

SELECT * FROM Product
WHERE Category = 'Electronics';

SELECT * FROM Product
WHERE Stock > 0;

SELECT * FROM Product
WHERE Stock = 0;

SELECT * FROM Customer;

SELECT ProductName, Price, Stock
FROM Product;

SELECT * FROM Product
WHERE Category = 'Electronics'
AND Price < 50000;

SELECT * FROM Product
WHERE Stock < 10;

SELECT * FROM Product
ORDER BY Price DESC;

SELECT Category, COUNT(*) AS TotalProducts
FROM Product
GROUP BY Category;

SELECT Category, AVG(Price) AS AveragePrice
FROM Product
GROUP BY Category;

SELECT Category, SUM(Stock) AS TotalStock
FROM Product
GROUP BY Category;
