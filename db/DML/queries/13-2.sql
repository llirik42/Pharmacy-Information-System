prepare stmt from '
    select
        technologies.id as technology_id,
        technologies.description as technology_description,
        technologies.cooking_time,
        technologies.amount as output_amount,
        sum(components.cost * component_amount) as total_components_cost
    from drugs
        join technologies on drugs.id = technologies.drug_id
        join technology_components on technologies.id = technology_components.technology_id
        join drugs components on components.id = technology_components.component_id
    where drugs.id = ?
    group by technologies.id
';

set @drug_id = 2;

execute stmt using @drug_id;
