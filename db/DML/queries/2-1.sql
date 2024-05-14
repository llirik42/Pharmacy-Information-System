select distinct
    orders.customer_id
from orders
    join orders_waiting_drug_supplies on orders.id = orders_waiting_drug_supplies.order_id
where customer_id is not null
