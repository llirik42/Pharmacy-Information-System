prepare stmt from '
    select
        id as technology_id
    from technologies
    where drug_id = ?
';

set @drug_id = 2;

execute stmt using @drug_id;
