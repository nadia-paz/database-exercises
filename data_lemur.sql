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