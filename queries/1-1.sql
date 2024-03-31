select distinct
    customer_id as id,
    customers.full_name,
    customers.phone_number,
    customers.address
from orders
    join customers on orders.customer_id = customers.id
where
    orders.appointed_datetime is not null
    and appointed_datetime <= now()
    and (
        orders.obtaining_datetime is null
        or orders.obtaining_datetime <> orders.appointed_datetime
    )
