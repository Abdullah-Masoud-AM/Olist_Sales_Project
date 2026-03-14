                            -- Business questions --

USE Olist_Sales;                 
                           -- Customers --

-- 1) Number of customers
SELECT COUNT([customer_id]) AS 'Number of customers'
FROM [dbo].[olist_customers_dataset];

-- 2) Number of customers by city
SELECT [customer_city],COUNT([customer_id]) AS 'Number of customers'
FROM [dbo].[olist_customers_dataset]
GROUP BY [customer_city]
ORDER BY COUNT([customer_id]) DESC;

-- 3) Number of customers by state
SELECT [customer_state],COUNT([customer_id]) AS 'Number of customers'
FROM [dbo].[olist_customers_dataset]
GROUP BY [customer_state];

-- 4) Top 10 customers by sales
SELECT TOP(10) C.customer_id ,COUNT(OI.[order_id]) AS[Number of orders]
FROM [dbo].[olist_customers_dataset] C
JOIN [dbo].[olist_orders_dataset] O
ON C.customer_id = O.customer_id 
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.order_id = O.order_id
GROUP BY C.customer_id
ORDER BY [Number of orders] DESC;

-- 5) Top 10 customers who achieved highest revenue
SELECT TOP(10) C.[customer_id] , FORMAT(SUM([price]+[freight_value]),'N0')AS [Total amount]
FROM [dbo].[olist_customers_dataset] C
JOIN [dbo].[olist_orders_dataset] O
ON O.[customer_id] = C.[customer_id]
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.order_id = O.order_id
GROUP BY C.[customer_id]
ORDER BY SUM([price]+[freight_value]) DESC;

----------------------------------------------------------------------------------------
                              -- Geolocation --
-- 1) Total amount of revenue by city
SELECT G.geolocation_city,FORMAT(SUM(OI.[price]+OI.freight_value),'N0') AS [Total amount]
FROM dbo.olist_geolocation_dataset G
JOIN dbo.olist_customers_dataset C
  ON G.geolocation_zip_code_prefix = C.customer_zip_code_prefix
JOIN dbo.olist_orders_dataset O
  ON C.customer_id = O.customer_id
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.order_id = O.order_id
GROUP BY G.geolocation_city
ORDER BY SUM(OI.[price]+ OI.[freight_value]) DESC;

-- 2) Avg amount of revenue by city 
SELECT G.geolocation_city,
       FORMAT(AVG(OI.[price]+OI.[freight_value]),'N0') AS [average]
FROM dbo.olist_geolocation_dataset G
JOIN dbo.olist_customers_dataset C
  ON G.geolocation_zip_code_prefix = C.customer_zip_code_prefix
JOIN dbo.olist_orders_dataset O
  ON C.customer_id = O.customer_id
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.order_id = O.order_id
GROUP BY G.geolocation_city
ORDER BY AVG(OI.[price]+OI.[freight_value]) DESC;

-- 3) Total amount of revenue by state
SELECT G.[geolocation_state],
       FORMAT(SUM(OI.[price]+OI.freight_value),'N0') AS [Total amount]
FROM dbo.olist_geolocation_dataset G
JOIN dbo.olist_customers_dataset C
  ON G.geolocation_zip_code_prefix = C.customer_zip_code_prefix
JOIN dbo.olist_orders_dataset O
  ON C.customer_id = O.customer_id
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.order_id = O.order_id
GROUP BY [geolocation_state]
ORDER BY SUM(OI.[price]+OI.freight_value) DESC;

-- 4) Avg amount of revenue by state
SELECT G.[geolocation_state],
       FORMAT(AVG(OI.[price]+OI.freight_value),'N0') AS [average]
FROM dbo.olist_geolocation_dataset G
JOIN dbo.olist_customers_dataset C
  ON G.geolocation_zip_code_prefix = C.customer_zip_code_prefix
JOIN dbo.olist_orders_dataset O
  ON C.customer_id = O.customer_id
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.order_id = O.order_id
GROUP BY [geolocation_state]
ORDER BY AVG(OI.[price]+OI.freight_value) DESC;

----------------------------------------------------------------------------------------
                              -- Order_items --
--1) Number of Order_items
SELECT FORMAT(COUNT([order_id]),'N0')AS [Number of orders]
FROM [dbo].[olist_order_items_dataset];

--2) Number of Products
SELECT COUNT(DISTINCT [product_id]) AS [Number of Products]
FROM dbo.olist_order_items_dataset;

--3) Top 10 Orders by Total Sales Amount
SELECT TOP(10) [order_id],FORMAT(SUM([price]+freight_value),'N0') AS [Total amount]
FROM [dbo].[olist_order_items_dataset]
GROUP BY [order_id]
ORDER BY SUM([price]+freight_value) DESC;

--4) Total Sales Amount by Product
SELECT  [product_id],FORMAT(SUM([price]+freight_value),'N0') AS [Total amount]
FROM [dbo].[olist_order_items_dataset]
GROUP BY [product_id]
ORDER BY SUM([price]+freight_value) DESC;

--5) Average Total Sales Amount per Product
SELECT  [product_id],FORMAT(AVG([price]+freight_value),'N0') AS [AVG]
FROM [dbo].[olist_order_items_dataset]
GROUP BY [product_id]
ORDER BY AVG([price]+freight_value) DESC;


--6) Total sales amount with out freight value
SELECT FORMAT(SUM([price]),'N0')  AS [Total amount]
FROM [dbo].[olist_order_items_dataset];

--7) Total freight value
SELECT FORMAT(SUM(freight_value),'N0')  AS [Total amount]
FROM [dbo].[olist_order_items_dataset];

----------------------------------------------------------------------------------------
                              -- Order_payments --
--1) Number of payment method
SELECT COUNT(DISTINCT [payment_type]) AS [Number of payment method]
FROM [dbo].[olist_order_payments_dataset];

--2) Most used payment method
SELECT [payment_type], FORMAT(COUNT([payment_type]),'N0') AS [Number of use]
FROM [dbo].[olist_order_payments_dataset]
GROUP BY [payment_type]
ORDER BY COUNT([payment_type]) DESC;

--3) Total sales amount by payment method
SELECT [payment_type], FORMAT(SUM([payment_value]),'N0') AS [Total amount]
FROM [dbo].[olist_order_payments_dataset]
GROUP BY [payment_type]
ORDER BY SUM([payment_value]) DESC;

--4) Total sales amount of all payment method
SELECT  FORMAT(SUM([payment_value]),'N0') AS [Total amount]
FROM [dbo].[olist_order_payments_dataset];

----------------------------------------------------------------------------------------
                              -- Order_reviews --
--1) Number of reviews
SELECT FORMAT(COUNT([review_id]),'N0') AS [Number of review]
FROM [dbo].[olist_order_reviews_dataset];

--2) Number of Reviews by Review Score
SELECT [review_score] , FORMAT(COUNT([review_id]),'N0') AS [Number of review]
FROM [dbo].[olist_order_reviews_dataset]
GROUP BY [review_score]
ORDER BY COUNT([review_id]) DESC;

--3) Number of comments
SELECT FORMAT(COUNT([review_comment_message]),'N0') AS [Number of comments]
FROM [dbo].[olist_order_reviews_dataset]
WHERE [review_comment_message] != 'No comment';

--4) Number of comments by review score
SELECT [review_score] ,FORMAT(COUNT([review_comment_message]),'N0') AS [Number of comments]
FROM [dbo].[olist_order_reviews_dataset]
WHERE [review_comment_message] != 'No comment'
GROUP BY [review_score]
ORDER BY COUNT([review_comment_message]) DESC;

--5) Average Reply Time in Days
SELECT AVG(DATEDIFF(DAY, review_creation_date, review_answer_timestamp)) AS [Avg_Response_Time]
FROM [dbo].[olist_order_reviews_dataset];

----------------------------------------------------------------------------------------
                              -- Order --
--1) Number of orders
SELECT FORMAT(COUNT([order_id]),'N0') AS [Number of orders]
FROM [dbo].[olist_orders_dataset];

--2) Number of orders by order status
SELECT [order_status] , FORMAT(COUNT([order_id]),'N0') AS [Number of orders]
FROM [dbo].[olist_orders_dataset]
GROUP BY [order_status]
ORDER BY COUNT([order_id]) DESC;

--3) Number of Orders that were cancelled and reached the customer
SELECT [order_status] , FORMAT(COUNT([order_id]),'N0') AS [Number of orders]
FROM [dbo].[olist_orders_dataset]
WHERE [order_status] = 'Canceled' AND 
[order_delivered_customer_date] IS NOT NULL
GROUP BY [order_status]
ORDER BY COUNT([order_id]) DESC;

--4) Orders that were cancelled and reached the customer
SELECT *
FROM [dbo].[olist_orders_dataset]
WHERE [order_status] = 'Canceled' AND 
[order_delivered_customer_date] IS NOT NULL;

--5) Orders that were cancelled and shipped
SELECT *
FROM [dbo].[olist_orders_dataset]
WHERE [order_status] = 'Canceled' AND 
[order_delivered_carrier_date] IS NOT NULL;

--6) Number of orders that were cancelled and shipped
SELECT [order_status] , FORMAT(COUNT([order_id]),'N0')AS [Number of orders]
FROM [dbo].[olist_orders_dataset]
WHERE [order_status] = 'Canceled' AND 
[order_delivered_carrier_date] IS NOT NULL
GROUP BY [order_status]
ORDER BY COUNT([order_id]) DESC;

--7) Average order delivery time to customer from shipping time to arrival date
SELECT AVG(DATEDIFF(DAY,[order_delivered_carrier_date],[order_delivered_customer_date])) AS [Number of Days]
FROM [dbo].[olist_orders_dataset];

--8) Number of orders that took time more than 10 days
SELECT FORMAT(COUNT(order_id),'N0') AS [Number of Orders]
FROM dbo.olist_orders_dataset
WHERE order_status = 'delivered'
AND DATEDIFF(DAY, order_delivered_carrier_date, order_delivered_customer_date) > 10;

--8) orders that took time more than 10 days
SELECT 
order_id,
DATEDIFF(DAY, order_delivered_carrier_date, order_delivered_customer_date) AS Days
FROM dbo.olist_orders_dataset
WHERE order_status = 'delivered'
AND DATEDIFF(DAY, order_delivered_carrier_date, order_delivered_customer_date) > 10
ORDER BY Days DESC;

--9) Delivery Performance On-time or late or early orders
SELECT 
order_id,
DATEDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date) AS DelayDays
FROM dbo.olist_orders_dataset
WHERE order_status = 'delivered'
AND DATEDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date) IS NOT NULL
ORDER BY DelayDays DESC;

----------------------------------------------------------------------------------------
                              -- Products --
--1) Number of products
SELECT FORMAT(COUNT([product_id]),'N0')AS [Number of products]
FROM [dbo].[olist_products_dataset];

--2) Number of products by category name
SELECT [product_category_name],FORMAT(COUNT([product_id]),'N0')AS [Number of products]
FROM [dbo].[olist_products_dataset]
GROUP BY [product_category_name]
ORDER BY COUNT([product_id]) DESC;

--3) Total sales amount of Product  
SELECT P.[product_id] , FORMAT(SUM([price] + [freight_value] ),'N0')AS [Total amount]
FROM [dbo].[olist_products_dataset] P
JOIN [dbo].[olist_order_items_dataset] OI
ON P.product_id = OI.product_id
GROUP BY P.[product_id]
ORDER BY SUM([price] + [freight_value] ) DESC;

--4) Total sales amount of Product Category name 
SELECT P.[product_category_name] , FORMAT(SUM([price] + [freight_value] ),'N0')AS [Total amount]
FROM [dbo].[olist_products_dataset] P
JOIN [dbo].[olist_order_items_dataset] OI
ON P.product_id = OI.product_id
GROUP BY P.[product_category_name]
ORDER BY SUM([price] + [freight_value] ) DESC;

----------------------------------------------------------------------------------------
                              -- Sellers --
--1) Number of sellers
SELECT FORMAT(COUNT([seller_id]),'N0') AS [Number of sellers]
FROM [dbo].[olist_sellers_dataset];

--2) Number of sellers by city 
SELECT [seller_city], FORMAT(COUNT([seller_id]),'N0') AS [Number of sellers]
FROM [dbo].[olist_sellers_dataset]
GROUP BY [seller_city]
ORDER BY COUNT([seller_id]) DESC;

--3) Number of sellers by state 
SELECT [seller_state], FORMAT(COUNT([seller_id]),'N0') AS [Number of sellers]
FROM [dbo].[olist_sellers_dataset]
GROUP BY [seller_state]
ORDER BY COUNT([seller_id]) DESC;

--4) Total sales amount by sellers
SELECT S.[seller_id],FORMAT(SUM(OI.price + OI.freight_value),'N0') AS [Total amount]
FROM [dbo].[olist_sellers_dataset] S
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.seller_id = S.seller_id
GROUP BY S.[seller_id]
ORDER BY SUM(OI.price + OI.freight_value) DESC;

--5) Total sales amount by city of sellers
SELECT S.[seller_city],FORMAT(SUM(OI.price + OI.freight_value),'N0') AS [Total amount]
FROM [dbo].[olist_sellers_dataset] S
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.seller_id = S.seller_id
GROUP BY S.[seller_city]
ORDER BY SUM(OI.price + OI.freight_value) DESC;

--6) Total sales amount by state of sellers
SELECT S.[seller_state],FORMAT(SUM(OI.price + OI.freight_value),'N0') AS [Total amount]
FROM [dbo].[olist_sellers_dataset] S
JOIN [dbo].[olist_order_items_dataset] OI
ON OI.seller_id = S.seller_id
GROUP BY S.[seller_state]
ORDER BY SUM(OI.price + OI.freight_value) DESC;
