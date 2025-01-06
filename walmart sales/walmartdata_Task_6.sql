USE psrwalmart;
show tables;
select * from  walmartsalesdata;

alter table walmartsalesdata
add column time_of_day varchar(10);

SET SQL_SAFE_UPDATES=0;
UPDATE Walmartsalesdata
SET time_of_day =
CASE
	WHEN TIME(time) BETWEEN '08:00:00' AND '11:59:59' THEN 'Morning'
	WHEN TIME(time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
	WHEN TIME(time) BETWEEN '18:00:00' AND '20:59:59' THEN 'Evening'
	ELSE 'Night'
END;
SET SQL_SAFE_UPDATES=0 ;
-- where id is not null;
    
-- Adding a new column into the table day_name
ALTER TABLE Walmartsalesdata
ADD day_name VARCHAR(20);
UPDATE Walmartsalesdata
SET day_name=DATE_FORMAT(str_to_date(Date,'%m/%d/%Y'),'%a');
-- Adding a new column into the table  month_name
ALTER TABLE Walmartsalesdata
ADD month_name VARCHAR(20);
-- SET SQL_SAFE_UPDATES = 1;
UPDATE Walmartsalesdata
SET month_name=DATE_FORMAT(str_to_date(Date,'%m/%d/%Y'),'%b');


 -- Business Questions To Answer
 -- Generic Question
 select * from walmartsalesdata;
 
 -- 1. How many unique cities does the data have?
 
 select distinct city from walmartsalesdata;
 
 -- 2. In which city is each branch?
 
 select distinct city , branch
 from walmartsalesdata;
 
  -- Product analysis
 ALTER TABLE walmartsalesdata
CHANGE COLUMN `product line` `product_line` VARCHAR(100); 
-- 1. How many unique product lines does the data have?

select count(distinct Product_line) as unique_product_line
from walmartsalesdata;


 --  2. What is the most common payment method?
 select payment,count(payment) as common_payment
 from walmartsalesdata
 group by payment
 order by common_payment desc limit 1 ;
 
 
 -- 3. What is the most selling product line?
 select product_line,count(Product_line) as most_selling_products
 from walmartsalesdata
 group by product_line
 order by most_selling_products desc limit 1;
 
 -- 4. What is the total revenue by month?
 select month_name ,sum(total) as total_revenue
 from walmartsalesData
 group by month_name
 order by total_revenue desc; 
 
 -- 5. What month had the largest COGS?
 select month_name,max(cogs) as large_cogs
 from walmartsalesdata
 group by month_name
 order by large_cogs
 desc limit 1;
 -- 6. What product line had the largest revenue?
 select product_line,max(total) as largest_revenue
 from walmartsalesdata
 group by product_line
 order by largest_revenue desc limit 1;
 -- 7. What is the city with the largest revenue?
 select city, max(total) as largest_revenue
 from walmartsalesdata
 group by city
 order by  largest_revenue desc limit 1;
 -- 8. What product line had the largest VAT?
 alter table walmartsalesdata
 change column `Tax 5%` `VAT` varchar(100);
 
 select product_line,max(VAT) as largest_vat
 from walmartsalesdata
 group by product_line
 order by largest_vat desc;
 -- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
-- select product_line,avg(total) as avg_sales
ALTER TABLE walmartsalesdata
 ADD COLUMN product_category VARCHAR(20);
 select * from walmartsalesdata;
UPDATE walmartsalesdata
SET product_category= 
(CASE 
	WHEN total >= (SELECT AVG(total) from (select total from walmartsalesdata)as salesdata) THEN "Good"
    ELSE "Bad"
END);
 
 select * from walmartsalesdata;
 
 -- 10. Which branch sold more products than average product sold?
select branch , sum(quantity) as qty
from walmartsalesdata
group by branch
having sum(quantity) > 
 (select  avg(quantity) from walmartsalesdata)
 order by qty desc limit 1;
 
 -- 11. What is the most common product line by gender?
 select product_line, gender,count(product_line) as common_product
 from walmartsalesdata
 group by product_line,gender
 order by common_product desc;
 
 -- 12. What is the average rating of each product line?
 select product_line,avg(rating) as rating
 from walmartsalesdata
 group by product_line
 order by rating desc;

 
 --  Sales
--  1. Number of sales made in each time of the day per weekday
select day_name as weekday,time_of_day ,count(total) as sales_count
from walmartsalesdata
group by weekday,time_of_day
order by sales_count desc;
alter table walmartsalesdata
change column `Invoice ID` `invoice_id` varchar(100);


 -- 2. Which of the customer types brings the most revenue?
 alter table walmartsalesdata
 change column `customer type` `customer_type` varchar(30);
 select customer_type ,sum(total) as revenue
 from walmartsalesdata
 group by customer_type
 order by revenue desc limit 1;
 -- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
 select  city,max(vat) as largest_tax
 from walmartsalesdata
 group by city
 order by largest_tax desc limit 1;
 
 
 -- 4. Which customer type pays the most in VAT
 select customer_type,max(vat) as most_vat
 from walmartsalesdata
 group by customer_type
 order by most_vat desc limit 1;
 
 
--  Customer
 -- 1. How many unique customer types does the data have?
 select  count(distinct customer_type) as customer_type
 from walmartsalesdata;
--  2. How many unique payment methods does the data have?
select count(distinct payment) as payment_methods
from walmartsalesdata;
 -- 3. What is the most common customer type?
 select customer_type,count(customer_type) as common_customer
 from walmartsalesdata
 group by customer_type
 order by common_customer desc limit 1;
 -- 4. Which customer type buys the most?
 select customer_type,max(quantity) as buys
 from walmartsalesdata
 group by customer_type
 order by buys desc limit 1;
 
 -- 5. What is the gender of most of the customers?
 select gender,count(gender) as most_of_customers
 from walmartsalesdata
 group  by gender
 order by most_of_customers desc limit 1;
 
 
 -- 6. What is the gender distribution per branch?
 select branch, gender,count(gender) as distribution_branch
 from walmartsalesdata
 group by branch,gender
 order by branch ;
 
 -- 7. Which time of the day do customers give most ratings?
 select time_of_day,count(rating) as give_ratings
 from walmartsalesdata
 group by time_of_day
 order by give_ratings desc limit 1;
 
--  8. Which time of the day do customers give most ratings per branch?
select branch,time_of_day,count(rating) as most_ratings_branch
from walmartsalesdata
group by branch, time_of_day
order by most_ratings_branch desc;

 -- 9. Which day of the week has the best avg ratings?
 select day_name as week ,avg(rating) as best_ratings
 from walmartsalesdata
 group by week
 order by best_ratings desc limit 1;
-- 10. Which day of the week has the best average ratings per branch
select branch,day_name as week, avg(rating) as best_ratings_branch
from walmartsalesdata
group by branch,week
order by best_ratings_branch desc;
