USE telco_normalized;

SELECT *
FROM customer_details
LEFT JOIN customer_churn USING (customer_id)
LEFT JOIN customer_contracts USING (customer_id)
LEFT JOIN customer_payments USING (customer_id)
LEFT JOIN customer_signups USING (customer_id)
LEFT JOIN customer_subscriptions USING (customer_id)
LEFT JOIN contract_types USING (contract_type_id)
LEFT JOIN internet_service_types USING (internet_service_type_id)
LEFT JOIN payment_types USING (payment_type_id);


