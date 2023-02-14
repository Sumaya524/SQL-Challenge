/*

Diner Danny's
Case Study #1 Questions

*/

-- 1 What is the total amount each customer spent at the restaurent ?
select SUM(menu.price) as Total_Spent, sales.customer_id 
from sales
JOIN menu ON
sales.product_id=menu.product_id
group by sales.customer_id
ORDER BY Total_Spent desc;

-- Results
-- c_id|total_spent|
-- ----+-----------+
-- A   |         76|
-- B   |         74|
-- C   |         36|


-- 2 How many days has each customer visited the restaurant?

SELECT customer_id,
COUNT(DISTINCT order_date) AS No_of_Days
FROM sales 
GROUP BY customer_id
ORDER BY No_of_Days desc;

-- Results

-- c_id|No_of_Days|
-- ----+------+
-- B   |     6|
-- A   |     4|
-- C   |     2|




-- 3. What was the first item from the menu purchased by each customer?

WITH CTE_FIRST_ORDER AS
(select sales.customer_id ,menu.product_name,
ROW_NUMBER() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date, sales.product_id) AS RN
FROM sales
JOIN menu ON 
sales.product_id=menu.product_id)

select customer_id,product_name
from  CTE_FIRST_ORDER
WHERE RN=1;


-- Results

-- c_id|product_name|
-- ----+------------+
-- A   |sushi       |
-- B   |curry       |
-- C   |ramen       |


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT menu.product_name, COUNT(sales.product_id) AS No_Of_Purchased
FROM sales
JOIN menu ON
sales.product_id=menu.product_id
GROUP BY menu.product_name
ORDER BY No_Of_Purchased desc
LIMIT 1;

-- Results

-- product_name|n_purchased|
-- ------------+-----------+
-- ramen       |          8|


-- 5 Which item was the most popular for each customer?

WITH CTE_MOST_POPULAR AS
(SELECT sales.customer_id,menu.product_name,
        RANK() OVER ( PARTITION BY sales.customer_id ORDER BY COUNT(menu.product_ID) DESC ) AS RNK
        FROM sales
        JOIN menu ON
        sales.product_id=menu.product_id
        GROUP BY sales.customer_id,menu.product_name)
        
        SELECT *
        FROM CTE_MOST_POPULAR
        WHERE RNK=1;
        
 -- -- Results

-- c_id|p_name|rnk|
-- ----+------+---+
-- A   |ramen |  1|
-- B   |sushi |  1|
-- B   |curry |  1|
-- B   |ramen |  1|
-- C   |ramen |  1|       
        
     -- 6. Which item was purchased first by the customer after they became a member?
     
     WITH CTE_FIRST_MEMEBR_PURCHASE AS
     (SELECT members.customer_id, menu.product_name,
     RANK() OVER (PARTITION BY members.customer_id ORDER BY sales.order_date) as RNK
     FROM members
     JOIN SALES ON members.customer_id=sales.customer_id
     JOIN menu ON menu.product_id=sales.product_id
     WHERE sales.order_date>=members.join_date)
     
     SELECT customer_id, product_name
     FROM CTE_FIRST_MEMEBR_PURCHASE
     WHERE RNK=1;
     
  -- Results

-- customer|product|
-- ------+-------+
-- A       |curry  |
-- B       |sushi  |   
        
     
     -- 7. Which item was purchased just before the customer became a member?
     
       WITH CTE_FIRST_MEMEBR_PURCHASE AS
     (SELECT members.customer_id, menu.product_name,
     RANK() OVER (PARTITION BY members.customer_id ORDER BY sales.order_date) as RNK
     FROM members
     JOIN SALES ON members.customer_id=sales.customer_id
     JOIN menu ON menu.product_id=sales.product_id
     WHERE sales.order_date < members.join_date)
     
     SELECT customer_id, product_name
     FROM CTE_FIRST_MEMEBR_PURCHASE
     WHERE RNK=1;
     
   -- Results

-- customer|product|
-- ------+-------+
-- A       |sushi  |
-- A       |curry  |
-- B       |sushi  |     



