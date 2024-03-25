select
    technologies.id as technology_id,
    components.name as component_name,
    components.cost as component_cost,
    technology_components.component_amount
from drugs
    join technologies on drugs.id = technologies.drug_id
    join technology_components on technologies.id = technology_components.technology_id
    join drugs components on components.id = technology_components.component_id
where drugs.id = 1;
