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


create definer = llirik42@`%` trigger check_no_techs_for_not_cookable
    before update
    on drug_types
    for each row
BEGIN
    call check_no_technologies_for_drug_type(NEW.id);
end;

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
    before insert
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

            if required_component_amount > available_item_drug_amount and storage_drug_id = component_id THEN
                UPDATE storage_items
                SET available_amount = 0
                WHERE storage_items.id = item_id;
                SET required_component_amount = required_component_amount - available_item_drug_amount;
            end if;

            if required_component_amount <= available_item_drug_amount and storage_drug_id = component_id THEN
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
