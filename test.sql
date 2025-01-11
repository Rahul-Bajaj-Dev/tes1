-- Creating the database schema
CREATE DATABASE BookStore;
USE BookStore;

-- Table to store book details
CREATE TABLE Books (
    ISBN VARCHAR(13) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Genre VARCHAR(50),
    PublicationYear INT,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL
);

-- Table to store customer details
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    BillingAddress TEXT
);

-- Table to store order details
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Table to store individual books in each order
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
);

-- Query to retrieve all books written by a specific author
SELECT * FROM Books WHERE Author = 'Specific Author';

-- Query to find the total number of copies sold for each book
SELECT 
    b.Title, 
    SUM(od.Quantity) AS TotalCopiesSold
FROM 
    Books b
JOIN 
    OrderDetails od ON b.ISBN = od.ISBN
GROUP BY 
    b.ISBN;

-- Query to calculate the average price of books in a particular genre
SELECT 
    Genre, 
    AVG(Price) AS AveragePrice
FROM 
    Books
WHERE 
    Genre = 'Fiction'
GROUP BY 
    Genre;

-- Query to list all customers who have placed orders above a certain value
SELECT DISTINCT 
    c.CustomerID, c.Name, c.Email
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
WHERE 
    o.TotalAmount > 100;

-- Query to retrieve the order history for a given customer, sorted by order date
SELECT 
    o.OrderID, o.OrderDate, o.TotalAmount
FROM 
    Orders o
WHERE 
    o.CustomerID = 1
ORDER BY 
    o.OrderDate;

-- Procedure to update the stock quantity of a book after an order is placed
DELIMITER //
CREATE PROCEDURE UpdateStockQuantity (IN p_ISBN VARCHAR(13), IN p_Quantity INT)
BEGIN
    UPDATE Books
    SET StockQuantity = StockQuantity - p_Quantity
    WHERE ISBN = p_ISBN;
END
