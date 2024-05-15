create trigger check_valid_customer_phone_number_update
    before update
    on customers
    for each row
begin
    call check_phone_number(new.phone_number);
end;
