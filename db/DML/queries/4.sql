prepare stmt from '
    with
        used_in_cooking_drugs as (
            select
                component_id as drug_id,
                sum(component_amount) as drug_amount
            from production
                join technology_components on production.technology_id = technology_components.technology_id
                join drugs on technology_components.component_id = drugs.id
            where start between ? and ?
            group by component_id
        ),

        sold_drugs as (
            select
                drug_id,
                sum(amount) as drug_amount
            from orders
                join prescriptions_content using (prescription_id)
            where obtaining_datetime between ? and ?
            group by drug_id
        ),

        used_drugs as (
            select
                drug_id,
                drugs.name,
                sum(drug_amount) as drug_amount
            from (
                select *
                from used_in_cooking_drugs
                union all
                select *
                from sold_drugs
                ) as _
                join drugs on drug_id = drugs.id
            group by drug_id)

    select drug_id, drug_amount
    from used_drugs
    order by drug_amount desc
';

set @min_datetime = '2023/01/01';
set @max_datetime = '2023/05/01';

execute stmt using @min_datetime, @max_datetime, @min_datetime, @max_datetime;
