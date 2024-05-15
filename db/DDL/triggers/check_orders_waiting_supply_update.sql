create trigger check_orders_waiting_supply_update
    before update
    on orders_waiting_drug_supplies
    for each row
begin
    call check_order_requires_drug(new.order_id, new.drug_id);
end;
