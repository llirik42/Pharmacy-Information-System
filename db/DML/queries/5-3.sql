prepare stmt from '
    select distinct
        customer_id
    from prescriptions_content
        join drugs on prescriptions_content.drug_id = drugs.id
        join orders using (prescription_id)
    where
        (registration_datetime between ? and ?)
        and (drugs.type_id = ?)
        and customer_id is not null
';

set @min_registration_datetime = '2023/01/01';
set @max_registration_datetime = '2025/01/01';
set @type_id = 2;

execute stmt using @min_registration_datetime, @max_registration_datetime, @type_id;
