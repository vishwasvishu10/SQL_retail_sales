show databases;
/*creating database*/
create database retail_sales_db;
use retail_sales_db;
/*creating table*/
create table retail_sales(
	transactions_id	int,
    sale_date	date,
    sale_time	time,
    customer_id	int,
    gender	varchar(15),
    age	int,
    category varchar(15),	
    quantiy	int,
    price_per_unit	float,
    cogs float,
    total_sale float
);
/*Adding primary key*/
alter table retail_sales add primary key(transactions_id);
/* basic checks*/
show tables;
/*imported table data(contents from csv file(SQL-retail sales)*/
select * from retail_sales limit 10;
select count(*) from retail_sales;

/*checking null values*/
select * from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

/*count of sales*/
select count(*) as sales_cnt from retail_sales;

/*count of customers*/
select count(distinct customer_id) as no_of_customers from retail_sales;

/*key business problems */
/*Q1 select all columns for sales made on '2022-11-05'*/
select * from retail_sales
where sale_date='2022-11-05';

/*Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than 3 in the month of Nov-2022:*/
select * from retail_sales 
where category='Clothing'
and quantiy>=4 and date_format(sale_date,'%Y-%m')='2022-05';

/*Q3 Write a SQL query to calculate the total sales for each category.*/
select category,sum(total_sale) as total_sale_per_category from retail_sales
group by category
order by sum(total_sale) desc;

/* Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.*/
select round(avg(age),0) as avg_age from retail_sales
where category='Beauty';

/*Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.*/
select * from retail_sales where total_sale>1000;

/*Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.*/
select gender,category,count(transactions_id) as no_of_transactions from retail_sales
group by gender,category
order by count(transactions_id) desc;

/*Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year*/
with cte as
(select year(sale_date) as sale_year,month(sale_date) as sale_month, round(avg(total_sale),2) as avg_sales,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rnk
from retail_sales
group by year(sale_date),month(sale_date))
select sale_year,sale_month,avg_sales from cte where rnk=1;

/* Q8 Write a SQL query to find the top 5 customers based on the highest total sales*/
select customer_id,sum(total_sale) as total_sales 
from retail_sales 
group by customer_id
order by sum(total_sale) desc limit 5;

/* Q9 Write a SQL query to find the number of unique customers who purchased items from each category.*/
select category, count(distinct customer_id) from retail_sales
group by category;

/* Q10 Write a SQL query to create each shift and number of orders 
(Example Morning <12, Afternoon Between 12 & 17, Evening >17):*/
select shift,count(*) as no_of_orders from
(select * ,
case when(hour(sale_time)<12) then 'Morning'
when(hour(sale_time)>=12 and sale_time<17) then 'Afternoon'
else 'Evening' end as shift
from retail_sales)x
group by x.shift;

