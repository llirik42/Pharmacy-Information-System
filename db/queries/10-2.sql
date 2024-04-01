prepare stmt from '
    select
        technologies.*
    from technologies
        join drugs on technologies.drug_id = drugs.id
    where drugs.type_id = ?
';

set @type_id = 2;

execute stmt using @type_id;
