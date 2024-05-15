create trigger check_drug_is_cookable_insert
    before insert
    on technologies
    for each row
begin
    call check_drug_is_cookable(new.drug_id);
end;
