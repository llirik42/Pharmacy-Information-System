select distinct
    id as order_id
from orders
where
    appointed_datetime is not null
    and appointed_datetime <= now()
    and (
        obtaining_datetime is null
        or obtaining_datetime <> appointed_datetime
    )
