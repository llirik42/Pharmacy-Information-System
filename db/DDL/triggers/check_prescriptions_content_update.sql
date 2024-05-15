create trigger check_prescriptions_content_update
    before update
    on prescriptions_content
    for each row
begin
    call check_prescription_drug(new.drug_id, new.administration_route_id);
end;
