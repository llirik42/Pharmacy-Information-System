with
    critical_amount_drugs as (
        select
            drugs.id as drug_id,
            drugs.name as drug_name,
            coalesce(sum(available_amount), 0) as drug_amount,
            critical_amount
        from drugs
            left join storage_items on drugs.id = storage_items.drug_id
        group by
            drugs.id,
            critical_amount
        having
            drug_amount <= critical_amount or drug_amount = 0
    )

select distinct
    type_id,
    drug_types.name
from critical_amount_drugs
    join drugs on critical_amount_drugs.drug_id = drugs.id
    join db.drug_types on drugs.type_id = drug_types.id
order by
    type_id
