prepare stmt from '
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
            join drugs on prescriptions_content.drug_id = drugs.id
            join customers on orders.customer_id = customers.id
        where type_id = ?
        group by customer_id
        ) all_orders_count_data
    where dr = 1
';

set @type_id = 1;

execute stmt using @type_id;