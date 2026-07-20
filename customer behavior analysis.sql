create database if not exists custmores_behavior;
use custmores_behavior;

select * from mytable;

-- total revenue genrated by male and female
 SELECT gender,sum(purchase_amount) as revenue from mytable
 group by gender;
 
 
 -- which customer used discount but also spend more average purchsing_amount?
select customer_id,purchase_amount from mytable
where discount_applied = 'yes' and purchase_amount >= (select Avg(purchase_amount) from mytable);

-- which are top 5 product with highest averge review rating?

select  item_purchased,Avg(review_rating)  as 'averge review rating product' from mytable
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- campare the averge purchase amounts between standard and express shipping
select shipping_type,round(AVG(purchase_amount),2) as 'avg_purchase_amount' from mytable
where shipping_type in ('Express','Standard')
group by shipping_type;

-- DO SUBSCRIBED CUSTOMERS SPEND MORE? campare averge spend and total revenue between subcribers and non-subscribers
select subscription_status,count(customer_id),avg(purchase_amount)as 'avg_purchase_amount' ,sum(purchase_amount) as 'total_purchase_amount' from mytable
group by subscription_status
order by avg_purchase_amount,total_purchase_amount desc ;


-- which 5 product have the highest percentages of purchase with discount applied?

select item_purchased,sum(100*case when discount_applied='yes' then 1 else 0 end)/count(*) as 'discount_rate' from mytable
group by item_purchased
order by discount_rate desc
limit 5;

select item_purchased,sum(case when discount_applied= 'yes' then 1 else 0 end)*100/count(*) as 'discount_rate' from mytable
group by item_purchased
order by discount_rate desc
limit 5;

-- sigment customers into new ,returnig,and loyal based on the totoal number of previous purchase and show the count of each segment.
with customer_type as(
select customer_id, previous_purchases,
		case when previous_purchases= 1 then 'new'
        when  previous_purchases between 2 and 10  then 'returning'
        else 'loyal customer'
        end as customer_sigment
from mytable)

select customer_sigment,count(*) from customer_type
group by customer_sigment;

-- Top 3 Products per Category – Listed the most purchased products within each category. 
with item_count as(
select category,item_purchased,count(customer_id) as 'total_orders',
row_number() over (partition by category order by item_purchased desc) AS 'item_rank'
from mytable
group by category ,item_purchased
)
select item_rank, category,item_purchased,total_orders from item_count
where item_rank <=3;


-- are customers who are buyers (more than 5 previous purchase) also likely to subscribe?
select subscription_status,count(customer_id) as 'repeated_custmore' from mytable
where previous_purchases > 5
group by subscription_status;

-- what is revenue contriution of each age group
select age_group,sum(purchase_amount) as'revenue' from mytable
group by age_group
order by revenue desc;

SELECT USER(), CURRENT_USER();