-- SQL for Data Analysis - Weekender Crash Course  

-- Email Campaigns for customers of Store 2
-- First, Last name and Email address of customers from Store 2
SELECT first_name, last_name, email
FROM customer
WHERE store_id = 2;

-- Movies with a rental rate of $0.99
SELECT COUNT(*) 
FROM film
WHERE rental_rate = 0.99;

-- Rental rate and number of movies per rental rate
SELECT rental_rate, COUNT(*) AS total_number_of_movies
FROM film
GROUP BY rental_rate;
-- Or:
SELECT rental_rate, COUNT(*) AS total_number_of_movies
FROM film
GROUP BY 1;

-- Which rating has the most number of movies?
SELECT rating, COUNT(*) AS total_number_of_movies
FROM film
GROUP BY 1;

-- Which rating is the most commom in each store?
SELECT 
	s.store_id, 
	f.rating, COUNT(f.rating) AS total_number_of_films
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN film f ON f.film_id = i.film_id
GROUP BY 1,2;

-- We want to mail the customers about the upcoming promotion
SELECT 
	c.customer_id, c.first_name, c.last_name, 
	a.address
FROM customer c
JOIN address a ON c.address_id = a.address_id;

-- List of films by Film Name, Category, Language
SELECT 
	f.title,
	c.name,
	l.name
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON l.language_id = f.language_id;

-- How many times each movie has been rented out?
SELECT 
	i.film_id, 
	f.title, 
	COUNT(i.film_id) AS total_number_of_rental_times
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY i.film_id
ORDER BY 3 DESC;

-- Revenue per Movie
SELECT 
	i.film_id, 
	f.title, 
	COUNT(i.film_id) AS total_number_of_rental_times, 
	f.rental_rate, 
	COUNT(i.film_id)*f.rental_rate AS revenue_per_movie
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY i.film_id
ORDER BY 5 DESC;

-- Customer with the highest spending
SELECT 
	c.customer_id, 
	SUM(p.amount) AS total_spending
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 1
ORDER BY 2 DESC;

-- Which store has brought the most revenue overall?
SELECT 
	s.store_id, 
	SUM(p.amount) AS "Total Spending"
FROM store s
JOIN inventory i ON i.store_id = s.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY 1
ORDER BY 2 DESC;

-- Rentals per month
SELECT 
	left(rental_date,7) AS "Month", 
	COUNT(*)
FROM rental
GROUP BY 1
ORDER BY 2 DESC;
-- Or:
SELECT 
	date_format(rental_date,"%M") AS "Month", 
	COUNT(*)
FROM rental
GROUP BY 1
ORDER BY 2 DESC;

-- Earliest rental date
SELECT MIN(rental_date) 
FROM rental;

-- Latest rent date
SELECT MAX(rental_date)
FROM rental;

-- First and latest rental date of each movie
SELECT 
	f.title AS film_title, 
	MIN(r.rental_date) AS earliest_rental_date, 
	MAX(r.rental_date) AS latest_rental_date
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY 1;

-- Last Rental Date of every customer
SELECT 
	c.customer_id, c.first_name, c.last_name, 
	MAX(r.rental_date) AS last_rental_date
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY 1;

-- Revenue Per Month
SELECT 
	LEFT(payment_date,7) AS month, 
	SUM(amount) AS revenue_per_month
FROM payment
GROUP BY 1;

-- Distint Renters per month
SELECT 
	LEFT(rental_date,7) AS month, 
	COUNT(DISTINCT(rental_id)) AS total_customers,
	COUNT(DISTINCT(customer_id)) AS unique_customers, 
	COUNT(DISTINCT(rental_id))/COUNT(DISTINCT(customer_id)) AS avg_rent_per_customer
FROM rental
GROUP BY 1;

-- Distinct Films Rented Each Month
SELECT 
	i.film_id, 
	f.title, 
	LEFT(r.rental_date,7) AS month, 
	COUNT(i.film_id) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY 1, 3
ORDER BY 1, 2, 3;

-- Number of Rentals in Comedy , Sports and Family
SELECT 
	c.name, 
	COUNT(c.name) AS count_rentals
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE c.name IN ("Comedy", "Sports", "Family")
GROUP BY 1;

-- Customers who have been rented a movie at least 3 times
SELECT 
	c.customer_id,
	CONCAT(c.first_name, " ", c.last_name) AS customer_name, 
	COUNT(c.customer_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY 1
HAVING COUNT(c.customer_id) >= 3
ORDER BY 1;

-- Revenue per store with PG13 and R rated films
SELECT 
	s.store_id, 
	f.rating, 
	SUM(p.amount) AS total_revenue
FROM store s 
JOIN inventory i ON i.store_id = s.store_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
JOIN film f ON f.film_id = i.film_id
WHERE f.rating IN ("PG-13", "R")
GROUP BY 1,2;

---

/* Active User  where active = 1*/
DROP TEMPORARY TABLE IF EXISTS tbl_active_users;
CREATE TEMPORARY TABLE tbl_active_users(
SELECT c.*, a.phone
FROM customer c
JOIN address a ON a.address_id = c.address_id
WHERE c.active = 1);


/* Reward Users : who has rented at least 30 times*/
DROP TEMPORARY TABLE IF EXISTS tbl_rewards_user;
CREATE TEMPORARY TABLE tbl_rewards_user(
SELECT r.customer_id, COUNT(r.customer_id) AS total_rents, max(r.rental_date) AS last_rental_date
FROM rental r
GROUP BY 1
HAVING COUNT(r.customer_id) >= 30);

/* Reward Users who are also active */
SELECT au.customer_id, au.first_name, au.last_name, au.email
FROM tbl_rewards_user ru
JOIN tbl_active_users au ON au.customer_id = ru.customer_id;

/* All Rewards Users with Phone */
SELECT ru.customer_id, c.email, au.phone
FROM tbl_rewards_user ru
LEFT JOIN tbl_active_users au ON au.customer_id = ru.customer_id
JOIN customer c ON c.customer_id = ru.customer_id;
