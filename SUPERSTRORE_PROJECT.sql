SELECT * FROM superstore_project.cleaned_superstore_fixed_utf8;
DESCRIBE superstore_project.cleaned_superstore_fixed_utf8;



SELECT 
    Category, `Sub.Category`, Region, Market,
    `Customer.Name`, Segment, `Product.Name`,
    `Ship.Mode`, `Order.Priority`, Year,
    Sales, Profit, Quantity, Discount, `Shipping.Cost`
FROM cleaned_superstore_fixed_utf8;

--- Q1. What is the total revenue, profit and quantity sold?
SELECT 
    ROUND(SUM(Sales), 2)        AS Total_Revenue,
    ROUND(SUM(Profit), 2)       AS Total_Profit,
    SUM(Quantity)               AS Total_Quantity,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM cleaned_superstore_fixed_utf8;

-- Q2. Which category makes the most profit?

SELECT 
    Category,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM cleaned_superstore_fixed_utf8
GROUP BY Category
ORDER BY Total_Profit DESC;

-- Q3. Which are the top 10 most profitable products?
SELECT 
    Product_Name,
    Category,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity)         AS Units_Sold
FROM cleaned_superstore_fixed_utf8
GROUP BY Product_Name, Category
ORDER BY Total_Profit DESC
LIMIT 10;
SELECT 
    `Product.Name`,
    `Product.ID`,
    Category,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity)         AS Units_Sold
FROM cleaned_superstore_fixed_utf8
GROUP BY `Product.Name`, `Product.ID`, Category
ORDER BY Total_Profit DESC
LIMIT 10;

-- Q4. Which products are loss-making? (Top 10 worst)
SELECT 
    'Product.Name',
    Category,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Loss
FROM cleaned_superstore_fixed_utf8
GROUP BY 'Product.Name', Category
ORDER BY Total_Loss ASC
LIMIT 10;



-- Q5. Which region and market performs best?
SELECT 
    Region,
    Market,
    ROUND(SUM(Sales), 2)         AS Total_Sales,
    ROUND(SUM(Profit), 2)        AS Total_Profit,
    COUNT(DISTINCT `Order.ID`)   AS Total_Orders
FROM cleaned_superstore_fixed_utf8
GROUP BY Region, Market
ORDER BY Total_Profit DESC;

-- Q6. How does discount impact profit?
SELECT 
    CASE 
        WHEN Discount = 0    THEN 'No Discount'
        WHEN Discount <= 0.10 THEN 'Low'
        WHEN Discount <= 0.30 THEN 'Medium'
        ELSE 'High'
    END AS Discount_Band,
    COUNT(*)              AS Total_Orders,
    ROUND(SUM(Sales), 2)  AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM cleaned_superstore_fixed_utf8
GROUP BY Discount_Band
ORDER BY Total_Profit DESC;


-- Q7. Top 10 most valuable customers
SELECT 
    `Customer.ID`,
    `Customer.Name`,
    Segment,
    COUNT(DISTINCT `Order.ID`)   AS Total_Orders,
    ROUND(SUM(Sales), 2)         AS Total_Revenue,
    ROUND(SUM(Profit), 2)        AS Total_Profit
FROM cleaned_superstore_fixed_utf8
GROUP BY `Customer.ID`, `Customer.Name`, Segment
ORDER BY Total_Revenue DESC
LIMIT 10;


-- Q8. Yearly sales and profit trend
SELECT 
    Year,
    COUNT(DISTINCT `Order.ID`)   AS Total_Orders,
    ROUND(SUM(Sales), 2)         AS Total_Sales,
    ROUND(SUM(Profit), 2)        AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM cleaned_superstore_fixed_utf8
GROUP BY Year
ORDER BY Year;


-- Q9. Which shipping mode is most profitable?
SELECT 
    `Ship.Mode`,
    COUNT(DISTINCT `Order.ID`)      AS Total_Orders,
    ROUND(SUM(Sales), 2)            AS Total_Sales,
    ROUND(SUM(Profit), 2)           AS Total_Profit,
    ROUND(AVG(`Shipping.Cost`), 2)  AS Avg_Shipping_Cost
FROM cleaned_superstore_fixed_utf8
GROUP BY `Ship.Mode`
ORDER BY Total_Orders DESC;


-- Q10. Which sub-category is loss making?
SELECT 
    Category,
    `Sub.Category`,
    ROUND(SUM(Sales), 2)        AS Total_Sales,
    ROUND(SUM(Profit), 2)       AS Total_Profit,
    ROUND(AVG(Discount)*100, 1) AS Avg_Discount_Pct,
    CASE 
        WHEN SUM(Profit) < 0 THEN 'Loss Making'
        ELSE 'Profitable'
    END AS Status
FROM cleaned_superstore_fixed_utf8
GROUP BY Category, `Sub.Category`
ORDER BY Total_Profit ASC;