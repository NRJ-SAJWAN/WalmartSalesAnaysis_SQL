Create database if not exists SalesDataWalmart;

use SalesDataWalmart;

Create Table sale(invoice_id varchar(30) NOT NULL PRIMARY KEY,branch VARCHAR(5) NOT NULL,city VARCHAR(30) NOT NULL,customer_type VARCHAR(30) NOT NULL,gender VARCHAR(30) NOT NULL,
product_line VARCHAR(100) NOT NULL,unit_price decimal (10,2) not null,qunatity INT NOT NULL,VAT float(6,4) not null,total decimal (12,4) not null,date datetime not null,
time TIME not null,payment_method varchar(15) not null,COGS decimal(10,2) not null,Gross_margin_percentage FLOAT(11,9),Gross_income decimal(12,4) not null,Rating float(2,1));

select * from salesdatawalmart.sale;




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------Feature Engineering---------------------------------------------------------------------------------------------------------------

--Time_of_day
UPDATE salesdatawalmart.sale
SET time_of_day = (
    CASE 
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

select * from salesdatawalmart.sale;

-- day_Name

select
	date,
    dayname(date) as day_name
from salesdatawalmart.sale;

alter table salesdatawalmart.sale add column day_name varchar(10);

update salesdatawalmart.sale
set day_name = dayname(date);

-- month_name

select
	date,
    monthname(date)
from salesdatawalmart.sale;

alter table salesdatawalmart.sale add column month_name varchar(10);

update salesdatawalmart.sale
set month_name = monthname(date);

--------------------------------------------------------------------------------

-How many unique cities does the data have?

select
	distinct city
from salesdatawalmart.sale;

--how may branches?

select
	distinct branch
from salesdatawalmart.sale;

select
	distinct city, branch
from salesdatawalmart.sale;

---------------------------------------------------------------------------------
Product
--------------------------------------------------------------------------------

-- how many unique product lines does the data have?

select
	distinct product_line
from salesdatawalmart.sale;

select
	count(distinct product_line)
from salesdatawalmart.sale;

----------------------------------------------------------------------------------
--What is the most common payment method?

select
	payment_method, count(payment_method) as CNT
from salesdatawalmart.sale
group by payment_method;

----------------------------------------------------------------------------------
What is the most selling product line?

select
	product_line, sum(total)
from salesdatawalmart.sale
group by product_line;

select
	product_line, COUNT(product_line) as count
from salesdatawalmart.sale
group by product_line;

select
	product_line, COUNT(product_line) as count, sum(total)
from salesdatawalmart.sale
group by product_line;

----------------------------------------------------------------------------------
What is the total revenue by month?

select
	month_name as month, sum(total) as total_revenue
from salesdatawalmart.sale
group by month_name
order by sum(total) desc;

----------------------------------------------------------------------------------
What month had the largest COGS?

select
	month_name, sum(COGS)
FROM salesdatawalmart.sale
group by month_name
order by sum(COGS) DESC;

----------------------------------------------------------------------------------
What product line had the largest revenue?

select product_line, sum(total)
from salesdatawalmart.sale
group by product_line
order by product_line desc;

----------------------------------------------------------------------------------
What is the city with the largest revenue?

select s.city, sum(s.total)
from salesdatawalmart.sale as s
group by s.city
order by s.city desc;

----------------------------------------------------------------------------------
What product line had the largest VAT?

select product_line, avg(VAT)
from salesdatawalmart.sale
group by product_line
order by product_line desc;

----------------------------------------------------------------------------------
Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select avg(total) from salesdatawalmart.sale;

322.50

select product_line, avg(total)
from salesdatawalmart.sale
group by product_line;

alter table salesdatawalmart.sale add column sale_remark varchar(30);

alter table salesdatawalmart.sale
rename column sale_remark to sale_category;

UPDATE salesdatawalmart.sale
SET sale_category = (CASE WHEN total > 322.5 THEN 'Good' ELSE 'Bad' END);



----------------------------------------------------------------------------------
Which branch sold more products than average product sold?

select branch, sum(qunatity)
from salesdatawalmart.sale
group by branch
having sum(qunatity) > avg(qunatity);

----------------------------------------------------------------------------------
What is the most common product line by gender?

select gender, product_line, count(gender)
from salesdatawalmart.sale
group by product_line,gender
order by product_line;

----------------------------------------------------------------------------------
What is the average rating of each product line?

select product_line, avg(Rating)
from salesdatawalmart.sale
group by product_line
order by avg(Rating);

----------------------------------------------------------------------------------
Sales
----------------------------------------------------------------------------------
Number of sales made in each time of the day per weekday

select day_name, sum(total)
from salesdatawalmart.sale
group by day_name
order by day_name;

select time_of_day, count(total)
from salesdatawalmart.sale
group by time_of_day
order by count(total) desc;

----------------------------------------------------------------------------------
Which of the customer types brings the most revenue?

select customer_type, sum(total)
from salesdatawalmart.sale
group by customer_type
order by sum(total) desc;

----------------------------------------------------------------------------------
Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, avg(VAT)
from salesdatawalmart.sale
group by city
order by avg(VAT) desc;

----------------------------------------------------------------------------------
Which customer type pays the most in VAT?

select customer_type, sum(VAT)
from salesdatawalmart.sale
group by customer_type
order by sum(VAT) desc;

----------------------------------------------------------------------------------
Customer
----------------------------------------------------------------------------------
How many unique customer types does the data have?

select distinct(customer_type), count(customer_type) as count
from salesdatawalmart.sale
group by customer_type
order by count(customer_type) desc;

----------------------------------------------------------------------------------
How many unique payment methods does the data have?

select payment_method, count(payment_method)
from salesdatawalmart.sale
group by payment_method;

----------------------------------------------------------------------------------
What is the most common customer type?

select customer_type, count(customer_type)
from salesdatawalmart.sale
group by customer_type

----------------------------------------------------------------------------------
Which customer type buys the most?

select customer_type, count(customer_type), sum(total)
from salesdatawalmart.sale
group by customer_type;

----------------------------------------------------------------------------------
What is the gender of most of the customers?

select gender, count(gender)
from salesdatawalmart.sale
group by gender;

----------------------------------------------------------------------------------
What is the gender distribution per branch?


select branch,gender,count(gender)
from salesdatawalmart.sale
where  branch in ("A","B","C")
group by branch, gender
order by branch, gender;

----------------------------------------------------------------------------------
Which time of the day do customers give most ratings?

select * from salesdatawalmart.sale;

select time_of_day, count(rating)
from salesdatawalmart.sale
group by time_of_day;

----------------------------------------------------------------------------------
Which time of the day do customers give most ratings per branch?

select branch, time_of_day, count(rating)
from salesdatawalmart.sale
where branch in ("A","B","C")
group by branch, time_of_day
order by branch, time_of_day;

----------------------------------------------------------------------------------
Which day of the week has the best avg ratings?

select day_name, avg(Rating)
from salesdatawalmart.sale
group by day_name
order by avg(Rating) desc;

----------------------------------------------------------------------------------
Which day of the week has the best average ratings per branch?

select branch,day_name, avg(rating)
from salesdatawalmart.sale
where branch in ("A", "B", "C")
group by branch, day_name
order by branch, day_name;
















