prepare stmt from '
    select distinct
        customer_id
    from prescriptions_content
        join orders using (prescription_id)
    where
        (registration_datetime between ? and ?)
        and customer_id is not null
';

set @min_registration_datetime = '2023/01/01';
set @max_registration_datetime = '2025/01/01';

execute stmt using @min_registration_datetime, @max_registration_datetime;
