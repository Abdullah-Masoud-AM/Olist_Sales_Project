                                     -- Data cleaning --

CREATE DATABASE Olist_Sales;
USE Olist_Sales;

-- Cleaning [dbo].[olist_geolocation_dataset] table

SELECT *
FROM [dbo].[olist_geolocation_dataset];

-- Replace 'são paulo' with 'sao paulo' in geolocation_city column
UPDATE [dbo].[olist_geolocation_dataset]
SET geolocation_city = 'sao paulo'
WHERE geolocation_city = 'são paulo';

-- Check if duplicate exist
SELECT [geolocation_zip_code_prefix] , COUNT([geolocation_zip_code_prefix]) AS 'Duplicates_count' 
FROM [dbo].[olist_geolocation_dataset]
GROUP BY [geolocation_zip_code_prefix]
HAVING COUNT([geolocation_zip_code_prefix]) > 1;

-- Remove dubplicates
WITH Remove_Duplicates AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY geolocation_zip_code_prefix
ORDER BY geolocation_zip_code_prefix
) AS RowNum
FROM dbo.olist_geolocation_dataset
)

DELETE FROM Remove_Duplicates
WHERE RowNum > 1;

-- Assign [geolocation_zip_code_prefix] as a primary key
ALTER TABLE [dbo].[olist_geolocation_dataset]
ADD PRIMARY KEY ([geolocation_zip_code_prefix]);

--------------------------------------------------------------------------
-- Cleaning [dbo].[olist_order_items_dataset] table

SELECT *
FROM [dbo].[olist_order_items_dataset];

-- Assign order_id and order_item_id as a primary key 
ALTER TABLE [dbo].[olist_order_items_dataset]
ADD PRIMARY KEY ([order_id] , [order_item_id])

--------------------------------------------------------------------------
-- Cleaning [dbo].[olist_order_payments_dataset] table

SELECT *
FROM [dbo].[olist_order_payments_dataset]

-- Assign order_id and payment_sequential as a primary key 
ALTER TABLE [dbo].[olist_order_payments_dataset]
ADD PRIMARY KEY ([order_id] , [payment_sequential ])

--------------------------------------------------------------------------
-- Cleaning [dbo].[olist_order_reviews_dataset] table

SELECT *
FROM [dbo].[olist_order_reviews_dataset]

-- Handling missing values in [review_score] and [review_comment_message] columns
UPDATE [dbo].[olist_order_reviews_dataset]
SET [review_comment_title] = 'No comment'
WHERE [review_comment_title] IS NULL

UPDATE [dbo].[olist_order_reviews_dataset]
SET [review_comment_message] = 'No comment'
WHERE [review_comment_message] IS NULL

-- Assing [review_id],[order_id] as a primary key 
ALTER TABLE [dbo].[olist_order_reviews_dataset]
ADD PRIMARY KEY ([review_id],[order_id] )

--------------------------------------------------------------------------

-- Cleaning [dbo].[olist_products_dataset] table

SELECT *
FROM [dbo].[olist_orders_dataset]

-- Assing [review_id],[order_id] as a primary key 
ALTER TABLE [dbo].[olist_orders_dataset]
ADD PRIMARY KEY ([order_id] )
--------------------------------------------------------------------------

-- Cleaning [dbo].[olist_products_dataset] table

SELECT *
FROM [dbo].[olist_products_dataset]
WHERE [product_category_name] IS NULL;

SELECT TOP(1) [product_category_name],COUNT([product_category_name]) AS 'N_Repeated'
FROM [dbo].[olist_products_dataset]
GROUP BY [product_category_name]
ORDER BY [product_category_name] DESC;

-- Replace missing value in [product_category_name] column with most frequent value

UPDATE olist_products_dataset
SET [product_category_name] = 'utilidades_domesticas'
WHERE [product_category_name] IS NULL

-- Assign primary key to [product_id] column 
ALTER TABLE [dbo].[olist_products_dataset]
ADD PRIMARY KEY ([product_id])


--------------------------------------------------------------------------
-- Cleaning [dbo].[olist_sellers_dataset] table

SELECT *
FROM [dbo].[olist_products_dataset]

-- Assign primary key to [seller_id] column 
ALTER TABLE [dbo].[olist_sellers_dataset]
ADD PRIMARY KEY ([seller_id])

--------------------------------------------------------------------------
-- Cleaning [dbo].[product_category_name_translation] table

SELECT *
FROM [dbo].[product_category_name_translation];

--Change columnS name
 EXEC SP_RENAME '[dbo].[product_category_name_translation].column1','product_category_name','COLUMN';
 EXEC SP_RENAME '[dbo].[product_category_name_translation].column2','product_category_name_english','COLUMN'
 DELETE FROM [dbo].[product_category_name_translation]
 WHERE [product_category_name] = 'product_category_name';

-- Assign primary key to [product_category_name_english] column 
ALTER TABLE [dbo].[product_category_name_translation]
ADD PRIMARY KEY ([product_category_name_english])

