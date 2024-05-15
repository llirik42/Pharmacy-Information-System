create trigger check_order_update
    before update
    on orders
    for each row
begin
    call check_order(new.id);
end;
