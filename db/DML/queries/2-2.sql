prepare stmt from '
    select distinct
        customer_id
    from orders
        join orders_waiting_drug_supplies on orders.id = orders_waiting_drug_supplies.order_id
        join drugs on orders_waiting_drug_supplies.drug_id = drugs.id
    where drugs.type_id = ? and customer_id is not null
';

set @type_id = 2;

execute stmt using @type_id;
