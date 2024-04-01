prepare stmt from '
    select
        technologies.id as technology_id,
        drugs.name as component_name,
        drugs.cost as component_cost,
        technology_components.component_amount
    from technologies
        join technology_components on technologies.id = technology_components.technology_id
        join drugs on drugs.id = technology_components.component_id
    where technologies.drug_id = ?
';

set @drug_id = 5;

execute stmt using @drug_id;
