select
    count(distinct customers.id) as customers_count
from prescriptions_content
    join drugs on prescriptions_content.drug_id = drugs.id
    join orders on orders.prescription_id = prescriptions_content.prescription_id
    join customers on orders.customer_id = customers.id
where
    (registration_datime between '2023/01/01' and '2025/01/01')
    and (drugs.type_id = 4)
