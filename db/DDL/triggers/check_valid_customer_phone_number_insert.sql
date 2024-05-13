create definer = llirik42@`%` trigger check_valid_customer_phone_number_insert
    before insert
    on customers
    for each row
begin
    call check_phone_number(new.phone_number);
end;
