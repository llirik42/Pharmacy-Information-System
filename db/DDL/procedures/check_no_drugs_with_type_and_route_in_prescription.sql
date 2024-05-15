create procedure check_no_drugs_with_type_and_route_in_prescription(in drug_type_id int, in route_id int)
begin
    if (select count(*)
        from prescriptions_content join drugs on drugs.type_id = drug_type_id
        where prescriptions_content.administration_route_id = route_id) > 0 then
            call raise_error('there are prescriptions with drug type and administration route');
    end if;
end;
