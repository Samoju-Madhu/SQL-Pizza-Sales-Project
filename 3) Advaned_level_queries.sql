-- 11) Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    ROUND((SUM(order_details.quantity * pizzas.price) / 
        (SELECT ROUND(SUM(pizzas.price * order_details.quantity), 2) 
         FROM pizzas 
         JOIN order_details ON pizzas.pizza_id = order_details.pizza_id)
    ) * 100,2) AS revenue
FROM 
    pizza_types
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    revenue DESC;
    
    
    -- 12) Analyze the cumulative revenue generated over time.


SELECT order_date,
SUM(revenue) over(order by order_date) as cum_revenue
From
(SELECT orders.order_date,
SUM(order_details.quantity*pizzas.price) as revenue from orders
JOIN order_details
ON orders.order_id = order_details.order_id
JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id
GROUP by orders.order_date) as sales 


-- 13) Determine the top 3 most ordered pizza types based on revenue for each pizza category.


WITH RankedPizzas AS (
SELECT pizza_types.category,pizza_types.name,
ROUND(Sum(order_details.quantity*pizzas.price),0) as revenue,
RANK() OVER(PARTITION BY pizza_types.category ORDER BY Sum(order_details.quantity*pizzas.price)DESC) as 'rank'
from order_details
JOIN pizzas
ON order_details.pizza_id=pizzas.pizza_id
JOIN pizza_types
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category,pizza_types.name 
)
SELECT 
    category,
    name,
    revenue,
    `rank`
FROM 
    RankedPizzas
WHERE 
    `rank` <= 3
ORDER BY 
    category, `rank`;