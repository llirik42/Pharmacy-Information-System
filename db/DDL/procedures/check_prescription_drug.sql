create
    definer = llirik42@`%` procedure check_prescription_drug(in drug_id int, in administration_route_id int)
begin
    if (select count(*)
        from drugs join drug_types_administration_routes dtar on drugs.type_id = dtar.type_id
        where drug_id = drugs.id and dtar.route_id = administration_route_id) = 0 then
            call raise_error('invalid administration route for drug');
    end if;
end;
