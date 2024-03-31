select count(*) as production_orders_count
from production join orders on production.order_id = orders.id
