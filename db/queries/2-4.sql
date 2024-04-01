prepare stmt from '
    select
        count(distinct customers.id) as customers_count
    from orders
        join orders_waiting_drug_supplies on orders.id = orders_waiting_drug_supplies.order_id
        join customers on orders.customer_id = customers.id
        join drugs on orders_waiting_drug_supplies.drug_id = drugs.id
    where drugs.type_id = ?
';

set @type_id = 2;

execute stmt using @type_id;
