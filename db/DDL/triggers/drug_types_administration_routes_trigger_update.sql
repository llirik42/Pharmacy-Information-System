create trigger drug_types_administration_routes_trigger_update
    before update
    on drug_types_administration_routes
    for each row
begin
    call check_no_drugs_with_type_and_route_in_prescription(new.type_id, new.route_id);
end;
