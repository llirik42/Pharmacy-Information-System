select
    technologies.id,
    technologies.description,
    technologies.cooking_time,
    technologies.amount as output_amount,
    sum(components.cost * technology_components.component_amount) as total_components_cost
from drugs
    join technologies on drugs.id = technologies.drug_id
    join technology_components on technologies.id = technology_components.technology_id
    join drugs components on components.id = technology_components.component_id
where drugs.id = 7
group by technologies.id;
