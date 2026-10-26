USE sql_assignment;




-- =========================================================
-- Q1. Managers with at least five direct reports
-- =========================================================
SELECT manager.name
FROM Employee AS manager
JOIN Employee AS employee
    ON manager.id = employee.managerId
GROUP BY manager.id, manager.name
HAVING COUNT(employee.id) >= 5;


-- =========================================================
-- Q2. Nth highest salary
-- Example: n = 2
-- The scalar subquery returns NULL when no nth distinct salary exists.
-- =========================================================
SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS getNthHighestSalary;

-- For a different n, replace OFFSET 1 with n - 1.
-- Example: n = 3 -> OFFSET 2


-- =========================================================
-- Q3. Person with the most friends
-- =========================================================
SELECT id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id
    FROM RequestAccepted
) AS friends
GROUP BY id
ORDER BY num DESC, id ASC
LIMIT 1;


-- =========================================================
-- Q4. Swap every two consecutive seats
-- =========================================================
SELECT
    CASE
        WHEN id = (SELECT MAX(id) FROM Seat) AND id % 2 = 1 THEN id
        WHEN id % 2 = 1 THEN id + 1
        ELSE id - 1
    END AS id,
    name
FROM Seat
ORDER BY id;


-- =========================================================
-- Q5. Customers who bought every product
-- =========================================================
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT(*)
    FROM Product
);


-- =========================================================
-- Q6. Orders made by each buyer in 2019
-- =========================================================
SELECT
    u.user_id AS buyer_id,
    u.join_date,
    COUNT(o.order_id) AS orders_in_2019
FROM Users AS u
LEFT JOIN Orders AS o
    ON u.user_id = o.buyer_id
    AND o.order_date >= '2019-01-01'
    AND o.order_date < '2020-01-01'
GROUP BY u.user_id, u.join_date;


-- =========================================================
-- Q7. First login date within 90 days of 2019-06-30
-- =========================================================
WITH first_login AS (
    SELECT
        user_id,
        MIN(activity_date) AS login_date
    FROM Traffic
    WHERE activity = 'login'
    GROUP BY user_id
)
SELECT
    login_date,
    COUNT(*) AS user_count
FROM first_login
WHERE login_date BETWEEN DATE_SUB('2019-06-30', INTERVAL 90 DAY)
                     AND '2019-06-30'
GROUP BY login_date;


-- =========================================================
-- Q8. Product prices on 2019-08-16
-- =========================================================
SELECT
    product_id,
    COALESCE(
        MAX(
            CASE
                WHEN change_date <= '2019-08-16' THEN new_price
            END
        ),
        10
    ) AS price
FROM Products
GROUP BY product_id;


-- =========================================================
-- Q9. Monthly approved transactions and chargebacks
-- =========================================================
SELECT
    month,
    country,
    SUM(approved_count) AS approved_count,
    SUM(approved_amount) AS approved_amount,
    SUM(chargeback_count) AS chargeback_count,
    SUM(chargeback_amount) AS chargeback_amount
FROM (
    -- Approved transaction statistics by transaction month
    SELECT
        DATE_FORMAT(trans_date, '%Y-%m') AS month,
        country,
        COUNT(*) AS approved_count,
        SUM(amount) AS approved_amount,
        0 AS chargeback_count,
        0 AS chargeback_amount
    FROM Transactions
    WHERE state = 'approved'
    GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country

    UNION ALL

    -- Chargeback statistics by chargeback month
    SELECT
        DATE_FORMAT(c.trans_date, '%Y-%m') AS month,
        t.country,
        0 AS approved_count,
        0 AS approved_amount,
        COUNT(*) AS chargeback_count,
        SUM(t.amount) AS chargeback_amount
    FROM Chargebacks AS c
    JOIN Transactions AS t
        ON c.trans_id = t.id
    GROUP BY DATE_FORMAT(c.trans_date, '%Y-%m'), t.country
) AS monthly_data
GROUP BY month, country
HAVING
    approved_count <> 0
    OR approved_amount <> 0
    OR chargeback_count <> 0
    OR chargeback_amount <> 0
ORDER BY month, country;


-- =========================================================
-- Q10. Tournament points
-- =========================================================
SELECT
    t.team_id,
    t.team_name,
    COALESCE(
        SUM(
            CASE
                WHEN t.team_id = m.host_team
                     AND m.host_goals > m.guest_goals THEN 3
                WHEN t.team_id = m.guest_team
                     AND m.guest_goals > m.host_goals THEN 3
                WHEN m.host_goals = m.guest_goals THEN 1
                ELSE 0
            END
        ),
        0
    ) AS num_points
FROM Teams AS t
LEFT JOIN Matches AS m
    ON t.team_id = m.host_team
    OR t.team_id = m.guest_team
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC, t.team_id ASC;
