/*Business Analytics
31. Top 10 customers by spending.
32. Top 10 selling products.
33. Top revenue-generating categories.
34. Monthly sales trend.
35. Daily sales trend.
36. Repeat customers.
37. Customers with only one order.
38. Highest spending customer in each month.
39. Most popular product category.
40. Top 5 orders by revenue.
*/

-- Top 10 customers by spending.
select 
c.customer_id,
c.country,
sum(oi.quantity * oi.price) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id,c.country
order by total_spent desc
limit 10;

-- Top 10 selling products.
select 
p.product_name,
sum(oi.quantity) as quantity_sold
from products p
join order_items oi on oi.product_id = p.product_id
group by p.product_name
order by quantity_sold desc
limit 10;

-- Top revenue-generating categories.
select
p.category,
sum(oi.quantity * oi.price) as revenue
from products p
join order_items oi on p.product_id = oi.product_id
group by p.category
order by revenue desc;

-- Monthly sales trend.
select month(o.order_date) as month,
sum(oi.quantity * oi.price) as revenue
from orders o
join order_items oi on o.order_id = oi.order_id
group by month(o.order_date)
order by month;

-- Daily sales trend.
select o.order_date,
sum(oi.quantity * oi.price) as daily_revenue
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.order_date
order by o.order_date;

-- Repeat customers.
select customer_id,
count(order_id) as total_orders
from orders
group by customer_id
Having count(order_id) > 1
order by total_orders desc;

-- Customers with only one order.
select customer_id,
count(order_id) as total_orders
from orders
group by customer_id
Having count(order_id) = 1;

-- Highest spending customer in each month.
select month(o.order_date) as month,
c.customer_id,
sum(oi.quantity * oi.price) as revenue
from customers c
join orders o on o.order_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by month(o.order_date),c.customer_id
order by month, revenue desc;

-- Most popular product category.
select p.category,
sum(oi.quantity) as quantity_sold
from products p
Join order_items oi on p.product_id = oi.product_id
group by p.category
order by quantity_sold desc;

-- Top 5 orders by revenue.
select o.order_id,
sum(oi.quantity * oi.price) as revenue
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.order_id
order by revenue desc
limit 5;
