select
    order_id,
    drug_id,
    drugs.name as drug_name,
    technology_id
from production
    join technologies on production.technology_id = technologies.id
    join drugs on technologies.drug_id = drugs.id;
