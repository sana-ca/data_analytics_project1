--find top 10 highest reveue generating products 
select top 10 product_id,sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc




--find top 5 highest selling products in each region
with cte as (
select region,product_id,sum(sale_price) as sales
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5



--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
	)
select order_month
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month





--for each category which month had highest sales 
with cte as (
select category,format(order_date,'yyyyMM') as order_year_month
, sum(sale_price) as sales 
from df_orders
group by category,format(order_date,'yyyyMM')
--order by category,format(order_date,'yyyyMM')
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn=1






--which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,year(order_date) as order_year,
sum(sale_price) as sales
from df_orders
group by sub_category,year(order_date)
--order by year(order_date),month(order_date)
	)
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
select top 1 *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) desc

-- This query finds the products that generated the highest total profit
SELECT TOP 10 
    product_id, 
    SUM(profit) AS total_profit
FROM df_orders
GROUP BY product_id
ORDER BY total_profit DESC;


-- This query analyzes quarterly sales performance across all years
SELECT 
    CONCAT(YEAR(order_date), '-Q', DATEPART(QUARTER, order_date)) AS quarter,
    SUM(sale_price) AS total_sales
FROM df_orders
GROUP BY YEAR(order_date), DATEPART(QUARTER, order_date)
ORDER BY quarter;


-- This query identifies returning customers who made purchases in multiple years
SELECT 
    customer_id,
    MIN(YEAR(order_date)) AS first_year,
    MAX(YEAR(order_date)) AS last_year,
    COUNT(DISTINCT YEAR(order_date)) AS active_years
FROM df_orders
GROUP BY customer_id
HAVING COUNT(DISTINCT YEAR(order_date)) > 1;


-- This query calculates the contribution of each product category to total sales
SELECT 
    category,
    SUM(sale_price) AS category_sales,
    ROUND(100.0 * SUM(sale_price) / (SELECT SUM(sale_price) FROM df_orders), 2) AS percentage_contribution
FROM df_orders
GROUP BY category
ORDER BY category_sales DESC;


-- This query lists the most frequently purchased products based on order count
SELECT TOP 10 
    product_id, 
    COUNT(*) AS purchase_count
FROM df_orders
GROUP BY product_id
ORDER BY purchase_count DESC;


-- This query detects products with at least three consecutive months of declining sales
WITH monthly_sales AS (
    SELECT 
        product_id, 
        FORMAT(order_date, 'yyyyMM') AS month, 
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY product_id, FORMAT(order_date, 'yyyyMM')
),
decline_flag AS (
    SELECT *,
        LAG(sales) OVER(PARTITION BY product_id ORDER BY month) AS prev_month_sales
    FROM monthly_sales
)
SELECT product_id
FROM decline_flag
WHERE sales < prev_month_sales
GROUP BY product_id
HAVING COUNT(*) >= 3;


-- This query evaluates how different discount amounts affect order volume and revenue
SELECT 
    ROUND(discount, 2) AS discount_range,
    COUNT(*) AS orders,
    SUM(sale_price) AS total_sales
FROM (
    SELECT 
        sale_price, 
        ROUND((list_price - sale_price), 2) AS discount
    FROM df_orders
    WHERE list_price IS NOT NULL
) sub
GROUP BY ROUND(discount, 2)
ORDER BY discount_range;


-- This query calculates the average delivery time per region
SELECT 
    region,
    AVG(DATEDIFF(DAY, order_date, ship_date)) AS avg_delivery_days
FROM df_orders
WHERE ship_date IS NOT NULL
GROUP BY region;

