
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