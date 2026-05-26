CREATE TABLE public.blinkit (
    item_fat_content          VARCHAR(50),
    item_identifier           VARCHAR(50),
    item_type                 VARCHAR(100),
    outlet_establishment_year INT,
    outlet_identifier         VARCHAR(50),
    outlet_location_type      VARCHAR(50),
    outlet_size               VARCHAR(50),
    outlet_type               VARCHAR(100),
    item_visibility           NUMERIC,
    item_weight               NUMERIC,
    sales                     NUMERIC,
    rating                    NUMERIC
);
select * from blinkit

select count(*) from blinkit

#updating item_fat_content

update blinkit
set item_fat_content=
case
when item_fat_content in ('low fat','LF') then 'Low Fat'
when item_fat_content='reg' then 'Regular'
else item_fat_content
end

select distinct(item_fat_content) from blinkit



=========================KPI REQUIREMENTS===========================


1)TOTAL SALES:Overall revenue generated from all items sold==========
select sum(sales) as Total_sales from blinkit

select cast(sum(sales)/1000000 as decimal(10,2))as Total_sales_inmillions
from blinkit

a) Total_sales for lowfat items
select cast(sum(sales)/1000000 as decimal(10,2))as Total_sales_inmillions
from blinkit
where item_fat_content='Low Fat'

b)Total_sales based on outlet_establishment_year 
select cast(sum(sales)/1000000 as decimal(10,2))as Total_sales_inmillions
from blinkit
where outlet_establishment_year=2022

================================================

2)AVERAGE SALES:average revenue per sale
select cast(avg(sales) as int)as avg_sales from blinkit


=================================================

3)NUMBER OF ITEMS:total count of different items sold
select count(*) as no_of_items from blinkit 

a)for particular category
select count(*) as no_of_regular_fat from blinkit
where item_fat_content='Regular'

==================================================

4)AVERAGE RATING:The average customer rating for items sold
select round(avg(rating),1) as average_rating from blinkit

a)for particular category
select round(avg(rating),1) as average_rating from blinkit
where item_type='Soft Drinks'

====================================================

=============================GRANULAR REQUIREMENTS==============================

1)metrics by fat content and year:

select item_fat_content,count(*) as no_of_items,round(sum(sales),2) as total_sales,round(avg(sales),2) as average_sales,
round(avg(rating),1) as average_rating
from blinkit 
where outlet_establishment_year=2022
group by item_fat_content
order by total_sales desc

=================================================================================

2)metrics by item_type

select item_type,count(*) as no_of_items,round(sum(sales),2) as total_sales,round(avg(sales),2) as average_sales,
round(avg(rating),1) as average_rating
from blinkit 
group by item_type
order by total_sales desc
limit 5

===================================================================================

3)fat content by outlet for total sales

SELECT
    outlet_location_type,

    COALESCE(
        ROUND(SUM(
            CASE
                WHEN item_fat_content = 'Low Fat'
                THEN sales
            END
        )::numeric,2),
    0) AS low_fat,

    COALESCE(
        ROUND(SUM(
            CASE
                WHEN item_fat_content = 'Regular'
                THEN sales
            END
        )::numeric,2),
    0) AS regular

FROM blinkit
GROUP BY outlet_location_type
ORDER BY outlet_location_type;

===========================================================================

4) Total sales by outlet establishment

select outlet_establishment_year,count(*) as no_of_items,round(sum(sales),2) as total_sales,round(avg(sales),2) as average_sales,
round(avg(rating),1) as average_rating
from blinkit
group by outlet_establishment_year
order by outlet_establishment_year 



==============================================================================

5)Percentage of sales by outlet_size

select outlet_size,
        round(sum(sales)*100/sum(sum(sales)) over(),2) as sales_percentage
from blinkit
group by outlet_size
order by sales_percentage

================================================================================

6)Sales by outlet location

select outlet_location_type,count(*) as no_of_items,round(sum(sales),2) as total_sales,
round(sum(sales)*100/sum(sum(sales)) over(),2) as sales_percentage,
round(avg(sales),2) as average_sales,round(avg(rating),1) as average_rating
from blinkit
group by outlet_location_type
order by total_sales desc

==================================================================================

7)All metrics by outlet type

select outlet_type,count(*) as no_of_items,round(sum(sales),2) as total_sales,
round(sum(sales)*100/sum(sum(sales)) over(),2) as sales_percentage,
round(avg(sales),2) as average_sales,round(avg(rating),1) as average_rating
from blinkit
group by outlet_type
order by total_sales desc


=====================================================================================








