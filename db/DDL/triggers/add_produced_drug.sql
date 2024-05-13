create definer = llirik42@`%` trigger add_produced_drug
    after update
    on production
    for each row
begin
    if (new.end is not null) then
        # if everything is ok, create record in storage
        select drug_id into @drug_id from technologies where technologies.id = new.technology_id;
        insert into storage_items (drug_id, available_amount, original_amount, receipt_datetime) values (@drug_id, new.drug_amount, new.drug_amount, now());
    end if;
end;
