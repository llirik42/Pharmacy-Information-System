create
    definer = llirik42@`%` procedure check_no_technologies_for_drug_type(in drug_type_id int)
begin
    if (select count(*)
        from drugs join technologies on drugs.id = technologies.drug_id
        where type_id = drug_type_id) > 0 then
            call raise_error('there are cooking-technologies for drugs with this drug-type');
    end if;
end;
