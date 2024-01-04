use sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
select count(inventory_id)
from inventory
where film_id = (	select film_id
					from film
					where title = 'HUNCHBACK IMPOSSIBLE'
				)
;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
select *
from film
where length > (select avg(length)
				from film)
order by length desc
;

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
select *
from actor
where actor_id in
(
select actor_id
from film_actor
where film_id = 
(
select film_id
from film
where title = "ALONE TRIP"
)
);

-- Bonus
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films. 
select *
from film
where film_id in
(
select film_id
from film_category
where category_id = 
(select category_id
from category
where category.name = 'family')
)
; 

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins.
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
-- use both joins and subqueries:
select cu.first_name, cu.last_name, cu.email
from customer as cu
left join address as ad on cu.address_id = ad.address_id
where ad.city_id in 
(
select city_id
from city
where country_id = 
(select country_id
from country
where country = 'Canada')
);

-- use only joins:
select *
from customer as cu
left join address as ad on cu.address_id = ad.address_id
left join city as ci on ad.city_id = ci.city_id
left join country as co on ci.country_id = co.country_id
where co.country = 'Canada';

-- 6. Determine which films were starred by the most prolific actor in the Sakila database.
--  A prolific actor is defined as the actor who has acted in the most number of films.
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
select *
from film
where film_id in 
(
select film_id
from film_actor
where actor_id = 
(select actor_id
from film_actor
group by actor_id
order by count(film_id)
desc
limit 1)
)
;

-- 7. Find the films rented by the most profitable customer in the Sakila database.
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
select *
from film
where film_id in
(
select distinct film_id
from inventory
where inventory_id in
(
select inventory_id
from rental
where customer_id =
(select customer_id
from payment
group by customer_id
order by sum(amount)
desc
limit 1)
)
)
;

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
-- You can use subqueries to accomplish this.

select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having sum(amount) >
(
select avg(total_spent)
from (select sum(amount) as total_spent
from payment
group by customer_id
order by sum(amount))
as subquery
)
order by total_amount_spent
desc
;

-- finding average of the total_spent
(
select avg(total_spent)
from (select sum(amount) as total_spent
from payment
group by customer_id
order by sum(amount))
as subquery
)
;

