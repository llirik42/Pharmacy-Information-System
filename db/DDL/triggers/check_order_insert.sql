create definer = llirik42@`%` trigger check_order_insert
    before insert
    on orders
    for each row
begin
    call check_order(new.id);
end;
