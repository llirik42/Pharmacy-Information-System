select distinct
    technologies.id as technology_id
from technologies
    join production on technologies.id = production.technology_id
