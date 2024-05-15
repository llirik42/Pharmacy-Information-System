create trigger check_production_insert
    before insert
    on production
    for each row
begin
    call check_production(new.id, new.start, new.end);
    call check_order_waiting_production(new.order_id, new.id);
end;
