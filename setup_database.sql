-- SQL Assignment: Query Fundamentals & Data Warehousing
drop database if exists sql_assignment;
CREATE DATABASE sql_assignment;
USE sql_assignment;


CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    managerId INT NULL,
    salary INT NOT NULL
);

INSERT INTO Employee (id, name, department, managerId, salary) VALUES
(101, 'John',  'A', NULL, 300),
(102, 'Dan',   'A', 101, 200),
(103, 'James', 'A', 101, 300),
(104, 'Amy',   'A', 101, 100),
(105, 'Anne',  'A', 101, 200),
(106, 'Ron',   'B', 101, 100),
(107, 'Sam',   'B', NULL, 400);




CREATE TABLE RequestAccepted (
    requester_id INT NOT NULL,
    accepter_id INT NOT NULL,
    accept_date DATE NOT NULL,
    PRIMARY KEY (requester_id, accepter_id)
);

INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');




CREATE TABLE Seat (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO Seat (id, name) VALUES
(1, 'Abbot'),
(2, 'Doris'),
(3, 'Emerson'),
(4, 'Green'),
(5, 'Jeames');




CREATE TABLE Product (
    product_key INT PRIMARY KEY
);

CREATE TABLE Customer (
    customer_id INT NOT NULL,
    product_key INT NOT NULL,
    FOREIGN KEY (product_key) REFERENCES Product(product_key)
);

INSERT INTO Product (product_key) VALUES
(5), (6);

INSERT INTO Customer (customer_id, product_key) VALUES
(1, 5),
(2, 6),
(3, 5),
(3, 6),
(1, 6),
(1, 6); -- duplicate intentionally allowed by assignment



CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    join_date DATE NOT NULL,
    favorite_brand VARCHAR(100)
);

CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    item_brand VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    item_id INT NOT NULL,
    buyer_id INT NOT NULL,
    seller_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES Items(item_id),
    FOREIGN KEY (buyer_id) REFERENCES Users(user_id),
    FOREIGN KEY (seller_id) REFERENCES Users(user_id)
);

INSERT INTO Users (user_id, join_date, favorite_brand) VALUES
(1, '2018-01-01', 'Lenovo'),
(2, '2018-02-09', 'Samsung'),
(3, '2018-01-19', 'LG'),
(4, '2018-05-21', 'HP');

INSERT INTO Items (item_id, item_brand) VALUES
(1, 'Samsung'),
(2, 'Lenovo'),
(3, 'LG'),
(4, 'HP');

INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id) VALUES
(1, '2019-08-01', 4, 1, 2),
(2, '2018-08-02', 2, 1, 3),
(3, '2019-08-03', 3, 2, 3),
(4, '2018-08-04', 1, 4, 2),
(5, '2018-08-04', 1, 3, 4),
(6, '2019-08-05', 2, 2, 4);

CREATE TABLE Traffic (
    user_id INT NOT NULL,
    activity ENUM('login', 'logout', 'jobs', 'groups', 'homepage') NOT NULL,
    activity_date DATE NOT NULL
);

INSERT INTO Traffic (user_id, activity, activity_date) VALUES
(1, 'login',    '2019-05-01'),
(1, 'homepage', '2019-05-01'),
(1, 'logout',   '2019-05-01'),
(2, 'login',    '2019-06-21'),
(2, 'logout',   '2019-06-21'),
(3, 'login',    '2019-01-01'),
(3, 'jobs',     '2019-01-01'),
(3, 'logout',   '2019-01-01'),
(4, 'login',    '2019-06-21'),
(4, 'groups',   '2019-06-21'),
(4, 'logout',   '2019-06-21'),
(5, 'login',    '2019-03-01'),
(5, 'logout',   '2019-03-01'),
(5, 'login',    '2019-06-21'),
(5, 'logout',   '2019-06-21');



CREATE TABLE Products (
    product_id INT NOT NULL,
    new_price INT NOT NULL,
    change_date DATE NOT NULL,
    PRIMARY KEY (product_id, change_date)
);

INSERT INTO Products (product_id, new_price, change_date) VALUES
(1, 20, '2019-08-14'),
(2, 50, '2019-08-14'),
(1, 30, '2019-08-15'),
(1, 35, '2019-08-16'),
(2, 65, '2019-08-17'),
(3, 20, '2019-08-18');



CREATE TABLE Transactions (
    id INT PRIMARY KEY,
    country VARCHAR(20),
    state ENUM('approved', 'declined') NOT NULL,
    amount INT NOT NULL,
    trans_date DATE NOT NULL
);

CREATE TABLE Chargebacks (
    trans_id INT NOT NULL,
    trans_date DATE NOT NULL,
    FOREIGN KEY (trans_id) REFERENCES Transactions(id)
);

INSERT INTO Transactions (id, country, state, amount, trans_date) VALUES
(101, 'US', 'approved', 1000, '2019-05-18'),
(102, 'US', 'declined', 2000, '2019-05-19'),
(103, 'US', 'approved', 3000, '2019-06-10'),
(104, 'US', 'declined', 4000, '2019-06-13'),
(105, 'US', 'approved', 5000, '2019-06-15');

INSERT INTO Chargebacks (trans_id, trans_date) VALUES
(102, '2019-05-29'),
(101, '2019-06-30'),
(105, '2019-09-18');



CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL
);

CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    host_team INT NOT NULL,
    guest_team INT NOT NULL,
    host_goals INT NOT NULL,
    guest_goals INT NOT NULL,
    FOREIGN KEY (host_team) REFERENCES Teams(team_id),
    FOREIGN KEY (guest_team) REFERENCES Teams(team_id)
);

INSERT INTO Teams (team_id, team_name) VALUES
(10, 'Leetcode FC'),
(20, 'NewYork FC'),
(30, 'Atlanta FC'),
(40, 'Chicago FC'),
(50, 'Toronto FC');

INSERT INTO Matches (match_id, host_team, guest_team, host_goals, guest_goals) VALUES
(1, 10, 20, 3, 0),
(2, 30, 10, 2, 2),
(3, 10, 50, 5, 1),
(4, 20, 30, 1, 0),
(5, 50, 30, 1, 0);
