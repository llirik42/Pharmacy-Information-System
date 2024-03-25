select distinct
  customers.id as customer_id,
  customers.full_name as customer_full_name,
  drugs.id as drug_id,
  drugs.name as drug_name,
  registration_date
from prescriptions_content
    join drugs on prescriptions_content.drug_id = drugs.id
    join orders on orders.prescription_id = prescriptions_content.prescription_id
    join customers on orders.customer_id = customers.id
where
    (registration_date between '2023/01/01' and '2025/01/01')
    and (drugs.type_id = 4);
