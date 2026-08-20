/*Database Creation*/
create database ecommerce_sales;
use ecommerce_sales;

/*Tables creations*/
create table customers(
customer_id int primary key,
country varchar(50),
signup_date date
);

create table orders(
order_id int primary key,
customer_id int,
order_date date,
status varchar(30),
foreign key (customer_id) references customers(customer_id)
);

create table products(
product_id int primary key,
product_name varchar(30),
category varchar(50)
);

create table order_items(
order_id int,
product_id int,
quantity int,
price decimal(10,2),
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products(product_id)
);


drop table order_items;


