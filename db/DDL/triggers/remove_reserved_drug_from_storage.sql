create trigger remove_reserved_drug_from_storage
    before insert
    on reserved_drugs
    for each row
begin
    select storage_items.available_amount into @available_amount
    from storage_items
    where storage_items.id = new.storage_item_id;

    if (@available_amount < new.drug_amount) then
        call raise_error('cannot reserve drugs');
    end if;

    update storage_items
    set available_amount = available_amount - new.drug_amount
    where storage_items.id = new.storage_item_id;
end;
