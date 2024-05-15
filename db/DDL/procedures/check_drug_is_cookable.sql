create procedure check_drug_is_cookable(in drug_id int)
begin
    select dt.cookable into @is_cookable
    from drugs join drug_types dt on drugs.type_id = dt.id
    where drugs.id = drug_id;

    if (not @is_cookable) then
        call raise_error('drug is not cookable');
    end if;
end;
