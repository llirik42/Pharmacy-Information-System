create trigger check_valid_supplier_phone_number_update
    before update
    on suppliers
    for each row
begin
    call check_phone_number(new.phone_number);
end;
