select * from reatil_sales;

select count(*) from retail_sales;
select * from retail_sales;
-----

select * from retail_sales

where transactions_id is null
or 
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--
delete from retail_sales

where transactions_id is null
or 
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--- how many sales we have

select count (*) from retail_sales as total_sales;

--how many customers we have?

select count(distinct customer_id) from retail_sales;

--how many unique category do we have in the table?

select count(distinct category) from retail_sales;


---data analysis and business key problems

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
--Answer 1
select * from retail_sales where sale_date='2022-11-05';

--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

--Answer 2

select * from (select * from retail_sales
where category='Clothing' and to_char(sale_date,'yyyy-mm')='2022-11')where quantiy>=4;

--Write a SQL query to calculate the total sales (total_sale) for each category.
select sum(quantiy) as total_sale, category from retail_sales group by category order by total_sale desc;


--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) from (select age from retail_sales where category='Beauty')as age_table;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select count(transactions_id) as total_number_of_transactions, gender, category from retail_sales group by gender,category order by category;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from (select floor(avg(total_sale)) as avg_sales, extract(year from sale_date)as years, extract(month from sale_date)
as months, rank() over(partition by extract(year from sale_date) order by floor(avg(total_sale)) desc) as rank
from retail_sales group by years,months) as t1 where rank=1;

--Write a SQL query to find the top 5 customers based on the highest total sales
select sum(total_sale) as total_sales_by_customer, customer_id from retail_sales group by customer_id 
order by total_sales_by_customer desc limit 5;

--Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct(customer_id)), category as unique_customers from retail_sales group by category; 

--Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

select count(*)as total_shift_orders, shift from(select *,
case
when extract(hour from sale_time)<12 then 'Morning'
when extract(hour from sale_time)between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales)as t1 group by shift;