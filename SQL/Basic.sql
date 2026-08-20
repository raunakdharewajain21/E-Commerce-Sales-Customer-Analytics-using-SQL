/*Basics
1. Show first 10 customers.
2. Count total customers.
3. Count total orders. 
4. Count total products.
5. List Unique product categories.
6. Find customers from specific country/state.
7. Show orders sorted by latest date.
8. Find products with highest price.
9. Find products with lowest price.
10. Find orders placed after a specific date.
*/

-- Show first 10 customers.
select * from customers limit 10;

-- Count total customers.
select count(*) As Total_Customers from customers;

-- Count total orders. 
select count(*) as Total_orders from orders;

-- Count total products.
select count(*) as Total_Product from products;

-- List Unique product categories.
select distinct products.category from products;

-- Find customers from specific country/state.
select * from customers where country = 'Italy';

-- Show orders sorted by latest date.
select * from orders order by order_date desc;

-- Find products with highest price.
select * from order_items order by price desc limit 1;

-- Find products with lowest price.
select * from order_items order by price asc limit 1;

-- Find orders placed after a specific date.
select * from orders where order_date > '2024-07-01' order by order_date;