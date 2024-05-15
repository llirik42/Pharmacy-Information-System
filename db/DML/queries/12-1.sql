select
    id as customer_id,
    orders_count
from (
    select
        customers.id,
        count(*) as orders_count,
        dense_rank() over (order by count(*) desc) as dr
    from orders
        join prescriptions_content using (prescription_id)
        join drugs on prescriptions_content.drug_id = drugs.id
        join customers on orders.customer_id = customers.id
    group by customer_id
    ) all_orders_count_data
where dr = 1
