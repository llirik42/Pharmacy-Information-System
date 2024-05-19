create trigger check_order_insert
    before insert
    on orders
    for each row
begin
    call check_order(
        new.id,
        new.prescription_id,
        new.registration_datetime,
        new.appointed_datetime,
        new.obtaining_datetime,
        new.paid,
        new.customer_id
    );
end;
