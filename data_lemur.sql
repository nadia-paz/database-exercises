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