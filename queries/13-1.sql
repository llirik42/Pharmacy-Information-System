select
    drugs.name as drug_name,
    drug_types.name as drug_type,
    drugs.cost as drug_cost,
    coalesce(sum(available_amount), 0) as in_storage
from drugs
    join drug_types on drugs.type_id = drug_types.id
    left join storage_items on drugs.id = storage_items.drug_id
where drugs.id = 9
