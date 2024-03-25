select distinct
  customers.id as customer_id,
  customers.full_name as customer_full_name,
  appointed_date,
  obtaining_date
from orders 
  join customers on orders.customer_id = customers.id
where 
  appointed_date is not null
  and appointed_date <= now()
  and (obtaining_date is null or obtaining_date <> appointed_date);
