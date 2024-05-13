create
    definer = llirik42@`%` procedure raise_error(IN message text)
BEGIN
        SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = message;
END;

create
    definer = llirik42@`%` procedure check_date_in_past(IN birthday datetime)
BEGIN
    if (birthday > now()) THEN
        call raise_error('Invalid birthday');
    end if;
END;

create
    definer = llirik42@`%` procedure check_drug_is_cookable(IN drug_id int)
BEGIN
    select dt.cookable into @is_cookable
        from drugs join db.drug_types dt on drugs.type_id = dt.id
        where drugs.id = drug_id;

    if (not @is_cookable) THEN
        call raise_error('Drug is not cookable');
    end if;
END;

create
    definer = llirik42@`%` procedure check_no_drugs_with_type_and_route_in_prescription(IN drug_type_id int, IN route_id int)
BEGIN
    if (select count(*)
        from prescriptions_content join drugs on drugs.type_id = drug_type_id
        where prescriptions_content.administration_route_id = route_id) > 0 THEN
            call raise_error('There are prescriptions with drug type and administration route');
    end if;
END;

create
    definer = llirik42@`%` procedure check_no_technologies_for_drug_type(IN drug_type_id int)
BEGIN
    if (select count(*)
        from drugs join technologies on drugs.id = technologies.drug_id
        where type_id = drug_type_id) > 0 THEN
            call raise_error('There are cooking-technologies for drugs with this drug-type');
    end if;
END;

create
    definer = llirik42@`%` procedure check_order(IN order_id int)
BEGIN
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

    if (@obtaining_datetime is not null and not @paid) THEN
        call raise_error('Order cannot be obtained, but not paid');
    end if;

    if (@registration_datetime > @appointed_datetime) THEN
        call raise_error('Order registration datetime cannot be greater that appointed datetime');
    end if;

    if (@obtaining_datetime is not null and @appointed_datetime is null) THEN
        call raise_error('Order cannot be obtained without appointing date');
    end if;

    if (@registration_datetime < @prescription_date) THEN
        call raise_error('Invalid prescription date');
    end if;
END;

create
    definer = llirik42@`%` procedure check_order_requires_drug(IN order_id int, IN drug_id int)
BEGIN
    if not EXISTS(select *
    from orders
        join prescriptions on orders.prescription_id = prescriptions.id
        join prescriptions_content pc on prescriptions.id = pc.prescription_id and pc.drug_id = drug_id
    where orders.id = order_id) THEN
        call raise_error('The order does not require the drug');
    end if;
END;

create
    definer = llirik42@`%` procedure check_order_waiting_production(IN order_id int, IN production_id int)
BEGIN
    select technologies.drug_id into @drug_id
    from production
        join technologies on production.technology_id = technologies.id
    where production.id = production_id;

    call check_order_requires_drug(order_id, @drug_id);
END;

create
    definer = llirik42@`%` procedure check_phone_number(IN phone_number text)
BEGIN
    if (not (regexp_like(phone_number, '^\\+7-\\(9\\d\\d\\)-\\d\\d\\d-\\d\\d-\\d\\d$'))) THEN
        call raise_error('Invalid phone number');
    end if;
END;

create
    definer = llirik42@`%` procedure check_prescription_drug(IN drug_id int, IN administration_route_id int)
BEGIN
    if (select count(*)
        from drugs join db.drug_types_administration_routes dtar on drugs.type_id = dtar.type_id
        where drug_id = drugs.id and dtar.route_id = administration_route_id) = 0 THEN
            call raise_error('Invalid administration route for drug');
    end if;
END;

create
    definer = llirik42@`%` procedure check_production_lab_workers(IN id int, IN start datetime)
BEGIN
    IF (select count(*) from production_lab_workers where production_lab_workers.production_id = id) = 0
            AND start is not NULL THEN
        call raise_error('Production must have at least one lab worker');
    END IF;
END;

create
    definer = llirik42@`%` procedure check_production_start_end(IN start datetime, IN end datetime)
BEGIN
        IF (end is not null and (start is null or start >= end)) THEN
            call raise_error('Invalid start datetime');
        END IF;
END;

create
    definer = llirik42@`%` procedure check_production(IN id int, IN start datetime, IN end datetime)
BEGIN
    call check_production_start_end(start, end);
    call check_production_lab_workers(id, start);
END;
