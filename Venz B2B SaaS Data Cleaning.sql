-- Creating table duplicates

#                             Creating transactions duplicate table

CREATE TABLE transactions_dupe
LIKE transactions
;

INSERT INTO transactions_dupe
SELECT *
FROM transactions
;

SELECT *
FROM transactions_dupe
;

#                   Detecting Duplicates

WITH transactions_dupe_detect AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY date,customer_id,type,category,amount,plan_tier,region) AS row_num
FROM transactions_dupe
)
SELECT *
FROM transactions_dupe_detect
WHERE row_num > 1
;

#           Creating new table to DELETE duplicate & other issues as well


CREATE TABLE `transactions_dupe_cleaned` (
  `transaction_id` bigint NOT NULL,
  `date` date DEFAULT NULL,
  `customer_id` bigint DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `plan_tier` varchar(20) DEFAULT NULL,
  `region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#inserting all the data in 'transaction_dupe' but with row_num (duplicate detector)

INSERT INTO transactions_dupe_cleaned
SELECT *,
ROW_NUMBER() OVER(PARTITION BY date,customer_id,type,category,amount,plan_tier,region) AS row_num
FROM transactions_dupe
;

-- From now on 'transactions_dupe_cleaned'
SELECT *
FROM transactions_dupe_cleaned
WHERE row_num > 1
;

# removing whitespce 

UPDATE transactions_dupe_cleaned
SET category = TRIM(category)
;

UPDATE transactions_dupe_cleaned
SET region = TRIM(region)
;

SELECT *
FROM transactions_dupe_cleaned 
;

# Converting Inconsistent format to Conistent format

--                                 For Category

UPDATE transactions_dupe_cleaned
SET category = 'Customer Support'
WHERE category LIKE 'Customer%'
;

UPDATE transactions_dupe_cleaned
SET category = 'G&A'
WHERE category LIKE 'g&a%'
;

UPDATE transactions_dupe_cleaned
SET category = 'Hosting & Infrastructure'
WHERE category LIKE 'Hosting & Infrastructure'
;

UPDATE transactions_dupe_cleaned
SET category = 'Marketing'
WHERE category LIKE 'marketing%'
;

UPDATE transactions_dupe_cleaned
SET category = 'One-Time Fee'
WHERE category LIKE 'One-Time Fee%'
;


UPDATE transactions_dupe_cleaned
SET category = 'R&D'
WHERE category LIKE 'r&d%'
;

UPDATE transactions_dupe_cleaned
SET category = 'Salaries & Benefits'
WHERE category LIKE 'Salaries & Benefits%'
;

UPDATE transactions_dupe_cleaned
SET category = 'Sales Commissions'
WHERE category LIKE 'Sales Commissions%'
;


UPDATE transactions_dupe_cleaned
SET category = 'Subscription'
WHERE category LIKE 'Subscription%'
;


UPDATE transactions_dupe_cleaned
SET category = 'Upsell'
WHERE category LIKE 'Upsell%'
;


SELECT *
FROM transactions_dupe_cleaned
;

-- Dropping row_num (realized row_num must drop for precise duplicate deletion)

ALTER TABLE transactions_dupe_cleaned
DROP COLUMN row_num
;

--                     For Region

UPDATE transactions_dupe_cleaned
SET region = 'APAC'
WHERE region LIKE 'apac%'
;

UPDATE transactions_dupe_cleaned
SET region = 'Europe'
WHERE region LIKE 'europe%'
;


UPDATE transactions_dupe_cleaned
SET region = 'Latin America'
WHERE region LIKE 'Latin America%'
;


UPDATE transactions_dupe_cleaned
SET region = 'North America'
WHERE region LIKE 'North America%'
;


SELECT DISTINCT region
FROM transactions_dupe_cleaned
;

#---------------------------------------Recovering BLANKs--------------------------------

-- For plan_tier

UPDATE transactions_dupe_cleaned transdp
JOIN customers cus ON
transdp.customer_id = cus.customer_id
SET transdp.plan_tier = cus.plan_tier
WHERE transdp.plan_tier IS NULL AND
cus.plan_tier IS NOT NULL
;


SELECT *
FROM transactions_dupe_cleaned
WHERE plan_tier IS NULL
;


-- For region

UPDATE transactions_dupe_cleaned transdp
JOIN customers cus ON
transdp.customer_id = cus.customer_id
SET transdp.region = cus.region
WHERE transdp.region IS NULL AND
cus.region IS NOT NULL
;


SELECT *
FROM transactions_dupe_cleaned
WHERE region IS NULL
;


#------------------------------------Detecting Duplicate + Deleting it--------------------------------

WITH transaction_dupe_detect AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY date,customer_id,type,category,amount,plan_tier,region) AS row_num
FROM transactions_dupe_cleaned
)
SELECT COUNT(*)
FROM transaction_dupe_detect
WHERE row_num > 1
;

# 1006 duplicates detected



#deleting dupllicates
DELETE t1 FROM transactions_dupe_cleaned t1
JOIN (
    SELECT transaction_id,
    ROW_NUMBER() OVER (PARTITION BY date, customer_id, type, category, amount, plan_tier, region) AS row_num
    FROM transactions_dupe_cleaned
) t2 ON t1.transaction_id = t2.transaction_id
WHERE t2.row_num > 1;
             
             #deleted 1,006 duplicates


SELECT COUNT(*)
FROM transactions_dupe_cleaned
;
			#71,605 rows left


#---------------------------------EXPORTING-------------------------------

SELECT *
FROM transactions_dupe_cleaned
;


SELECT *
FROM customers
;
