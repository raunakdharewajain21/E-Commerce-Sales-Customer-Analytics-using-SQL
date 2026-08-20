/*Advanced SQL
41. Rank customers by revenue.
42. Rank products within each category.
43. Customer Lifetime Value (CLV).
44. Running monthly revenue.
45. Revenue classification using CASE.
46. Find customers above average spending.
47. Top 3 products in each category.
48. Create a Sales Summary VIEW.
49. Create a Customer Analytics VIEW.
50. Write one final dashboard query combining all tables.
*/

-- Rank customers by revenue.
SELECT
    c.customer_id,
    c.country,
    SUM(oi.quantity * oi.price) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.price) DESC
    ) AS customer_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.country;

-- Rank products within each category.
SELECT
    p.category,
    p.product_name,
    SUM(oi.quantity) AS quantity_sold,
    ROW_NUMBER() OVER(
        PARTITION BY p.category
        ORDER BY SUM(oi.quantity) DESC
    ) AS rank_in_category
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category, p.product_name;

-- Customer Lifetime Value (CLV).
SELECT
    c.customer_id,
    c.country,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.price) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.country
ORDER BY lifetime_value DESC;

-- Running monthly revenue.
SELECT
    MONTH(o.order_date) AS month,
    SUM(oi.quantity * oi.price) AS monthly_revenue,
    SUM(SUM(oi.quantity * oi.price))
        OVER (ORDER BY MONTH(o.order_date)) AS running_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date);

-- Revenue classification using CASE.
SELECT
    order_id,
    SUM(quantity * price) AS revenue,
    CASE
        WHEN SUM(quantity * price) >= 1000 THEN 'High Value'
        WHEN SUM(quantity * price) >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_type
FROM order_items
GROUP BY order_id;

--Find customers above average spending.
WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(oi.quantity * oi.price) AS total_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales >
      (SELECT AVG(total_sales) FROM customer_sales);
      
-- Top 3 products in each category.
WITH product_rank AS (
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity) AS quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY p.category
            ORDER BY SUM(oi.quantity) DESC
        ) AS rn
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
)
SELECT *
FROM product_rank
WHERE rn <= 3;

-- Create a Sales Summary VIEW.
CREATE VIEW sales_summary AS
SELECT
    o.order_id,
    o.order_date,
    SUM(oi.quantity * oi.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date;

SELECT * FROM sales_summary;

-- Create a Customer Analytics VIEW.
CREATE VIEW customer_analytics AS
SELECT
    c.customer_id,
    c.country,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.country;

SELECT * FROM customer_analytics
ORDER BY total_spent DESC;

-- Write one final dashboard query combining all tables.
SELECT
    c.customer_id,
    c.country,
    p.category,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(oi.quantity) AS items_sold,
    SUM(oi.quantity * oi.price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.country, p.category
ORDER BY revenue DESC;