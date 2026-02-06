create database pizzahouse;
use pizzahouse;
CREATE TABLE orders(
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY (order_id)
) ;

CREATE TABLE order_details(
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT  NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY (order_details_id)
) ;

select * from orders; # (order_id, date, time) 
select * from order_details; # (order_details_id, pizza_id, quantity, order_id)
select * from pizzas; # (pizza_id,pizza_type_id,size, price)
select * from pizza_types; # (pizza_type_id, name, category ,ingredients) 


# .....retreiving the total number of orders placed....

select count(order_id) 
as total_num_of_orders 
from orders;

# .... revenue generated from the pizza sales ....

SELECT ROUND(SUM((od.quantity*p.price)), 3) AS total_sales
FROM order_details AS od
JOIN pizzas AS p
ON p.pizza_id = od.pizza_id  ;


# ----the highest priced pizzas identifying----

select pizza_id, max(price) 
as highest_priced_pizza 
from pizzas
group by pizza_id
order by highest_priced_pizza desc
limit 1;

#----the most common pizza size ordered----
select p.size, count(od.quantity) 
as common_order_size
from order_details as od
join pizzas as p
on od.pizza_id= p.pizza_id
group by 1
order by p.size;

#----list the 10 most ordered pizza types and their quantities----

select pt.name, count(od.quantity) as total_quantity
from  pizza_types as pt
join pizzas as p
on p.pizza_type_id=pt.pizza_type_id
join order_details as od
on od.pizza_id=p.pizza_id
group by 1

limit 10;

#---determining the hour of the day for most orders distributed----

alter table orders
change time order_time varchar(200);
select count(order_id) as total_orders, 
hour(order_time) as ordered_time
from orders
group by ordered_time
order by total_orders desc;

#---- total orders of each pizza item ----

SELECT SUM(od.quantity) AS total_quantity , pt.name AS name
FROM order_details AS od
JOIN pizzas AS p
ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
ON pt.pizza_type_id = p.pizza_type_id
GROUP BY name
ORDER BY  total_quantity DESC; 


#---- finding top 5 most ordered pizza types based on the revenue

select pt.name,sum(od.quantity*p.price) as revenue 
from  pizza_types as pt
join pizzas as p
on pt.pizza_type_id= p.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by 1
order by revenue desc
limit 5



