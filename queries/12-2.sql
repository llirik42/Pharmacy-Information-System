select
    id as customer_id,
    full_name as customer_full_name,
    orders_count
from (
    select
        customers.id,
        customers.full_name,
        count(*) as orders_count,
        dense_rank() over (order by count(*) desc) as dr
    from orders
        join prescriptions_content on orders.id = prescriptions_content.prescription_id
        join customers on orders.customer_id = customers.id
    where drug_id = 1
    group by customer_id
    ) all_orders_count_data
where dr = 1
