-- Easy
-- 1. Who is the senior most employee based on job title?
select first_name, last_name from employee
order by levels desc
limit 1;

-- 2. Which countries have the most Invoices?
select billing_country from invoice
group by billing_country
order by count(billing_country) desc
limit 1;

-- 3. What are top 3 values of total invoice?
select total from invoice
order by total desc
limit 3;

-- 4. Which city has the best customers? 
select billing_city, sum(total) from invoice
group by billing_city
order by sum(total) desc
limit 3;

-- 5. Who is the best customer?
select c.first_name, c.last_name, c. customer_id, sum(i.total) from customer c
join invoice i on i.customer_id=c.customer_id
group by c.first_name, c.last_name, c. customer_id
order by sum(i.total)
limit 1;

-- Moderate
-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
select c.email, c.first_name, c.last_name, g.name from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
where g.name='Rock'
order by c.email;

-- 2. Write a query that returns the Artist name and total track count of the top 10 rock bands
select ar.name, count(t.track_id) from track t
join album al on t.album_id=al.album_id
join artist ar on al.artist_id=ar.artist_id
join genre g on t.genre_id=g.genre_id
where g.name='Rock'
group by ar.name
order by count(t.track_id) desc
limit 10;

-- 3. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. 
select name, milliseconds from track
where milliseconds> (select avg(milliseconds) from track)
order by milliseconds desc;

-- Advance
-- 1. Find how much amount spent by each customer on artists?
select c.first_name, c.last_name, ar.name, sum(i.total) from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join album al on t.album_id=al.album_id
join artist ar on al.artist_id=ar.artist_id
group by c.first_name, c.last_name, ar.name;

-- 2. Write a query that returns each country along with the top Genre. 
with sales as(
select i.billing_country as country , g.name as genre_name, sum(i.total) as total_sales from invoice i
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
group by i.billing_country, g.name),
max_sales as(
select country, max(total_sales) as max_sales from sales
group by country)
select s.country, s.genre_name, s.total_sales from sales s
join max_sales ms on s.country=ms.country
and s.total_sales=ms.max_sales
order by s.country, s.genre_name;

-- 3. Write a query that determines the customer that has spent the most on music for each country. 
with sales as(
select c.customer_id as id, c.first_name as fname, c.last_name as lname, i.billing_country as country, sum(i.total) as total_sales from customer c
join invoice i on c.customer_id=i.customer_id
group by c.customer_id, c.first_name, c.last_name, i.billing_country),
max_sales as(
select country, max(total_sales) as max_sales from sales
group by country)
select s.id, s.fname, s.lname, s.country, s.total_sales from sales s
join max_sales ms on s.country=ms.country 
and s.total_sales=ms.max_sales
order by s.country, s.fname, s.lname;







