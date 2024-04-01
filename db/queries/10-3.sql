select distinct
    technologies.*
from technologies
    join drugs on technologies.drug_id = drugs.id
    join production on technologies.id = production.technology_id
