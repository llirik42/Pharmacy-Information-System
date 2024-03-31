select
    technology_components.component_id,
    drugs.name as component_name,
    sum(production.amount * technology_components.component_amount) as component_amount
from production
    join technologies on production.technology_id = technologies.id
    join technology_components on technologies.id = technology_components.technology_id
    join drugs on component_id = drugs.id
group by technology_components.component_id