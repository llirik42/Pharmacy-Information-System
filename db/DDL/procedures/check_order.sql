create
    definer = llirik42@`%` procedure check_order(in order_id int)
begin
    select
        prescription_id,
        registration_datetime,
        appointed_datetime,
        obtaining_datetime,
        paid,
        customer_id
        into @prescription_id, @registration_datetime, @appointed_datetime, @obtaining_datetime, @paid, @customer_id
    from orders
    where orders.id = order_id;

    select date into @prescription_date
    from prescriptions
    where prescriptions.id = @prescription_id;

    if (@obtaining_datetime is not null and not @paid) then
        call raise_error('order cannot be obtained, but not paid');
    end if;

    if (@registration_datetime > @appointed_datetime) then
        call raise_error('order registration datetime cannot be greater that appointed datetime');
    end if;

    if (@obtaining_datetime is not null and @appointed_datetime is null) then
        call raise_error('order cannot be obtained without appointing date');
    end if;

    if (@registration_datetime < @prescription_date) then
        call raise_error('invalid prescription date');
    end if;
end;
