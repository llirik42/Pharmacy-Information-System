select
    technology_components.component_id,
    sum(production.drug_amount * technology_components.component_amount) as component_amount
from production
    join technologies on production.technology_id = technologies.id
    join technology_components on technologies.id = technology_components.technology_id
group by technology_components.component_id
order by component_amount desc
