create trigger drug_types_administration_routes_trigger_delete
    before delete
    on drug_types_administration_routes
    for each row
begin
    call check_no_drugs_with_type_and_route_in_prescription(old.type_id, old.route_id);
end;
