--select * from [dbo].[df_orders]

--find top 10 highest revenue generating products

SELECT 
	TOP 10  product_id
	,SUM(sale_price) as price
FROM df_orders
GROUP BY product_id
ORDER BY SUM(sale_price) desc

--find top 5 highest sailing products in each region

;WITH cte AS 
(
SELECT 
	region
	,product_id
	,SUM(sale_price) as price
	,ROW_NUMBER() OVER(PARTITION BY region ORDER BY SUM(sale_price) DESC) AS rn
FROM df_orders
GROUP BY region,product_id
) 
SELECT region,product_id,price
FROM cte
WHERE rn<=5

--find month over month comparison for 2022 and 2023 sales EX:jan 2022 vs jan 2023

WITH cte AS 
(
SELECT 
	YEAR(order_date) AS FinanicalYear
	,MONTH(order_date) AS FinanicalMonth
	,SUM(sale_price) AS sales
FROM df_orders
GROUP BY YEAR(order_date),MONTH(order_date)
--order by year(order_date),month(order_date)
) --select * from cte
SELECT 
	finanicalMonth 
	,SUM(CASE WHEN finanicalyear='2022' THEN sales END)AS year2022
	,SUM(CASE WHEN finanicalyear='2023'THEN sales END) AS year2023
FROM cte
GROUP BY finanicalMonth
ORDER BY FinanicalMonth

----for each category which month had highest sales

WITH cte AS 
(
SELECT 
	category
	,FORMAT(order_date,'yyyyMM') as Order_date
	,SUM(sale_price) as price
FROM df_orders
GROUP BY category,FORMAT(order_date,'yyyyMM') 
--order by category,format(order_date,'yyyyMM')
) 
SELECT * FROM 
(
SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY category  ORDER BY price DESC) rn
FROM cte
) a 
WHERE rn=1

---- which sub category had highets growth profit in 2023 compare to 2022

WITH CTE AS 
(
SELECT 
	sub_category
	,YEAR(order_date) as FinanicalYear
	,MONTH(order_date) as FinanicalMonth
	,SUM(sale_price) as sales
FROM df_orders
GROUP BY sub_category,YEAR(order_date),MONTH(order_date)
--order by year(order_date),month(order_date)
) --select * from cte
,cte2 AS
(
SELECT 
	sub_category 
	,SUM(CASE WHEN finanicalyear='2022' THEN sales END)AS year2022
	,SUM(CASE WHEN finanicalyear='2023'THEN sales END) AS year2023
FROM cte
GROUP BY sub_category
--order by sub_category
) 
SELECT 
	TOP 1 *
	,(year2023-year2022) AS growth
FROM cte2
ORDER BY (year2023-year2022) DESC



