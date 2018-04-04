-- Grace Zheng Homework for MYSQL 

-- 1a: Display the first and last names of all actors from the table `actor`
select distinct a.first_name, a.last_name
from sakila.actor a
;

-- 1b
/* Display the first and last name of each actor in a single column in upper case letters. 
Name the column `Actor Name`. */
select CONCAT(UPPER(a.first_name),' ',UPPER(a.last_name)) as 'Actor Name'
from sakila.actor a
;

-- 2a
/*You need to find the ID number, first name, and last name of an actor, of whom you know only the 
first name, "Joe." */
select a.actor_id,a.first_name, a.last_name
from sakila.actor a 
where UPPER(a.first_name) like UPPER('Joe')
;

-- 2b
/*Find all actors whose last name contain the letters `GEN`*/
select a.*
from sakila.actor a 
where UPPER(a.last_name) like UPPER('%GEN%')
;

-- 2c
/*Find all actors whose last names contain the letters `LI`. 
This time, order the rows by last name and first name, in that order*/
select a.*
from sakila.actor a 
where UPPER(a.last_name) like UPPER('%LI%')
order by a.last_name, a.first_name
;

-- 2d
/*Using `IN`, display the `country_id` and `country` columns of the following countries: 
Afghanistan, Bangladesh, and China*/
select c.country_id, c.country
from sakila.country c
where c.country IN ('Afghanistan', 'Bangladesh', 'China')
;

-- 3a 
/*Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. 
Hint: you will need to specify the data type.*/
select * from actor;

ALTER TABLE actor
ADD COLUMN `middle_name` VARCHAR(45) AFTER `first_name`;

-- 3b
/*You realize that some of these actors have tremendously long last names. 
Change the data type of the `middle_name` column to `blobs`.*/
ALTER TABLE actor MODIFY COLUMN `middle_name` blob;

-- 3c
/*Now delete the `middle_name` column*/
ALTER TABLE actor DROP COLUMN `middle_name`;

-- 4a
/*List the last names of actors, as well as how many actors have that last name.*/
select a.last_name, count(1) 
from actor a
group by a.last_name;

-- 4b
/*List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors*/
select a.last_name, count(1) 
from actor a
group by a.last_name
having count(1) >= 2;

-- 4c
/*Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`,
 the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.*/
SET SQL_SAFE_UPDATES =0;
UPDATE actor
SET first_name = 'HARPO'
where upper(first_name) like 'GROUCHO' and UPPER(last_name) like 'WILLIAMS';

-- 4d
/*Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the 
correct name after all! In a single query, if the first name of the actor is currently `HARPO`, 
change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what 
the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO
 `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)*/
select * -- actor_id 172
from actor 
where first_name = 'HARPO' and UPPER(last_name) like 'WILLIAMS';

UPDATE actor
SET first_name = 
	CASE WHEN first_name= 'HARPO' THEN 'GROUCHO'  ELSE 'MUCHO GROUCHO' END 
where actor_id=172;

select * -- actor_id 172
from actor 
where actor_id=172;

-- 5a
/* You cannot locate the schema of the `address` table. Which query would you use to re-create it? */
SHOW CREATE TABLE address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6a 
/*Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
Use the tables `staff` and `address`:*/
select a.first_name, a.last_name, ad.*
from staff a 
left outer join address ad
on a.address_id = ad.address_id;

-- 6b
/*Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
Use tables `staff` and `payment`.*/
select a.staff_id, sum(p.amount) as payment_082005
from staff a 
left outer join payment p
on a.staff_id = p.staff_id
where EXTRACT(YEAR_MONTH FROM p.payment_date) = '200508'
group by a.staff_id
;

-- 6c
/*List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. 
Use inner join.*/
select f.film_id, f.title, count(distinct fa.actor_id) as actor_count
from film f
INNER JOIN film_actor fa
on f.film_id=fa.film_id
group by f.film_id
order by f.title
;

-- 6d
/*How many copies of the film `Hunchback Impossible` exist in the inventory system?*/
select f.film_id, f.title, count(i.inventory_id) as copy_count
from film f
INNER JOIN inventory i
on f.film_id=i.film_id
where f.title like UPPER('Hunchback Impossible');

-- 6e
/*Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
List the customers alphabetically by last name:*/
select c.customer_id, c.first_name, c.last_name, SUM(p.amount) total_paid
from customer c
INNER JOIN payment p
on c.customer_id=p.customer_id
group by c.customer_id, c.first_name, c.last_name
order by c.last_name
;

-- 7a
/*The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display 
the titles of movies starting with the letters `K` and `Q` whose language is English. */
select f.film_id, f.title, l.`name` as `language`
from film f
INNER JOIN `language` l
on f.language_id = l.language_id
where l.`name` = 'English'
and substr(f.title, 1, 1) IN ('K','Q')
;

-- 7b
/*Use subqueries to display all actors who appear in the film `Alone Trip`.*/
select distinct f.film_id, f.title film_title, a.actor_id, a.first_name, a.last_name
from film f
INNER JOIN film_actor fa
on f.film_id = fa.film_id
INNER JOIN actor a
on fa.actor_id = a.actor_id
WHERE f.title = UPPER('Alone Trip')
;

-- 7c
/*You want to run an email marketing campaign in Canada, for which you will need the names and email 
addresses of all Canadian customers. Use joins to retrieve this information.*/
select c.customer_id, c.email, a.address, ci.city, co.country
from customer c
INNER JOIN address a 
ON c.address_id=a.address_id
INNER JOIN city ci
on ci.city_id = a.city_id
INNER JOIN country co
on co.country_id = ci.country_id
where country = 'Canada'
;

-- 7d
/* Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as famiy films.*/
select f.film_id, f.title, c.`name` as category
from film f
INNER JOIN film_category fc
on f.film_id = fc.film_id
INNER JOIN category c 
on fc.category_id = c.category_id
WHERE c.`name` = 'Family'
;

-- 7e
/*Display the most frequently rented movies in descending order.*/
select i.film_id, count(r.rental_id) rental_count
from rental r
INNER JOIN inventory i
on r.inventory_id = i.inventory_id
INNER join film f
on i.film_id = f.film_id
group by i.film_id
order by rental_count desc
;

-- 7f
/*Write a query to display how much business, in dollars, each store brought in.*/
select i.store_id, sum(p.amount)
from rental r
INNER JOIN inventory i
on r.inventory_id = i.inventory_id
INNER JOIN payment p
on p.rental_id = r.rental_id
group by i.store_id
;


-- 7g
/*Write a query to display for each store its store ID, city, and country.*/
select s.store_id, ci.city_id, ci.city, co.country_id, co.country
from store s
INNER JOIN address a
on s.address_id = a.address_id
INNER JOIN city ci
on a.city_id = ci.city_id
INNER JOIN country co
on ci.country_id = co.country_id
;

-- 7h
/*List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: 
category, film_category, inventory, payment, and rental.)*/
select fc.category_id, c.`name` as category, SUM(p.amount) as dollaramount
from payment p
INNER JOIN rental r
on p.rental_id = r.rental_id
INNER JOIN inventory i
on r.inventory_id = i.inventory_id
INNER JOIN film_category fc
on fc.film_id = i.film_id
INNER JOIN category c
on c.category_id = fc.category_id
group by fc.category_id
order by dollaramount desc
LIMIT 5
;

-- 8a
/*In your new role as an executive, you would like to have an easy way of viewing the Top five 
genres by gross revenue. Use the solution from the problem above to create a view. 
*/
CREATE VIEW vw_top5rental_genres
AS
select fc.category_id, c.`name` as category, SUM(p.amount) as dollaramount
from payment p
INNER JOIN rental r
on p.rental_id = r.rental_id
INNER JOIN inventory i
on r.inventory_id = i.inventory_id
INNER JOIN film_category fc
on fc.film_id = i.film_id
INNER JOIN category c
on c.category_id = fc.category_id
group by fc.category_id
order by dollaramount desc
LIMIT 5
;

-- 8b
/*How would you display the view that you created in 8a?*/
select *
from vw_top5rental_genres
;

-- 8c
/*You find that you no longer need the view `top_five_genres`. Write a query to delete it.*/
DROP VIEW vw_top5rental_genres;