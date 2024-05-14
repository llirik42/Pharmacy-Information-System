with
    drugs_of_type_storage_amount as (
        select
            drugs.id as drug_id,
            coalesce(sum(available_amount), 0) as drug_amount,
            critical_amount
        from drugs
            left join storage_items on drugs.id = storage_items.drug_id
        where
            type_id = 6
        group by
            drugs.id,
            critical_amount
    ),

    ranked_drugs as (
        select
          drug_id,
          dense_rank() over (order by drug_amount) as dr,
          drug_amount
      from drugs_of_type_storage_amount
      group by drug_id
    )

select
    drug_id,
    drug_amount
from ranked_drugs
where dr = 1
