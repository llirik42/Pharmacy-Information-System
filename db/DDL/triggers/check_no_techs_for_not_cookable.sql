create definer = llirik42@`%` trigger check_no_techs_for_not_cookable
    before update
    on drug_types
    for each row
begin
    call check_no_technologies_for_drug_type(new.id);
end;
