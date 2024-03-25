select distinct
  customers.id as customer_id,
  customers.full_name as customer_full_name,
  registration_date
from prescriptions_content
    join orders on orders.prescription_id = prescriptions_content.prescription_id
    join customers on orders.customer_id = customers.id
where
    (registration_date between '2023/01/01' and '2025/01/01')
    and (prescriptions_content.drug_id = 4);
