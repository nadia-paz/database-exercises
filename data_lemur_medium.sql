
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
