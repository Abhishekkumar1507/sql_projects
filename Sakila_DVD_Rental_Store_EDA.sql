use sakila;

-- Customer Preferences 

-- 1. Purchasing Patterns of Repeat Customer 

select distinct name from category;

-- As we have 1000 different movies at our store and they are belongs to these 16 categories(e.g. Genre)
/*
Action
Animation
Children
Classics
Comedy
Documentary
Drama
Family
Foreign
Games
Horror
Music
New
Sci-Fi
Sports
Travel
*/

-- % of orders belongs to each category for individual customer

select customer_id,
round(sum(case when c.name='Action' then 1 else 0 end)/count(c.name)*100,2) as 'Action%',
round(sum(case when c.name='Animation' then 1 else 0 end)/count(c.name)*100,2) as 'Animation%',
round(sum(case when c.name='Children' then 1 else 0 end)/count(c.name)*100,2) as 'Children%',
round(sum(case when c.name='Classics' then 1 else 0 end)/count(c.name)*100,2) as 'Classics%',
round(sum(case when c.name='Comedy' then 1 else 0 end)/count(c.name)*100,2) as 'Comedy%',
round(sum(case when c.name='Documentary' then 1 else 0 end)/count(c.name)*100,2) as 'Documentary%',
round(sum(case when c.name='Drama' then 1 else 0 end)/count(c.name)*100,2) as 'Drama%',
round(sum(case when c.name='Family' then 1 else 0 end)/count(c.name)*100,2) as 'Family%',
round(sum(case when c.name='Foreign' then 1 else 0 end)/count(c.name)*100,2) as 'Foreign%',
round(sum(case when c.name='Games' then 1 else 0 end)/count(c.name)*100,2) as 'Games%',
round(sum(case when c.name='Horror' then 1 else 0 end)/count(c.name)*100,2) as 'Horror%',
round(sum(case when c.name='Music' then 1 else 0 end)/count(c.name)*100,2) as 'Music%',
round(sum(case when c.name='New' then 1 else 0 end)/count(c.name)*100,2) as 'New%',
round(sum(case when c.name='Sci-Fi' then 1 else 0 end)/count(c.name)*100,2) as 'Sci-Fi%',
round(sum(case when c.name='Sports' then 1 else 0 end)/count(c.name)*100,2) as 'Sports%',
round(sum(case when c.name='Travel' then 1 else 0 end)/count(c.name)*100,2) as 'Travel%',
round(avg(datediff(r.return_date,r.rental_date)),0) as avg_days_for_next_order,
count(c.name) as total_rentals
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id
group by 1
order by total_rentals desc;


-- Overall Purchasing Patterns
-- % of orders belongs to each category for all customer

select
round(sum(case when c.name='Action' then 1 else 0 end)/count(c.name)*100,2) as 'Action%',
round(sum(case when c.name='Animation' then 1 else 0 end)/count(c.name)*100,2) as 'Animation%',
round(sum(case when c.name='Children' then 1 else 0 end)/count(c.name)*100,2) as 'Children%',
round(sum(case when c.name='Classics' then 1 else 0 end)/count(c.name)*100,2) as 'Classics%',
round(sum(case when c.name='Comedy' then 1 else 0 end)/count(c.name)*100,2) as 'Comedy%',
round(sum(case when c.name='Documentary' then 1 else 0 end)/count(c.name)*100,2) as 'Documentary%',
round(sum(case when c.name='Drama' then 1 else 0 end)/count(c.name)*100,2) as 'Drama%',
round(sum(case when c.name='Family' then 1 else 0 end)/count(c.name)*100,2) as 'Family%',
round(sum(case when c.name='Foreign' then 1 else 0 end)/count(c.name)*100,2) as 'Foreign%',
round(sum(case when c.name='Games' then 1 else 0 end)/count(c.name)*100,2) as 'Games%',
round(sum(case when c.name='Horror' then 1 else 0 end)/count(c.name)*100,2) as 'Horror%',
round(sum(case when c.name='Music' then 1 else 0 end)/count(c.name)*100,2) as 'Music%',
round(sum(case when c.name='New' then 1 else 0 end)/count(c.name)*100,2) as 'New%',
round(sum(case when c.name='Sci-Fi' then 1 else 0 end)/count(c.name)*100,2) as 'Sci-Fi%',
round(sum(case when c.name='Sports' then 1 else 0 end)/count(c.name)*100,2) as 'Sports%',
round(sum(case when c.name='Travel' then 1 else 0 end)/count(c.name)*100,2) as 'Travel%',
count(c.name) as total_purchases
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id;





select distinct special_features from film;

/*
Deleted Scenes,Behind the Scenes
Trailers,Deleted Scenes
Commentaries,Behind the Scenes
Deleted Scenes
Trailers
Commentaries,Deleted Scenes
Trailers,Deleted Scenes,Behind the Scenes
Trailers,Commentaries,Behind the Scenes
Trailers,Commentaries
Trailers,Behind the Scenes
Commentaries,Deleted Scenes,Behind the Scenes
Trailers,Commentaries,Deleted Scenes
Trailers,Commentaries,Deleted Scenes,Behind the Scenes
Behind the Scenes
Commentaries
*/

-- % of orders belongs to each special_feature in a film for individual customer

select customer_id,
round(sum(case when f.special_features='Commentaries' then 1 else 0 end)/count(f.special_features)*100,2) as 'Commentaries%',
round(sum(case when f.special_features='Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Commentaries,Deleted Scenes,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Commentaries,Deleted Scenes,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Commentaries,Deleted Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Commentaries,Deleted Scenes%',
round(sum(case when f.special_features='Commentaries,Deleted Scenes,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Commentaries,Deleted Scenes,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Commentaries' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Commentaries%',
round(sum(case when f.special_features='Trailers,Commentaries,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Commentaries,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Deleted Scenes,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Deleted Scenes,Behind the Scenes%',
round(sum(case when f.special_features='Commentaries,Deleted Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Commentaries,Deleted Scenes%',
round(sum(case when f.special_features='Trailers' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers%',
round(sum(case when f.special_features='Deleted Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Deleted Scenes%',
round(sum(case when f.special_features='Commentaries,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Commentaries,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Deleted Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Deleted Scenes%',
round(sum(case when f.special_features='Deleted Scenes,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Deleted Scenes,Behind the Scenes%',
round(avg(datediff(r.return_date,r.rental_date)),0) as avg_days_for_next_order,
count(distinct r.rental_id) as total_purchases
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id
group by 1
order by 14 desc;



-- Overall Purchasing Patterns
-- % of orders belongs to each type of special feature in films for all customer

select
round(sum(case when f.special_features='Commentaries' then 1 else 0 end)/count(f.special_features)*100,2) as 'Commentaries%',
round(sum(case when f.special_features='Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Commentaries,Deleted Scenes,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Commentaries,Deleted Scenes,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Commentaries,Deleted Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Commentaries,Deleted Scenes%',
round(sum(case when f.special_features='Commentaries,Deleted Scenes,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Commentaries,Deleted Scenes,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Commentaries' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Commentaries%',
round(sum(case when f.special_features='Trailers,Commentaries,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Commentaries,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Deleted Scenes,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Deleted Scenes,Behind the Scenes%',
round(sum(case when f.special_features='Commentaries,Deleted Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Commentaries,Deleted Scenes%',
round(sum(case when f.special_features='Trailers' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers%',
round(sum(case when f.special_features='Deleted Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Deleted Scenes%',
round(sum(case when f.special_features='Commentaries,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Commentaries,Behind the Scenes%',
round(sum(case when f.special_features='Trailers,Deleted Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Trailers,Deleted Scenes%',
round(sum(case when f.special_features='Deleted Scenes,Behind the Scenes' then 1 else 0 end)/count(f.special_features)*100,2) as 'Deleted Scenes,Behind the Scenes%',
count(distinct r.rental_id) as total_purchases
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id;






select distinct rating from film;

/*
PG
G
NC-17
PG-13
R
*/

-- % of orders belongs to each film rating for individual customer

select customer_id,
round(sum(case when f.rating='PG' then 1 else 0 end)/count(f.rating)*100,2) as 'PG%',
round(sum(case when f.rating='G' then 1 else 0 end)/count(f.rating)*100,2) as 'G%',
round(sum(case when f.rating='NC-17' then 1 else 0 end)/count(f.rating)*100,2) as 'NC-17%',
round(sum(case when f.rating='PG-13' then 1 else 0 end)/count(f.rating)*100,2) as 'PG-13%',
round(sum(case when f.rating='R' then 1 else 0 end)/count(f.rating)*100,2) as 'R%',
round(avg(datediff(r.return_date,r.rental_date)),0) as avg_days_for_next_order,
count(distinct r.rental_id) as total_rentals
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id
group by 1
order by total_rentals desc;


-- Overall Purchasing Patterns
-- % of orders belongs to each type of rating of film for all customer

select
round(sum(case when f.rating='PG' then 1 else 0 end)/count(f.rating)*100,2) as 'PG%',
round(sum(case when f.rating='G' then 1 else 0 end)/count(f.rating)*100,2) as 'G%',
round(sum(case when f.rating='NC-17' then 1 else 0 end)/count(f.rating)*100,2) as 'NC-17%',
round(sum(case when f.rating='PG-13' then 1 else 0 end)/count(f.rating)*100,2) as 'PG-13%',
round(sum(case when f.rating='R' then 1 else 0 end)/count(f.rating)*100,2) as 'R%',
count(distinct r.rental_id) as total_purchases
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id;





select distinct rental_rate from film;

/*
$0.99
$2.99
$4.99
*/

-- % of orders belongs to each rental_rate for individual customer

select customer_id,
round(sum(case when f.rental_rate=0.99 then 1 else 0 end)/count(f.rental_rate)*100,2) as '$0.99_rental_rate%',
round(sum(case when f.rental_rate='2.99' then 1 else 0 end)/count(f.rental_rate)*100,2) as '$2.99_rental_rate%',
round(sum(case when f.rental_rate='4.99' then 1 else 0 end)/count(f.rental_rate)*100,2) as '$4.99_rental_rate%',
round(avg(datediff(r.return_date,r.rental_date)),0) as avg_days_for_next_order,
count(distinct r.rental_id) as total_rentals
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id
group by 1
order by total_rentals desc;


-- Overall Purchasing Patterns
-- % of orders belongs to each type of rental_rate for all customer


select
round(sum(case when f.rental_rate=0.99 then 1 else 0 end)/count(f.rental_rate)*100,2) as '$0.99%',
round(sum(case when f.rental_rate='2.99' then 1 else 0 end)/count(f.rental_rate)*100,2) as '$2.99%',
round(sum(case when f.rental_rate='4.99' then 1 else 0 end)/count(f.rental_rate)*100,2) as '$4.99%',
count(distinct r.rental_id) as total_purchases
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id;




select distinct length from film order by 1 desc;

/*
max   -  185 minutes
min   -  46 minutes
*/

-- % of orders belongs to film criteria for individual customer

select customer_id,
round(sum(case when f.length<=60 then 1 else 0 end)/count(f.length)*100,2) as 'short_film',
round(sum(case when f.length>=90 and f.length<=185 then 1 else 0 end)/count(f.length)*100,2) as 'feature_film',
round(sum(case when f.length>40 and f.length<90 then 1 else 0 end)/count(f.length)*100,2) as 'Medium-Length Film',
round(avg(datediff(r.return_date,r.rental_date)),0) as avg_days_for_next_order,
count(distinct r.rental_id) as total_rentals
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id
group by 1
order by total_rentals desc;


-- Overall Purchasing Patterns
-- % of orders belongs to each type of film criteria for all customer

select
round(sum(case when f.length<=60 then 1 else 0 end)/count(f.length)*100,2) as 'short_film',
round(sum(case when f.length>40 and f.length<90 then 1 else 0 end)/count(f.length)*100,2) as 'Medium-Length Film',
round(sum(case when f.length>=90 and f.length<=185 then 1 else 0 end)/count(f.length)*100,2) as 'feature_film',
count(distinct r.rental_id) as total_purchases
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c 
on c.category_id = fc.category_id;



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. which films have the highest rental rates and are most in demands


with cte as(
select f.film_id,count(r.rental_id) as order_frequency
-- round(avg(datediff(r.return_date,r.rental_date)),0) as avg_days_for_next_order
from rental r 
left join inventory i 
on r.inventory_id = i.inventory_id
left join film f 
on f.film_id = i.film_id
group by 1
order by 2 desc)
select title,rental_rate,order_frequency
-- ,avg_days_for_next_order
from cte
left join film
on cte.film_id = film.film_id
where rental_rate in (select max(rental_rate) from film)
order by 3 desc
limit 10;



-- Overall Top 10 Popular films

select 
-- f.film_id,
f.title,
count(re.rental_id) rental_frequency
from rental re
left join inventory i 
on i.inventory_id = re.inventory_id
left join film f 
on i.film_id = f.film_id 
left join film_category fc 
on f.film_id=fc.film_id
left join category c
on fc.category_id = c.category_id
group by 1
order by 2 desc
limit 10;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 3. Are there correlations between staff performance and customer satisfaction



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4. Are there seasonal trends in customer behaviour across different locations


-- Weekly order trends in different film categories across different locations

with cte as (
select 
ctry.country,
re.rental_date,
c.name
from country ctry
left join city ct
on ctry.country_id = ct.country_id 
left join address a
on ct.city_id = a.city_id
left join customer cus
on a.address_id = cus.address_id
left join rental re
on cus.address_id = re.customer_id
left join inventory i 
on re.inventory_id = i.inventory_id
left join film f 
on i.film_id = f.film_id 
left join film_category fc 
on f.film_id=fc.film_id
left join category c
on fc.category_id = c.category_id)
select 
country,
min(date(rental_date)) as week_start_date,
round(sum(case when c.name='Action' then 1 else 0 end)/count(c.name)*100,2) as 'Action%',
round(sum(case when c.name='Animation' then 1 else 0 end)/count(c.name)*100,2) as 'Animation%',
round(sum(case when c.name='Children' then 1 else 0 end)/count(c.name)*100,2) as 'Children%',
round(sum(case when c.name='Classics' then 1 else 0 end)/count(c.name)*100,2) as 'Classics%',
round(sum(case when c.name='Comedy' then 1 else 0 end)/count(c.name)*100,2) as 'Comedy%',
round(sum(case when c.name='Documentary' then 1 else 0 end)/count(c.name)*100,2) as 'Documentary%',
round(sum(case when c.name='Drama' then 1 else 0 end)/count(c.name)*100,2) as 'Drama%',
round(sum(case when c.name='Family' then 1 else 0 end)/count(c.name)*100,2) as 'Family%',
round(sum(case when c.name='Foreign' then 1 else 0 end)/count(c.name)*100,2) as 'Foreign%',
round(sum(case when c.name='Games' then 1 else 0 end)/count(c.name)*100,2) as 'Games%',
round(sum(case when c.name='Horror' then 1 else 0 end)/count(c.name)*100,2) as 'Horror%',
round(sum(case when c.name='Music' then 1 else 0 end)/count(c.name)*100,2) as 'Music%',
round(sum(case when c.name='New' then 1 else 0 end)/count(c.name)*100,2) as 'New%',
round(sum(case when c.name='Sci-Fi' then 1 else 0 end)/count(c.name)*100,2) as 'Sci-Fi%',
round(sum(case when c.name='Sports' then 1 else 0 end)/count(c.name)*100,2) as 'Sports%',
round(sum(case when c.name='Travel' then 1 else 0 end)/count(c.name)*100,2) as 'Travel%',
count(c.name) as total_rentals
from cte c
group by 1,yearweek(rental_date)
order by 1,2;





-- Weekly order trends in different film ratings across different locations

with cte as (
select 
ctry.country,
re.rental_date,
f.rating
from country ctry
left join city ct
on ctry.country_id = ct.country_id 
left join address a
on ct.city_id = a.city_id
left join customer cus
on a.address_id = cus.address_id
left join rental re
on cus.address_id = re.customer_id
left join inventory i 
on re.inventory_id = i.inventory_id
left join film f 
on i.film_id = f.film_id 
left join film_category fc 
on f.film_id=fc.film_id
left join category c
on fc.category_id = c.category_id)
select 
country,
min(date(rental_date)) as week_start_date,
round(sum(case when f.rating='PG' then 1 else 0 end)/count(f.rating)*100,2) as 'PG%',
round(sum(case when f.rating='G' then 1 else 0 end)/count(f.rating)*100,2) as 'G%',
round(sum(case when f.rating='NC-17' then 1 else 0 end)/count(f.rating)*100,2) as 'NC-17%',
round(sum(case when f.rating='PG-13' then 1 else 0 end)/count(f.rating)*100,2) as 'PG-13%',
round(sum(case when f.rating='R' then 1 else 0 end)/count(f.rating)*100,2) as 'R%',
count(f.rating) as total_rentals
from cte f
group by 1,yearweek(rental_date)
order by 1,2;



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5. Are Certain Language films more popular in among specific customer segments
/*
As we have only english language films so we are not able to distinguish popularity of films among specific customer segments
*/

select distinct * from language;
select distinct language_id from film;  -- All films belongs to English language


-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 6. How does customer loyalty impact sales revenur over time?


-- Monthly Revenue

select 
extract(year_month from re.rental_date) as month,
round(sum(pay.amount),0) as 'revenue($)'
from rental re
left join payment pay
on re.rental_id = pay.rental_id
group by 1
order by 1;

-- Monthly No. of Unique Customers
select 
extract(year_month from re.rental_date) as month,
count(distinct re.customer_id) as unique_customers
from rental re
left join payment pay
on re.rental_id = pay.rental_id
group by 1
order by 1;

with cte as (
select 
extract(year_month from re.rental_date) as yr_mnth,
re.customer_id,
count(distinct re.rental_id) as orders,
sum(pay.amount) as revenue
from rental re
left join payment pay
on re.rental_id = pay.rental_id
-- where year(re.rental_date) <> 2006
group by 1,2
order by 1,2)
select yr_mnth,
sum(case when orders>=1 then 1 else 0 end) as total_customers,
sum(case when orders>1 then 1 else 0 end) as repeat_customers,
sum(case when orders>=1 then revenue else 0 end) as total_revenue,
sum(case when orders>1 then revenue else 0 end) as revenue_from_repeat_customers,
round(sum(case when orders>1 then revenue else 0 end)/sum(case when orders>=1 then revenue else 0 end)*100,2) as '%revenue_from_repeat_customers'
from cte
group by 1;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7. Are certain film categories more popular in specific locations

select country,
round(sum(case when c.name='Action' then 1 else 0 end)/count(c.name)*100,2) as 'Action%',
round(sum(case when c.name='Animation' then 1 else 0 end)/count(c.name)*100,2) as 'Animation%',
round(sum(case when c.name='Children' then 1 else 0 end)/count(c.name)*100,2) as 'Children%',
round(sum(case when c.name='Classics' then 1 else 0 end)/count(c.name)*100,2) as 'Classics%',
round(sum(case when c.name='Comedy' then 1 else 0 end)/count(c.name)*100,2) as 'Comedy%',
round(sum(case when c.name='Documentary' then 1 else 0 end)/count(c.name)*100,2) as 'Documentary%',
round(sum(case when c.name='Drama' then 1 else 0 end)/count(c.name)*100,2) as 'Drama%',
round(sum(case when c.name='Family' then 1 else 0 end)/count(c.name)*100,2) as 'Family%',
round(sum(case when c.name='Foreign' then 1 else 0 end)/count(c.name)*100,2) as 'Foreign%',
round(sum(case when c.name='Games' then 1 else 0 end)/count(c.name)*100,2) as 'Games%',
round(sum(case when c.name='Horror' then 1 else 0 end)/count(c.name)*100,2) as 'Horror%',
round(sum(case when c.name='Music' then 1 else 0 end)/count(c.name)*100,2) as 'Music%',
round(sum(case when c.name='New' then 1 else 0 end)/count(c.name)*100,2) as 'New%',
round(sum(case when c.name='Sci-Fi' then 1 else 0 end)/count(c.name)*100,2) as 'Sci-Fi%',
round(sum(case when c.name='Sports' then 1 else 0 end)/count(c.name)*100,2) as 'Sports%',
round(sum(case when c.name='Travel' then 1 else 0 end)/count(c.name)*100,2) as 'Travel%',
count(c.name) as total_rentals
from country ctry
left join city ct
on ctry.country_id = ct.country_id 
left join address a
on ct.city_id = a.city_id
left join customer cus
on a.address_id = cus.address_id
left join rental re
on cus.address_id = re.customer_id
left join inventory i 
on re.inventory_id = i.inventory_id
left join film f 
on i.film_id = f.film_id 
left join film_category fc 
on f.film_id=fc.film_id
left join category c
on fc.category_id = c.category_id
group by 1
order by total_rentals desc;



select ct.city,
round(sum(case when c.name='Action' then 1 else 0 end)/count(c.name)*100,2) as 'Action%',
round(sum(case when c.name='Animation' then 1 else 0 end)/count(c.name)*100,2) as 'Animation%',
round(sum(case when c.name='Children' then 1 else 0 end)/count(c.name)*100,2) as 'Children%',
round(sum(case when c.name='Classics' then 1 else 0 end)/count(c.name)*100,2) as 'Classics%',
round(sum(case when c.name='Comedy' then 1 else 0 end)/count(c.name)*100,2) as 'Comedy%',
round(sum(case when c.name='Documentary' then 1 else 0 end)/count(c.name)*100,2) as 'Documentary%',
round(sum(case when c.name='Drama' then 1 else 0 end)/count(c.name)*100,2) as 'Drama%',
round(sum(case when c.name='Family' then 1 else 0 end)/count(c.name)*100,2) as 'Family%',
round(sum(case when c.name='Foreign' then 1 else 0 end)/count(c.name)*100,2) as 'Foreign%',
round(sum(case when c.name='Games' then 1 else 0 end)/count(c.name)*100,2) as 'Games%',
round(sum(case when c.name='Horror' then 1 else 0 end)/count(c.name)*100,2) as 'Horror%',
round(sum(case when c.name='Music' then 1 else 0 end)/count(c.name)*100,2) as 'Music%',
round(sum(case when c.name='New' then 1 else 0 end)/count(c.name)*100,2) as 'New%',
round(sum(case when c.name='Sci-Fi' then 1 else 0 end)/count(c.name)*100,2) as 'Sci-Fi%',
round(sum(case when c.name='Sports' then 1 else 0 end)/count(c.name)*100,2) as 'Sports%',
round(sum(case when c.name='Travel' then 1 else 0 end)/count(c.name)*100,2) as 'Travel%',
count(c.name) as total_rentals
from country ctry
left join city ct
on ctry.country_id = ct.country_id 
left join address a
on ct.city_id = a.city_id
left join customer cus
on a.address_id = cus.address_id
left join rental re
on cus.address_id = re.customer_id
left join inventory i 
on re.inventory_id = i.inventory_id
left join film f 
on i.film_id = f.film_id 
left join film_category fc 
on f.film_id=fc.film_id
left join category c
on fc.category_id = c.category_id
group by 1
order by total_rentals desc;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 8. How does the availability and knowledge of staff affect customer ratings?
/*
As we have no information related to availability and knowledge of staff and also there is no customer ratings so for answering this question we have to wait for the relevant data.

*/

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 9. How does the proximity of stores to customers impact rental frequency?

select s.store_id,a.address,ct.city,cty.country 
from store s
left join address a 
on s.address_id = a.address_id
left join city ct
on a.city_id = ct.city_id
left join country cty
on ct.country_id = cty.country_id;

with cte as(
select
re.rental_id,
case when cty.country in ('Canada','Australia') then "Yes" else "No" end as Proximity_to_Store
from address a
left join city ct
on ct.city_id = a.city_id
left join country cty
on ct.country_id = cty.country_id
left join customer cus
on a.address_id = cus.address_id
left join rental re
on cus.customer_id = re.customer_id
)
select 
Proximity_to_Store,
count(rental_id) as order_frequency
from cte
group by 1;



with cte as(
select
re.rental_id,
case when ct.city in ('Lethbridge','Woodridge') then "Yes" else "No" end as Proximity_to_Store
from address a
left join city ct
on ct.city_id = a.city_id
left join customer cus
on a.address_id = cus.address_id
left join rental re
on cus.customer_id = re.customer_id
)
select 
Proximity_to_Store,
count(rental_id) as order_frequency
from cte
group by 1;


--   -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 10. Do specific film categories attract different age groups of customers
/*
As we have no data about the the age of different customers so right now can't able to answer for this particular question

*/


-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 11. what are the demographics and preferences  of the highest spending customers

with cte as (
select
customer_id,
count(distinct rental_id) as orders,
sum(amount) as revenue,
avg(amount) as avg_order_value
from payment
group by 1
order by 3 desc
limit 10),
cte2 as (
select cus.customer_id,
ctry.country,
ct.city,
c.name
from country ctry
left join city ct
on ctry.country_id = ct.country_id 
left join address a
on ct.city_id = a.city_id
left join customer cus
on a.address_id = cus.address_id
left join rental re
on cus.address_id = re.customer_id
left join inventory i 
on re.inventory_id = i.inventory_id
left join film f 
on i.film_id = f.film_id 
left join film_category fc 
on f.film_id=fc.film_id
left join category c
on fc.category_id = c.category_id)
select 
cte.customer_id,
c.country,
c.city,
round(sum(case when c.name='Action' then 1 else 0 end)/count(c.name)*100,2) as 'Action%',
round(sum(case when c.name='Animation' then 1 else 0 end)/count(c.name)*100,2) as 'Animation%',
round(sum(case when c.name='Children' then 1 else 0 end)/count(c.name)*100,2) as 'Children%',
round(sum(case when c.name='Classics' then 1 else 0 end)/count(c.name)*100,2) as 'Classics%',
round(sum(case when c.name='Comedy' then 1 else 0 end)/count(c.name)*100,2) as 'Comedy%',
round(sum(case when c.name='Documentary' then 1 else 0 end)/count(c.name)*100,2) as 'Documentary%',
round(sum(case when c.name='Drama' then 1 else 0 end)/count(c.name)*100,2) as 'Drama%',
round(sum(case when c.name='Family' then 1 else 0 end)/count(c.name)*100,2) as 'Family%',
round(sum(case when c.name='Foreign' then 1 else 0 end)/count(c.name)*100,2) as 'Foreign%',
round(sum(case when c.name='Games' then 1 else 0 end)/count(c.name)*100,2) as 'Games%',
round(sum(case when c.name='Horror' then 1 else 0 end)/count(c.name)*100,2) as 'Horror%',
round(sum(case when c.name='Music' then 1 else 0 end)/count(c.name)*100,2) as 'Music%',
round(sum(case when c.name='New' then 1 else 0 end)/count(c.name)*100,2) as 'New%',
round(sum(case when c.name='Sci-Fi' then 1 else 0 end)/count(c.name)*100,2) as 'Sci-Fi%',
round(sum(case when c.name='Sports' then 1 else 0 end)/count(c.name)*100,2) as 'Sports%',
round(sum(case when c.name='Travel' then 1 else 0 end)/count(c.name)*100,2) as 'Travel%',
count(c.name) as total_rentals
from cte
left join cte2 c
on cte.customer_id = c.customer_id
group by 1,2,3
order by total_rentals desc;


-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 12. How does the avaialability of inventory impact customer satisfaction and repeat business

select distinct last_update from inventory;

-- Number of copies in inventory for each film
select 
film_id,
count(inventory_id) no_of_copies
from inventory
group by 1
order by 1;

with cte as (
select 
film_id,
count(inventory_id) no_of_copies
from inventory
group by 1),
cte2 as(
select 
i.film_id,
yearweek(re.rental_date) as yr_week,
count(re.rental_id) weekly_rentals,
sum(pay.amount) as weekly_revenue
from rental re
left join inventory i 
on re.inventory_id = i.inventory_id
left join payment pay
on re.rental_id = pay.rental_id
group by 1,2),cte3 as(
select 
film_id,
ceil(avg(weekly_rentals)) as avg_weekly_rentals,
round(avg(weekly_revenue),2) as avg_weekly_revenue
from cte2
group by 1)
select cte.*,cte3.avg_weekly_rentals,avg_weekly_revenue,
case when cte.no_of_copies-cte3.avg_weekly_rentals<=1 then 'tends_to_shortage' 
	when cte.no_of_copies-cte3.avg_weekly_rentals>1 and cte.no_of_copies-cte3.avg_weekly_rentals<=3 then 'Sufficient'
    else 'Surplus'
end as 'inventory_health'
from cte
left join cte3
on cte.film_id = cte3.film_id
order by 5;



-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 13. what are the busiest hours or days for each store location

-- Daywise footfall
 
select 
dayname(re.rental_date),
count(case when i.store_id = 1 then re.rental_id else null end) as footfall_at_store_1,
count(case when i.store_id = 2 then re.rental_id else null end) as footfall_at_store_2
from rental re
left join inventory i 
on re.inventory_id = i.inventory_id
group by 1
order by weekday(re.rental_date);

-- Hourwise footfall

select 
hour(re.rental_date),
count(case when i.store_id = 1 then re.rental_id else null end) as footfall_at_store_1,
count(case when i.store_id = 2 then re.rental_id else null end) as footfall_at_store_2
from rental re
left join inventory i 
on re.inventory_id = i.inventory_id
group by 1
order by 1;




select 
dayname(re.rental_date),
count(case when hour(re.rental_date) = 0 then re.rental_id else null end) as '0',
count(case when hour(re.rental_date) = 1 then re.rental_id else null end) as '1',
count(case when hour(re.rental_date) = 2 then re.rental_id else null end) as '2',
count(case when hour(re.rental_date) = 3 then re.rental_id else null end) as '3',
count(case when hour(re.rental_date) = 4 then re.rental_id else null end) as '4',
count(case when hour(re.rental_date) = 5 then re.rental_id else null end) as '5',
count(case when hour(re.rental_date) = 6 then re.rental_id else null end) as '6',
count(case when hour(re.rental_date) = 7 then re.rental_id else null end) as '7',
count(case when hour(re.rental_date) = 8 then re.rental_id else null end) as '8',
count(case when hour(re.rental_date) = 9 then re.rental_id else null end) as '9',
count(case when hour(re.rental_date) = 10 then re.rental_id else null end) as '10',
count(case when hour(re.rental_date) = 11 then re.rental_id else null end) as '11',
count(case when hour(re.rental_date) = 12 then re.rental_id else null end) as '12',
count(case when hour(re.rental_date) = 13 then re.rental_id else null end) as '13',
count(case when hour(re.rental_date) = 14 then re.rental_id else null end) as '14',
count(case when hour(re.rental_date) = 15 then re.rental_id else null end) as '15',
count(case when hour(re.rental_date) = 16 then re.rental_id else null end) as '16',
count(case when hour(re.rental_date) = 17 then re.rental_id else null end) as '17',
count(case when hour(re.rental_date) = 18 then re.rental_id else null end) as '18',
count(case when hour(re.rental_date) = 19 then re.rental_id else null end) as '19',
count(case when hour(re.rental_date) = 20 then re.rental_id else null end) as '20',
count(case when hour(re.rental_date) = 21 then re.rental_id else null end) as '21',
count(case when hour(re.rental_date) = 22 then re.rental_id else null end) as '22',
count(case when hour(re.rental_date) = 23 then re.rental_id else null end) as '23'
from rental re
left join inventory i 
on re.inventory_id = i.inventory_id
group by 1
order by weekday(re.rental_date);









-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 14. what are cultural or demographic factors that influence customer preference in different location
/*
Currently we have no information related to customers' cultures and demographic factors 
*/


-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 15. How does thre availability of films in different languages impact customer satisfaction and rental frequency?

/*
As we have only english language films so we are not able to measure impact of languages on customer satisfaction and rental frequency
*/


-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------















-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Customer Profiles

-- penalty for each extra day = $1


select 
re.customer_id,
sum(f.rental_rate) as total_sales,
sum(pay.amount-f.rental_rate) as total_penalty,
sum(pay.amount) as total_revenue
from rental re
left join payment pay
on re.rental_id = pay.rental_id
left join inventory i 
on re.inventory_id = i.inventory_id
left join film f 
on i.film_id=f.film_id
where re.customer_id is not null
group by 1
order by 1;




-- Staff Performance

-- 1. Total Orders Generated, Processed and revenue collection from each staff

with cte as (
select re.staff_id,count(re.rental_id) total_orders_generated
from rental re
group by 1
order by 1),
cte2 as (
select pay.staff_id,count(payment_id) total_orders_processed
from payment pay
group by 1
order by 1),
cte3 as(
select pay.staff_id,sum(amount) total_revenue
from payment pay
group by 1
order by 1)
select cte.staff_id,total_orders_generated,total_orders_processed,total_revenue
from cte
left join cte2
on cte.staff_id = cte2.staff_id
left join cte3
on cte.staff_id = cte3.staff_id;


-- 2. Contribution to orders based upon different rental_rate by each staff

select 
staff_id,
rental_rate,
total_rentals,
round(total_rentals/sum(total_rentals) over(partition by staff_id)*100,2) as '%of_orders'
from (
	select 
	re.staff_id,
	f.rental_rate,
	count(re.rental_id) as total_rentals
	from rental re
	left join inventory i 
	on re.inventory_id = i.inventory_id
	left join film f 
	on i.film_id=f.film_id
	group by 1,2
    ) sub
order by staff_id;

















