-- Sql Retail Sales Analysis -P1
create database sql_project;

--Create Table
CREATE TABLE retail_sales
(transactions_id int primary key,sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age	int,
category varchar(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

select * from retail_sales
limit 10;

select * from retail_sales;
select count(*) from retail_sales;

--DATA CLEANING
select * from retail_sales
where 
transactions_id is null 
or sale_date is null 
or sale_time is null
or gender is null  or 
category is null or quantity is null
or cogs is null or 
total_sale is null;

--
DELETE FROM retail_sales
where 
transactions_id is null 
or sale_date is null 
or sale_time is null
or gender is null  or 
category is null or quantity is null
or cogs is null or 
total_sale is null;

--Data Exploration

--How many sales we have

select count(*) from retail_sales;

--How many customers we have?
select count(customer_id) as total_salae from retail_sales;
--How manu unique customers we have?
select distinct 
count(customer_id) as total_sales
from retail_sales;
--Unique category
select distinct 
category 
from retail_sales;

--Data Analysis & Business Key Problems & Answers
-- Q1. Write A SQL query to retrieve all columns for sales made on '2022-11-05'
select *
from retail_sales
where sale_date='2022-11-05';

--Q2. Write a SQL QUERY to retrieve all transactions where the category
-- is 'Clothing and the quantity sold is more than 4 in the month of Nov-2022'

select *
from retail_sales
where
category='Clothing' and to_CHAR(sale_date,'YYYY-MM')=
'2022-11' AND quantity>=4 ;

-- Q3. Write a SQL query to calculate the total sales
-- (total_sale) for each category.
select category, sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by category
order by net_sale desc;


-- Q4. Write a SQL query to find the average age of
-- customers who purchased items from the 'Beauty' category.
select round(avg(age)) as avg_age_customers
from retail_sales
where category='Beauty'
group by category;

--Q5. Write a SQL query to find all transactions where
-- the total_sale is greater than 1000.

select * 
from retail_sales
where total_sale>1000;

--Q6. Write a SQL query to find the total no of 
-- transactions(transaction_id) made by each gender in each category.

select category,gender,count(transactions_id) 
from retail_sales
group by gender,category
order by category;

--Q7. Write a SQL query to calcualte the avg sale for
--each month.Find out best selling month in each year.
select year,month,avg_sale  from
(select Extract(Year from sale_date) as YEAR,
Extract(MONTH from sale_date) as MONTH,
avg(total_sale) as avg_sale,
rank() over(partition by Extract(Year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2) as t1
where rank=1;

--Q8.Write a SQL query to find the top 5 customers based on
-- on the highest total sales

select
customer_id, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

--Q9. Write a SQL query to find the no.of unique customers
-- who purchased items from each category.

select  category,count(distinct customer_id) 
from retail_sales
group by category;

--Q10. Write a SQL query to create each shift and no.of orders
--EXAMPLE: morning<=12 , after noon between 12&17 ,evening >17)

with hourly_sale
as
(
select *,
case 
when extract(HOUR from sale_time)<12 then 'Morning'
when extract(HOUR from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales)
select shift, count(*) as total_orders
from hourly_sale
group by shift;

-- END of Project__