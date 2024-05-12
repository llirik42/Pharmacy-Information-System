create definer = llirik42@`%` trigger check_valid_customer_phone_number_insert
    before insert
    on customers
    for each row
BEGIN
    call check_phone_number(NEW.phone_number);
end;

create definer = llirik42@`%` trigger check_valid_customer_phone_number_update
    before update
    on customers
    for each row
BEGIN
    call check_phone_number(NEW.phone_number);
end;

create table if not exists doctors
(
    id        int auto_increment
        primary key,
    full_name varchar(256) not null,
    constraint doctors_pk
        unique (full_name)
);

create table if not exists drug_types
(
    id       int auto_increment
        primary key,
    name     text       not null,
    cookable tinyint(1) not null
);

create definer = llirik42@`%` trigger check_no_techs_for_not_cookable
    before update
    on drug_types
    for each row
BEGIN
    call check_no_technologies_for_drug_type(NEW.id);
end;

create table if not exists drug_types_administration_routes
(
    type_id  int not null,
    route_id int not null,
    constraint drug_types_administration_routes_administration_routes_id_fk
        foreign key (route_id) references administration_routes (id),
    constraint drug_types_administration_routes_drug_types_id_fk
        foreign key (type_id) references drug_types (id)
);

create definer = llirik42@`%` trigger drug_types_administration_routes_trigger_delete
    before delete
    on drug_types_administration_routes
    for each row
BEGIN
    call check_no_drugs_with_type_and_route_in_prescription(OLD.type_id, OLD.route_id);
end;

create definer = llirik42@`%` trigger drug_types_administration_routes_trigger_update
    before update
    on drug_types_administration_routes
    for each row
BEGIN
    call check_no_drugs_with_type_and_route_in_prescription(NEW.type_id, NEW.route_id);
end;

create table if not exists drugs
(
    id              int auto_increment
        primary key,
    name            text not null,
    cost            int  not null,
    shelf_life      int  not null,
    critical_amount int  not null,
    type_id         int  not null,
    description     text not null,
    constraint drugs_drug_types_id_fk
        foreign key (type_id) references drug_types (id),
    check (`cost` > 0),
    check (`shelf_life` > 0),
    check (`critical_amount` >= 0)
);

create table if not exists lab_workers
(
    id        int auto_increment
        primary key,
    full_name text not null
);

create table if not exists mixture_types
(
    id   int auto_increment
        primary key,
    name text not null
);

create table if not exists mixtures
(
    drug_id         int auto_increment
        primary key,
    solvent         text not null,
    mixture_type_id int  not null,
    constraint mixtures_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint mixtures_mixture_types_id_fk
        foreign key (mixture_type_id) references mixture_types (id)
);

create table if not exists patients
(
    id        int auto_increment
        primary key,
    full_name text not null,
    birthday  date not null
);

create definer = llirik42@`%` trigger patients_age_insert
    before insert
    on patients
    for each row
BEGIN
    call check_date_in_past(NEW.birthday);
end;

create definer = llirik42@`%` trigger patients_age_update
    before update
    on patients
    for each row
BEGIN
    call check_date_in_past(NEW.birthday);
end;

create table if not exists pills
(
    drug_id        int not null
        primary key,
    weight_of_pill int not null,
    pills_count    int not null,
    constraint pills_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    check (`weight_of_pill` > 0),
    check (`pills_count` >= 1)
);

create table if not exists powders
(
    drug_id   int        not null
        primary key,
    composite tinyint(1) not null,
    constraint powders_drugs_id_fk
        foreign key (drug_id) references drugs (id)
);

create table if not exists prescriptions
(
    id         int auto_increment
        primary key,
    diagnosis  text not null,
    patient_id int  not null,
    doctor_id  int  not null,
    date       date not null,
    constraint prescriptions_doctors_id_fk
        foreign key (doctor_id) references doctors (id),
    constraint prescriptions_patients_id_fk
        foreign key (patient_id) references patients (id)
);

create table if not exists orders
(
    id                    int auto_increment
        primary key,
    prescription_id       int        not null,
    registration_datetime datetime   not null,
    appointed_datetime    datetime   null,
    obtaining_datetime    datetime   null,
    paid                  tinyint(1) not null,
    customer_id           int        null,
    constraint orders_customers_id_fk
        foreign key (customer_id) references customers (id),
    constraint orders_prescriptions_id_fk
        foreign key (prescription_id) references prescriptions (id)
);

create definer = llirik42@`%` trigger check_order_insert
    before insert
    on orders
    for each row
BEGIN
    call check_order(NEW.id);
end;

create definer = llirik42@`%` trigger check_order_update
    before update
    on orders
    for each row
BEGIN
    call check_order(NEW.id);
end;

create table if not exists orders_waiting_drug_supplies
(
    order_id int not null,
    drug_id  int not null,
    amount   int not null,
    primary key (drug_id, order_id),
    constraint orders_waiting_supplies_list_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint orders_waiting_supplies_list_orders_id_fk
        foreign key (order_id) references orders (id),
    check (`amount` > 0)
);

create definer = llirik42@`%` trigger check_orders_waiting_supply_insert
    before insert
    on orders_waiting_drug_supplies
    for each row
BEGIN
    call check_order_requires_drug(NEW.order_id, NEW.drug_id);
end;

create definer = llirik42@`%` trigger check_orders_waiting_supply_update
    before update
    on orders_waiting_drug_supplies
    for each row
BEGIN
    call check_order_requires_drug(NEW.order_id, NEW.drug_id);
end;

create table if not exists prescriptions_content
(
    prescription_id         int not null,
    drug_id                 int not null,
    amount                  int not null,
    administration_route_id int not null,
    primary key (prescription_id, drug_id, administration_route_id),
    constraint prescriptions_content_administration_routes_id_fk
        foreign key (administration_route_id) references administration_routes (id),
    constraint prescriptions_content_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint prescriptions_content_prescriptions_id_fk
        foreign key (prescription_id) references prescriptions (id),
    check (`amount` > 0)
);

create definer = llirik42@`%` trigger check_prescriptions_content_insert
    before insert
    on prescriptions_content
    for each row
BEGIN
    call check_prescription_drug(NEW.drug_id, NEW.administration_route_id);
end;

create definer = llirik42@`%` trigger check_prescriptions_content_update
    before update
    on prescriptions_content
    for each row
BEGIN
    call check_prescription_drug(NEW.drug_id, NEW.administration_route_id);
end;

create table if not exists salves
(
    drug_id          int  not null
        primary key,
    active_substance text not null,
    constraint salves_drugs_id_fk
        foreign key (drug_id) references drugs (id)
);

create table if not exists solutions
(
    drug_id int not null
        primary key,
    dosage  int not null,
    constraint solutions_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    check ((0 <= `dosage`) and (`dosage` <= 100))
);

create table if not exists storage_items
(
    id               int auto_increment
        primary key,
    drug_id          int      not null,
    available_amount int      not null,
    original_amount  int      not null,
    receipt_datetime datetime not null,
    constraint storage_items_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    check (`original_amount` > 0),
    check (`available_amount` >= 0)
);

create table if not exists reserved_drugs
(
    order_id        int not null,
    storage_item_id int not null,
    drug_amount     int not null,
    primary key (order_id, storage_item_id),
    constraint reserved_drugs_orders_id_fk
        foreign key (order_id) references orders (id),
    constraint reserved_drugs_storage_items_id_fk
        foreign key (storage_item_id) references storage_items (id),
    check (`drug_amount` > 0)
);

create definer = llirik42@`%` trigger remove_reserved_drug_from_storage
    before insert
    on reserved_drugs
    for each row
BEGIN
    select storage_items.available_amount into @available_amount
    from storage_items
    where storage_items.id = NEW.storage_item_id;

    if (@available_amount < NEW.drug_amount) THEN
        call raise_error('Cannot reserve drugs');
    end if;

    update storage_items
    set available_amount = available_amount - NEW.drug_amount
    where storage_items.id = NEW.storage_item_id;
end;

create table if not exists suppliers
(
    id           int auto_increment
        primary key,
    name         text not null,
    phone_number text not null
);

create definer = llirik42@`%` trigger check_valid_supplier_phone_number_insert
    before insert
    on suppliers
    for each row
BEGIN
    call check_phone_number(NEW.phone_number);
end;

create definer = llirik42@`%` trigger check_valid_supplier_phone_number_update
    before update
    on suppliers
    for each row
BEGIN
    call check_phone_number(NEW.phone_number);
end;

create table if not exists supplies
(
    id                int auto_increment
        primary key,
    drug_id           int      not null,
    drug_amount       int      not null,
    cost              int      not null,
    assigned_datetime datetime not null,
    delivery_datetime datetime null,
    supplier_id       int      not null,
    constraint supplies_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    constraint supplies_suppliers_id_fk
        foreign key (supplier_id) references suppliers (id),
    check (`drug_amount` > 0),
    check (`cost` >= 0)
);

create table if not exists technologies
(
    id           int auto_increment
        primary key,
    drug_id      int  not null,
    cooking_time time not null,
    amount       int  not null,
    description  text not null,
    constraint technologies_drugs_id_fk
        foreign key (drug_id) references drugs (id),
    check (`amount` > 0)
);

create table if not exists production
(
    id            int auto_increment
        primary key,
    order_id      int      not null,
    technology_id int      not null,
    drug_amount   int      not null,
    start         datetime null,
    end           datetime null,
    constraint production_orders_id_fk
        foreign key (order_id) references orders (id),
    constraint production_technologies_id_fk
        foreign key (technology_id) references technologies (id),
    constraint drug
        check (`drug_amount` > 0),
    check (((`start` is null) and (`end` is null)) or (`end` is null) or (`end` >= `start`))
);

create definer = llirik42@`%` trigger add_produced_drug
    after update
    on production
    for each row
BEGIN
    if (NEW.end is not null) THEN
        # If everything is OK, create record in storage
        select drug_id into @drug_id from technologies where technologies.id = NEW.technology_id;
        INSERT INTO storage_items (drug_id, available_amount, original_amount, receipt_datetime) VALUES (@drug_id, NEW.drug_amount, NEW.drug_amount, now());
    end if;
end;

create definer = llirik42@`%` trigger check_production_insert
    before insert
    on production
    for each row
BEGIN
    call check_production(NEW.id, NEW.start, NEW.end);
    call check_order_waiting_production(NEW.order_id, NEW.id);
end;

create definer = llirik42@`%` trigger check_production_update
    before update
    on production
    for each row
BEGIN
    call check_production(NEW.id, NEW.start, NEW.end);
    call check_order_waiting_production(NEW.order_id, NEW.id);
end;

create definer = llirik42@`%` trigger remove_production_component_from_storage
    after insert
    on production
    for each row
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE required_component_amount INT DEFAULT 0;
    DECLARE component_amount INT DEFAULT 0;
    DECLARE component_id INT DEFAULT 0;
    DECLARE item_id INT DEFAULT 0;
    DECLARE available_item_drug_amount INT DEFAULT 0;
    DECLARE storage_drug_id INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        select technology_components.component_id, technology_components.component_amount
        from technology_components
        where technology_components.technology_id = NEW.technology_id;

    DECLARE storage_cur CURSOR FOR
        select storage_items.id, storage_items.available_amount, storage_items.drug_id
        from storage_items;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    # Check whether there are all available components
    read_loop: LOOP
        FETCH cur INTO component_id, component_amount;

        IF done THEN
            LEAVE read_loop;
        END IF;

        set required_component_amount = component_amount * NEW.drug_amount;

        if (select sum(available_amount) from storage_items where drug_id = component_id) < required_component_amount THEN
            call raise_error('Not enough components in storage');
        end if;
    END LOOP;

    CLOSE cur;

    # Reopen cursor to actually remove from storage
    OPEN cur;
    SET done = false;

    read_loop: LOOP
        FETCH cur INTO component_id, component_amount;

        IF done THEN
            LEAVE read_loop;
        END IF;

        set required_component_amount = component_amount * NEW.drug_amount;

        # Remove drug from storage items
        open storage_cur;
        read_storage_loop: LOOP
            FETCH storage_cur INTO item_id, available_item_drug_amount, storage_drug_id;

            IF done THEN
                LEAVE read_storage_loop;
            END IF;

            if required_component_amount >= available_item_drug_amount and storage_drug_id = component_id THEN
                UPDATE storage_items
                SET available_amount = 0
                WHERE storage_items.id = item_id;
                SET required_component_amount = required_component_amount - available_item_drug_amount;
            end if;

            if required_component_amount < available_item_drug_amount and storage_drug_id = component_id THEN
                UPDATE storage_items
                SET available_amount = available_amount - required_component_amount
                WHERE storage_items.id = item_id;
                LEAVE read_storage_loop;
            end if;
        END LOOP;
        close storage_cur;

        # Reset done after using it in nested cursor
        SET done = false;
    END LOOP;
end;

create table if not exists production_lab_workers
(
    production_id int not null,
    lab_worker_id int not null,
    constraint production_lab_workers_lab_workers_id_fk
        foreign key (lab_worker_id) references lab_workers (id),
    constraint production_lab_workers_production_id_fk
        foreign key (production_id) references production (id)
);

create definer = llirik42@`%` trigger check_production_lab_workers_delete
    before delete
    on production_lab_workers
    for each row
BEGIN
        select start into @production_start from production where id = OLD.production_id;
        call check_production_lab_workers(OLD.production_id, @production_start);
end;

create definer = llirik42@`%` trigger check_production_lab_workers_update
    before update
    on production_lab_workers
    for each row
BEGIN
        select start into @production_start from production where id = NEW.production_id;
        call check_production_lab_workers(NEW.production_id, @production_start);
end;

create definer = llirik42@`%` trigger check_drug_is_cookable_insert
    before insert
    on technologies
    for each row
BEGIN
    call check_drug_is_cookable(NEW.drug_id);
end;

create definer = llirik42@`%` trigger check_drug_is_cookable_update
    before update
    on technologies
    for each row
BEGIN
    call check_drug_is_cookable(NEW.drug_id);
end;

create table if not exists technology_components
(
    technology_id    int not null,
    component_id     int not null,
    component_amount int not null,
    primary key (component_id, technology_id),
    constraint technology_components_drugs_id_fk
        foreign key (component_id) references drugs (id),
    constraint technology_components_technologies_id_fk
        foreign key (technology_id) references technologies (id),
    constraint positive_component_amount_check
        check (`component_amount` > 0)
);

create table if not exists tinctures
(
    drug_id  int  not null
        primary key,
    material text not null,
    constraint tinctures_drugs_id_fk
        foreign key (drug_id) references drugs (id)
);

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
    definer = llirik42@`%` procedure check_production(IN id int, IN start datetime, IN end datetime)
BEGIN
    call check_production_start_end(start, end);
    call check_production_lab_workers(id, start);
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
    definer = llirik42@`%` procedure raise_error(IN message text)
BEGIN
        SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = message;
END;
