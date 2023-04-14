
/* third transaction of every user */
SELECT user_id, spend, transaction_date FROM
(SELECT user_id, spend, transaction_date, RANK() OVER (
  PARTITION BY user_id
  ORDER BY transaction_date) as ranknum
FROM transactions) a
WHERE a.ranknum = 3;

/* Output the age bucket and percentage of sending and opening snaps */
SELECT age_bucket, ROUND(100.0 * ts / (ts + topen), 2) as send_perc,
      ROUND(100.0 * topen / (ts + topen), 2) as open_perc
FROM
(
SELECT age_bucket, 
  SUM(CASE activity_type
  WHEN 'send' THEN a.time_spent ELSE 0 END) as ts,
  SUM(CASE activity_type
  WHEN 'open' THEN a.time_spent ELSE 0 END) as topen
FROM age_breakdown ab
JOIN activities a USING(user_id) 
GROUP BY age_bucket
) temp_t; 

/* calculate the rolling average of tweets per user per 3 days */
SELECT user_id, tweet_date, ROUND(AVG(tweets) OVER (
  PARTITION BY user_id
  ROWS BETWEEN 2 preceding and current row), 2) AS rolling_avg_3d
FROM (
  SELECT user_id, tweet_date, COUNT(user_id) AS tweets
  FROM tweets
  GROUP BY user_id, tweet_date
  ORDER BY user_id, tweet_date) a;

/*
Identify the top two highest-grossing products within each category in 2022. 
Output the category, product, and total spend.
*/
WITH spend_table  AS /* first temporal table */
  (
  SELECT category, product, SUM(spend) as total_spend
  FROM product_spend
  WHERE DATE_PART('year', transaction_date) = '2022'
  GROUP BY category, product
  ) ,
  ranking AS /* second temporal */
  (
  SELECT *, RANK() OVER(
    PARTITION BY category
    ORDER BY total_spend DESC) AS ranknum
  FROM spend_table
  )

SELECT category, product, total_spend
FROM ranking
WHERE ranknum < 3;

/* 
determine the top 5 artists whose songs appear in the Top 10 
of the global_song_rank table the highest number of times. 
From now on, we'll refer to this ranking number as "song appearances".
Output the top 5 artist names in ascending order along with their song appearances ranking
*/

/* used DENSE_RANK() not to skip repeated numbers */

WITH 

song_apperance AS
(SELECT  artist_name, COUNT(song_id) as appearance 
FROM global_song_rank gsr
JOIN songs s USING(song_id)
JOIN artists a USING(artist_id)
WHERE gsr.rank <= 10
GROUP BY artist_name),

ranking AS
(SELECT artist_name, DENSE_RANK() OVER (
ORDER BY appearance DESC) AS artist_rank
FROM song_apperance
)

SELECT *
FROM ranking
WHERE artist_rank <= 5;

/* activation rate of specific users in the emails table, 
which may not include all users that could potentially be found in the texts table.*/
WITH 
full_list AS
(
SELECT *
FROM emails e
LEFT JOIN texts t USING(email_id)
WHERE t.email_id IS NOT NULL
)
SELECT ROUND(1.0 * SUM(
CASE signup_action 
WHEN 'Confirmed' THEN 1 ELSE 0 END
) / COUNT (*), 2) AS confirm_rate
FROM full_list;

/* solution on the site
Signup Activation Rate = Number of users who confirmed their accounts / 
Number of users in the emails table
*/
SELECT 
  ROUND(COUNT(texts.email_id)::DECIMAL
    /COUNT(DISTINCT emails.email_id),2) AS activation_rate
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND texts.signup_action = 'Confirmed';
