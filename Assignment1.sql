1 
SELECT fruit_sales_original.fruit_id,fruits_original.fruit_name,
SUM(fruit_sales_original.total_sales_value)
FROM fruit_sales_original
JOIN fruits_original ON fruit_sales_original.fruit_id = fruits_original.fruit_id
WHERE MONTH(fruit_sales_original.order_date) = 05
AND YEAR(fruit_sales_original.order_date) = 2022
GROUP BY fruit_sales_original.fruit_id,fruits_original.fruit_name
ORDER BY SUM(fruit_sales_original.total_sales_value) DESC

2
SELECT fruit_name FROM fruits_original
JOIN (
    SELECT fruit_id,
           SUM(CASE WHEN YEAR(order_date) = 2021 THEN total_sales_value ELSE 0 END) as sales_2021,
           SUM(CASE WHEN YEAR(order_date) = 2022 THEN total_sales_value ELSE 0 END) as sales_2022
    FROM fruit_sales_original
    WHERE YEAR(order_date) IN (2021, 2022)
    GROUP BY fruit_id
) aggregated_sales ON fruits_original.fruit_id = aggregated_sales.fruit_id
WHERE aggregated_sales.sales_2022 < aggregated_sales.sales_2021;

3
SELECT
AVG(customers_original.age)
FROM purchases_original  JOIN customers_original ON purchases_original.customer_id = customers_original.customer_id
WHERE YEAR (purchases_original.PURCHASE_DATE) = 2020 AND MONTH (purchases_original.PURCHASE_DATE) = 03
;

4
WITH RankedChannels AS (
    SELECT
        YEAR(p.PURCHASE_DATE) AS Year,
        s.CHANNEL,
        SUM(p.UNIT_VALUE_POUNDS * p.UNITS) AS TotalRevenue,
        RANK() OVER (PARTITION BY YEAR(p.PURCHASE_DATE) ORDER BY SUM(p.UNIT_VALUE_POUNDS * p.UNITS) DESC) AS Ranked
    FROM purchases_original p
    INNER JOIN sessions_original s ON p.PURCHASE_ID = s.PURCHASE_ID
    GROUP BY Year, s.CHANNEL
)
SELECT Year, CHANNEL, TotalRevenue
FROM RankedChannels
WHERE Ranked = 2;

5
WITH PageViewsWithLeadLag AS (
    SELECT
        PAGE_VIEW_ID,
        PAGE_URL,
        LAG(PAGE_URL) OVER (PARTITION BY USER_ID ORDER BY PAGE_VIEW_TIMESTAMP) AS PreviousPage
    FROM page_views_original
)
SELECT
    SUM(CASE WHEN PreviousPage LIKE '%/product/%' AND PAGE_URL LIKE '%/cart' THEN 1 ELSE 0 END) AS ProductToCartViews,
    COUNT(*) AS TotalProductViews
FROM PageViewsWithLeadLag
WHERE PreviousPage IS NOT NULL;