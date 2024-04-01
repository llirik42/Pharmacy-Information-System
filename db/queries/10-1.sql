prepare stmt from '
    select
        id as technology_id,
        cooking_time,
        amount,
        description
    from technologies
    where drug_id = ?
';

set @drug_id = 2;

execute stmt using @drug_id;
