-- 6) find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity),
            0) AS Total_Quantity_ordered
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category
ORDER BY Total_Quantity_ordered DESC


-- 7) Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time), COUNT(order_id) AS Orders_per_hour_count
FROM
    orders
GROUP BY HOUR(order_time)


-- 8) Join relevant tables to find the category-wise distribution of pizzas

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category


-- -- 9) Group the orders by date and 
--       calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) as Avg_pizzas_orederd_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
    
    -- 10) Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC
LIMIT 3




    