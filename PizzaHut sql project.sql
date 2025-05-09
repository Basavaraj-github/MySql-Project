Create database PizzaHut;
use PizzaHut;

select * from order_details;
select * from pizzas;
select * from pizza_types;
select * from orders;

-- pizza_id,	pizza_type_id,	size,	price __ Table Pizzas
-- pizza_type_id	name	category	ingredients __ Pizza_types
-- order_id	 date	time __ orders
-- order_details_id, 	order_id,	pizza_id,	quantity __ order Details

-- 1) Retrive the total number of order placed
select count(order_id) as "total_orders"  from orders;

-- 2) Calculate the total revenue generated from Pizza Sales
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            3) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- 3) Identify the Higest-priced Pizza
SELECT 
    pizza_types.name, MAX(pizzas.price)
FROM
    Pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizzas.pizza_type_id;

-- 4) Identify the most commonly ordered pizza size
SELECT 
    pizzas.pizza_id,
    Pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;

-- 5) List 5 most ordered pizza types along with the quantity
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS most_ordered_types
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.Pizza_id
GROUP BY pizza_types.name
ORDER BY most_ordered_types
LIMIT 5;


-- Intermidiate Level

-- 1) Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as "total_Quantity" from 
pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by total_Quantity desc;

-- 2) Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(orders.time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(orders.time);

-- 3) Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) as pizza_types from pizza_types
group by category;

-- 4) Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantity) as avg_number_pizza_per_day from 
(Select orders.date, sum(order_details.quantity) as quantity
from order_details join orders 
on order_details.order_id=orders.order_id) as order_quantity;

-- 5) Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS 'revenue'
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    Pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY Pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
Select pizza_types.category, 
(sum(order_details.quantity*pizzas.price)/ (select sum(order_details.quantity* pizzas.price) from order_details 
join pizzas on pizzas.pizza_id= order_details.pizza_id)*100) as "percentage of each type"
 from order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    Pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY Pizza_types.category;

-- 2) Analyze the cumulative revenue generated over time.
select sales.date, sum(revenue) Over(order by orders.date) 
from
(select orders.date, 
SUM(order_details.quantity * pizzas.price) AS 'revenue'
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    orders ON orders.order_id = order_details.order_id
    group by orders.date) as sales;

