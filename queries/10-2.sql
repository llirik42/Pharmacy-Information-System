select
    technologies.*
from technologies
    join drugs on technologies.drug_id = drugs.id
where drugs.type_id = 3
