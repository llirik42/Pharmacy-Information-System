select
    technologies.id as techonology_id,
    technologies.description as technology_description,
    drugs.id as drug_id,
    drugs.name as drug_name
from technologies
    join drugs on technologies.drug_id = drugs.id
where drugs.type_id = 3;
