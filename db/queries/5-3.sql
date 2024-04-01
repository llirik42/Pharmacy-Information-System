prepare stmt from '
    select distinct
        customers.id as customer_id,
        customers.full_name as customer_full_name
    from prescriptions_content
        join drugs on prescriptions_content.drug_id = drugs.id
        join orders on orders.prescription_id = prescriptions_content.prescription_id
        join customers on orders.customer_id = customers.id
    where
        (registration_datetime between ? and ?)
        and (drugs.type_id = ?)
';

set @min_registration_datetime = '2023/01/01';
set @max_registration_datetime = '2025/01/01';
set @type_id = 2;

execute stmt using @min_registration_datetime, @max_registration_datetime, @type_id;
