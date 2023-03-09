SELECT candidate_id
FROM candidates
WHERE skill in ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id;

SELECT page_id 
FROM pages
LEFT JOIN page_likes USING(page_id)
where page_id not in (SELECT page_id FROM page_likes)
ORDER BY page_id;

/* solutions from the site */
SELECT page_id
FROM pages
EXCEPT
SELECT page_id
FROM page_likes
ORDER BY page_id;

SELECT pages.page_id
FROM pages
LEFT OUTER JOIN page_likes AS likes
  ON pages.page_id = likes.page_id
WHERE likes.page_id IS NULL;

/* unfinished parts */
SELECT distinct(part)
FROM parts_assembly
WHERE finish_date IS NULL;

/* count view on laptops and mobile devices*/
SELECT 
SUM(CASE device_type WHEN 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

/* count duplicated jobs */
SELECT COUNT(temp.company_id)
FROM (SELECT company_id, title, description, COUNT(*) as count_jobs
FROM job_listings
GROUP BY company_id, title, description) temp
WHERE count_jobs = 2;

/* difference in days */
SELECT user_id, Max(post_date::Date)-MIN(post_date::Date) as days_between
FROM posts
WHERE DATE_PART('YEAR', post_date) = '2021'
GROUP BY user_id
HAVING COUNT(post_id) > 1;

/* who sent more messages in August 2022*/
SELECT sender_id, COUNT(content) AS message_count
FROM messages
WHERE DATE_PART('MONTH', sent_date) = '08' AND
      DATE_PART('YEAR', sent_date) = '2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

/* ist the top three cities that have the most completed trade orders in descending order.*/
SELECT u.city, COUNT(t.order_id) AS total_orders
FROM users u
JOIN trades t ON u.user_id = t.user_id AND t.status = 'Completed'
GROUP BY u.city
ORDER BY total_orders DESC
LIMIT 3;

/* get the average stars for each product every month.*/
SELECT DATE_PART('MONTH', submit_date) as mth, 
  product_id as product,
  ROUND(AVG(stars), 2) as avg_stars
FROM reviews
GROUP BY mth, product
ORDER BY mth, product;

/* Write a query to get the app’s click-through rate (CTR %) in 2022 */
/* Percentage of click-through rate = 100.0 * Number of clicks / Number of impressions */
SELECT app_id, ROUND(
  COUNT(CASE event_type WHEN 'click' THEN 1 END) * 100.0 /
  COUNT(CASE event_type WHEN 'impression' THEN 1 END),
  2) AS ctr
FROM events
WHERE DATE_PART('YEAR', timestamp) = 2022
GROUP BY app_id;

/* solution on the site */
SELECT
  app_id,
  ROUND(100.0 *
    SUM(1) FILTER (WHERE event_type = 'click') /
    SUM(1) FILTER (WHERE event_type = 'impression'), 2) AS ctr_app
FROM events
WHERE timestamp >= '2022-01-01' 
  AND timestamp < '2023-01-01'
GROUP BY app_id;

/* display the ids of the users who did not confirm on the first day of sign-up, but confirmed on the second day.*/
SELECT user_id
FROM emails e
JOIN texts t ON e.email_id = t.email_id AND t.signup_action = 'Confirmed'
WHERE DATE_PART('DAYS', t.action_date - e.signup_date) = 1;

SELECT card_name, MAX(issued_amount) - MIN(issued_amount) as difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

SELECT 
  ROUND(
  SUM(CAST(item_count as decimal) * order_occurrences) / 
  SUM(order_occurrences), 
  1)
FROM items_per_order;
