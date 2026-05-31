-- ============================================================
--   Smart Library Management System
--   Complete SQL Script - ERROR FREE
--   Run: Ctrl+A then Ctrl+Shift+Enter in MySQL Workbench
-- ============================================================

-- -----------------------------------------------
-- STEP 1: Database Setup
-- -----------------------------------------------

CREATE DATABASE LibraryDB;
USE LibraryDB;

-- -----------------------------------------------
-- STEP 2: Create Tables (with FK Relationships)
-- -----------------------------------------------

-- Table 1: Authors
CREATE TABLE Authors (
    author_id   INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100),
    PRIMARY KEY (author_id)
);

-- Table 2: Books
CREATE TABLE Books (
    book_id          INT           NOT NULL AUTO_INCREMENT,
    title            VARCHAR(200)  NOT NULL,
    author_id        INT           NOT NULL,
    category         VARCHAR(50)   NOT NULL,
    isbn             VARCHAR(20)   NOT NULL,
    published_date   DATE          NOT NULL,
    price            DECIMAL(10,2) NOT NULL,
    available_copies INT           NOT NULL DEFAULT 1,
    PRIMARY KEY (book_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

-- Table 3: Members
CREATE TABLE Members (
    member_id       INT          NOT NULL AUTO_INCREMENT,
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(100),
    phone_number    VARCHAR(15),
    membership_date DATE         NOT NULL,
    PRIMARY KEY (member_id)
);

-- Table 4: Transactions
CREATE TABLE Transactions (
    transaction_id INT           NOT NULL AUTO_INCREMENT,
    member_id      INT           NOT NULL,
    book_id        INT           NOT NULL,
    borrow_date    DATE          NOT NULL,
    return_date    DATE,
    fine_amount    DECIMAL(10,2) DEFAULT 0.00,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id)   REFERENCES Books(book_id)
);

-- -----------------------------------------------
-- STEP 3: Insert Sample Data
-- -----------------------------------------------

INSERT INTO Authors (name, email) VALUES
('J.K. Rowling',    'jk@email.com'),
('George Orwell',   'george@email.com'),
('Stephen Hawking', 'stephen@email.com'),
('Dan Brown',       'dan@email.com'),
('Agatha Christie', NULL);

INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies) VALUES
('Harry Potter',          1, 'Fiction',  'ISBN001', '2021-06-01', 450.00, 5),
('Animal Farm',           2, 'Fiction',  'ISBN002', '1999-08-17', 250.00, 3),
('A Brief History',       3, 'Science',  'ISBN003', '2016-03-10', 399.00, 2),
('The Da Vinci Code',     4, 'Thriller', 'ISBN004', '2018-05-20', 499.00, 4),
('Murder on the Orient',  5, 'Mystery',  'ISBN005', '1995-11-01', 300.00, 0),
('1984',                  2, 'Fiction',  'ISBN006', '2000-07-08', 275.00, 6),
('Angels and Demons',     4, 'Thriller', 'ISBN007', '2017-09-15', 420.00, 3),
('The Grand Design',      3, 'Science',  'ISBN008', '2019-04-22', 350.00, 2),
('Inferno',               4, 'Thriller', 'ISBN009', '2022-01-10', 510.00, 1),
('And Then There Were',   5, 'Mystery',  'ISBN010', '1998-03-05', 280.00, 0);

INSERT INTO Members (name, email, phone_number, membership_date) VALUES
('Rahul Sharma',  'rahul@email.com',  '9876543210', '2021-01-15'),
('Priya Singh',   'priya@email.com',  '9876543211', '2020-06-20'),
('Amit Patel',    'amit@email.com',   '9876543212', '2023-03-10'),
('Sneha Gupta',   NULL,               '9876543213', '2019-11-05'),
('Raj Kumar',     'raj@email.com',    '9876543214', '2022-08-18'),
('Neha Verma',    'neha@email.com',   '9876543215', '2024-01-01'),
('Vikram Das',    'vikram@email.com', '9876543216', '2021-07-30');

INSERT INTO Transactions (member_id, book_id, borrow_date, return_date, fine_amount) VALUES
(1, 1, '2024-01-10', '2024-01-25', 0.00),
(1, 3, '2024-03-01', '2024-03-20', 0.00),
(2, 2, '2024-02-05', '2024-02-28', 50.00),
(2, 4, '2024-04-10', '2024-04-30', 0.00),
(3, 5, '2024-05-01', NULL,         100.00),
(4, 1, '2023-12-01', '2023-12-15', 0.00),
(4, 6, '2024-06-01', NULL,         0.00),
(5, 7, '2024-01-20', '2024-02-10', 75.00),
(6, 9, '2025-11-01', NULL,         0.00),
(7, 2, '2025-10-15', '2025-10-30', 0.00);

-- -----------------------------------------------
-- VERIFY DATA
-- -----------------------------------------------
SELECT 'Authors:'     AS TableName; SELECT * FROM Authors;
SELECT 'Books:'       AS TableName; SELECT * FROM Books;
SELECT 'Members:'     AS TableName; SELECT * FROM Members;
SELECT 'Transactions:'AS TableName; SELECT * FROM Transactions;

-- ============================================================
-- TASK 1: CRUD OPERATIONS
-- ============================================================

-- INSERT new book, author, member
SELECT '--- TASK 1: CRUD ---' AS Task;

INSERT INTO Authors (name, email)
VALUES ('New Author', 'newauthor@email.com');

INSERT INTO Books (title, author_id, category, isbn, published_date, price, available_copies)
VALUES ('New Book', 6, 'Fiction', 'ISBN011', '2024-01-01', 300.00, 5);

INSERT INTO Members (name, email, phone_number, membership_date)
VALUES ('New Member', 'newmember@email.com', '9999999999', '2024-06-01');

-- UPDATE: book availability after borrow/return
UPDATE Books
SET available_copies = available_copies - 1
WHERE book_id = 1;

UPDATE Books
SET available_copies = available_copies + 1
WHERE book_id = 1;

-- DELETE: members who haven't borrowed in last year
DELETE FROM Members
WHERE member_id NOT IN (
    SELECT DISTINCT member_id
    FROM Transactions
    WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- SELECT: all books with available copies
SELECT title, category, available_copies
FROM Books
WHERE available_copies > 0;

-- ============================================================
-- TASK 2: SQL CLAUSES (WHERE, HAVING, LIMIT)
-- ============================================================
SELECT '--- TASK 2: WHERE / HAVING / LIMIT ---' AS Task;

-- Books published after 2015
SELECT title, published_date, price
FROM Books
WHERE published_date > '2015-12-31';

-- Top 5 most expensive books
SELECT title, price
FROM Books
ORDER BY price DESC
LIMIT 5;

-- Members who joined before 2022
SELECT name, membership_date
FROM Members
WHERE membership_date < '2022-01-01';

-- ============================================================
-- TASK 3: SQL OPERATORS (AND, OR, NOT)
-- ============================================================
SELECT '--- TASK 3: AND / OR / NOT ---' AS Task;

-- Science books with price < 500
SELECT title, category, price
FROM Books
WHERE category = 'Science' AND price < 500;

-- Books NOT available for borrowing
SELECT title, available_copies
FROM Books
WHERE NOT available_copies > 0;

-- Members joined after 2020 OR borrowed more than 1 book
SELECT DISTINCT m.name, m.membership_date
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
WHERE m.membership_date > '2020-12-31'
   OR (SELECT COUNT(*) FROM Transactions WHERE member_id = m.member_id) > 1;

-- ============================================================
-- TASK 4: SORTING & GROUPING (ORDER BY, GROUP BY)
-- ============================================================
SELECT '--- TASK 4: ORDER BY / GROUP BY ---' AS Task;

-- Books sorted alphabetically
SELECT title, category
FROM Books
ORDER BY title ASC;

-- Number of books borrowed by each member
SELECT m.name,
       COUNT(t.transaction_id) AS books_borrowed
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name
ORDER BY books_borrowed DESC;

-- Books grouped by category with total count
SELECT category,
       COUNT(*) AS total_books
FROM Books
GROUP BY category
ORDER BY total_books DESC;

-- ============================================================
-- TASK 5: AGGREGATE FUNCTIONS (SUM, AVG, MAX, MIN, COUNT)
-- ============================================================
SELECT '--- TASK 5: AGGREGATE FUNCTIONS ---' AS Task;

-- Total books in each category
SELECT category,
       COUNT(*) AS total_books
FROM Books
GROUP BY category;

-- Average price of books
SELECT ROUND(AVG(price), 2) AS average_price
FROM Books;

-- Most borrowed book
SELECT b.title,
       COUNT(t.transaction_id) AS borrow_count
FROM Books b
JOIN Transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title
ORDER BY borrow_count DESC
LIMIT 1;

-- Total fines collected
SELECT SUM(fine_amount) AS total_fines
FROM Transactions;

-- ============================================================
-- TASK 6: PRIMARY & FOREIGN KEY (already established above)
-- Verify relationships
-- ============================================================
SELECT '--- TASK 6: KEY RELATIONSHIPS ---' AS Task;

-- Books linked to authors
SELECT b.title, a.name AS author_name
FROM Books b
JOIN Authors a ON b.author_id = a.author_id;

-- Members linked to transactions
SELECT m.name, COUNT(t.transaction_id) AS transactions
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
GROUP BY m.member_id, m.name;

-- ============================================================
-- TASK 7: JOINS
-- ============================================================
SELECT '--- TASK 7: JOINS ---' AS Task;

-- INNER JOIN: Books with author names
SELECT b.title, a.name AS author, b.category, b.price
FROM Books b
INNER JOIN Authors a ON b.author_id = a.author_id;

-- LEFT JOIN: Members who have borrowed books
SELECT m.name, t.book_id, t.borrow_date
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id;

-- RIGHT JOIN: Books that haven't been borrowed
SELECT b.title, t.transaction_id
FROM Transactions t
RIGHT JOIN Books b ON t.book_id = b.book_id
WHERE t.transaction_id IS NULL;

-- FULL OUTER JOIN (UNION in MySQL): Members who never borrowed
SELECT m.name, t.transaction_id
FROM Members m
LEFT JOIN Transactions t ON m.member_id = t.member_id
WHERE t.transaction_id IS NULL
UNION
SELECT m.name, t.transaction_id
FROM Members m
RIGHT JOIN Transactions t ON m.member_id = t.member_id;

-- ============================================================
-- TASK 8: SUBQUERIES
-- ============================================================
SELECT '--- TASK 8: SUBQUERIES ---' AS Task;

-- Books borrowed by members who registered after 2022
SELECT DISTINCT b.title
FROM Books b
WHERE b.book_id IN (
    SELECT t.book_id
    FROM Transactions t
    WHERE t.member_id IN (
        SELECT member_id
        FROM Members
        WHERE membership_date > '2022-12-31'
    )
);

-- Most borrowed book using subquery
SELECT title
FROM Books
WHERE book_id = (
    SELECT book_id
    FROM Transactions
    GROUP BY book_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Members who have never borrowed a book
SELECT name
FROM Members
WHERE member_id NOT IN (
    SELECT DISTINCT member_id FROM Transactions
);

-- ============================================================
-- TASK 9: DATE & TIME FUNCTIONS
-- ============================================================
SELECT '--- TASK 9: DATE FUNCTIONS ---' AS Task;

-- Count books by publication year
SELECT YEAR(published_date) AS pub_year,
       COUNT(*)             AS total_books
FROM Books
GROUP BY pub_year
ORDER BY pub_year;

-- Days borrowed & fine calculation
SELECT t.transaction_id,
       m.name,
       b.title,
       t.borrow_date,
       COALESCE(t.return_date, CURDATE()) AS return_date,
       DATEDIFF(COALESCE(t.return_date, CURDATE()), t.borrow_date) AS days_borrowed,
       t.fine_amount
FROM Transactions t
JOIN Members m ON t.member_id = m.member_id
JOIN Books   b ON t.book_id   = b.book_id;

-- Format borrow_date as DD-MM-YYYY
SELECT transaction_id,
       DATE_FORMAT(borrow_date, '%d-%m-%Y') AS formatted_borrow_date
FROM Transactions;

-- ============================================================
-- TASK 10: STRING MANIPULATION FUNCTIONS
-- ============================================================
SELECT '--- TASK 10: STRING FUNCTIONS ---' AS Task;

-- Convert book titles to UPPERCASE
SELECT book_id,
       UPPER(title) AS title_upper
FROM Books;

-- Trim whitespace from author names
SELECT author_id,
       TRIM(name) AS clean_name
FROM Authors;

-- Replace NULL email with 'Not Provided'
SELECT member_id,
       name,
       COALESCE(email, 'Not Provided') AS email
FROM Members;

-- ============================================================
-- TASK 11: WINDOW FUNCTIONS
-- ============================================================
SELECT '--- TASK 11: WINDOW FUNCTIONS ---' AS Task;

-- Rank books by borrow count
SELECT b.title,
       COUNT(t.transaction_id) AS borrow_count,
       RANK() OVER (ORDER BY COUNT(t.transaction_id) DESC) AS borrow_rank
FROM Books b
LEFT JOIN Transactions t ON b.book_id = t.book_id
GROUP BY b.book_id, b.title;

-- Cumulative books borrowed per member
SELECT m.name,
       t.borrow_date,
       COUNT(t.transaction_id) OVER (
           PARTITION BY t.member_id
           ORDER BY t.borrow_date
       ) AS cumulative_borrows
FROM Members m
JOIN Transactions t ON m.member_id = t.member_id;

-- Moving average of books borrowed in last 3 months
SELECT DATE_FORMAT(borrow_date, '%Y-%m') AS month,
       COUNT(*) AS monthly_borrows,
       AVG(COUNT(*)) OVER (
           ORDER BY DATE_FORMAT(borrow_date, '%Y-%m')
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS moving_avg
FROM Transactions
GROUP BY DATE_FORMAT(borrow_date, '%Y-%m');

-- ============================================================
-- TASK 12: CASE EXPRESSIONS
-- ============================================================
SELECT '--- TASK 12: CASE EXPRESSIONS ---' AS Task;

-- Membership Status: Active / Inactive (last 6 months)
SELECT m.name,
       m.membership_date,
       CASE
           WHEN m.member_id IN (
               SELECT DISTINCT member_id
               FROM Transactions
               WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
           ) THEN 'Active'
           ELSE 'Inactive'
       END AS Membership_Status
FROM Members m;

-- Categorize books: New Arrival / Classic / Regular
SELECT title,
       published_date,
       CASE
           WHEN YEAR(published_date) > 2020 THEN 'New Arrival'
           WHEN YEAR(published_date) < 2000 THEN 'Classic'
           ELSE 'Regular'
       END AS book_category
FROM Books;

-- ============================================================
--          ALL TASKS COMPLETED SUCCESSFULLY!
-- ============================================================
SELECT 'Smart Library Management System - ALL DONE!' AS FinalMessage;