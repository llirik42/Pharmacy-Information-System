create definer = llirik42@`%` trigger remove_production_components_from_storage
    before insert
    on production
    for each row
begin
    declare done int default false;
    declare required_component_amount int default 0;
    declare component_amount int default 0;
    declare component_id int default 0;
    declare item_id int default 0;
    declare available_item_drug_amount int default 0;
    declare storage_drug_id int default 0;

    declare cur cursor for
        select technology_components.component_id, technology_components.component_amount
        from technology_components
        where technology_components.technology_id = new.technology_id;

    declare storage_cur cursor for
        select storage_items.id, storage_items.available_amount, storage_items.drug_id
        from storage_items;

    declare continue handler for not found set done = true;

    open cur;

    # check whether there are all available components
    read_loop: loop
        fetch cur into component_id, component_amount;

        if done then
            leave read_loop;
        end if;

        set required_component_amount = component_amount * new.drug_amount;

        if (select sum(available_amount) from storage_items where drug_id = component_id) < required_component_amount then
            call raise_error('not enough components in storage');
        end if;
    end loop;

    close cur;

    # reopen cursor to actually remove from storage
    open cur;
    set done = false;

    read_loop: loop
        fetch cur into component_id, component_amount;

        if done then
            leave read_loop;
        end if;

        set required_component_amount = component_amount * new.drug_amount;

        # remove drug from storage items
        open storage_cur;
        read_storage_loop: loop
            fetch storage_cur into item_id, available_item_drug_amount, storage_drug_id;

            if done then
                leave read_storage_loop;
            end if;

            if required_component_amount > available_item_drug_amount and storage_drug_id = component_id then
                update storage_items
                set available_amount = 0
                where storage_items.id = item_id;
                set required_component_amount = required_component_amount - available_item_drug_amount;
            end if;

            if required_component_amount <= available_item_drug_amount and storage_drug_id = component_id then
                update storage_items
                set available_amount = available_amount - required_component_amount
                where storage_items.id = item_id;
                leave read_storage_loop;
            end if;
        end loop;
        close storage_cur;

        # reset done after using it in nested cursor
        set done = false;
    end loop;
end;
