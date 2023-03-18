
/* third transaction of every user */
SELECT user_id, spend, transaction_date FROM
(SELECT user_id, spend, transaction_date, RANK() OVER (
  PARTITION BY user_id
  ORDER BY transaction_date) as ranknum
FROM transactions) a
WHERE a.ranknum = 3;
