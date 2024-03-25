select distinct
    technologies.id as techonology_id,
    technologies.description as technology_description,
    drugs.id as drug_id,
    drugs.name as drug_name
from technologies
    join drugs on technologies.drug_id = drugs.id
    join production on technologies.id = production.technology_id;
