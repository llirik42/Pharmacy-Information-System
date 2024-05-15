create procedure check_order_requires_drug(in order_id int, in drug_id int)
begin
    if not exists(select *
    from orders
        join prescriptions on orders.prescription_id = prescriptions.id
        join prescriptions_content pc on prescriptions.id = pc.prescription_id and pc.drug_id = drug_id
    where orders.id = order_id) then
        call raise_error('the order does not require the drug');
    end if;
end;
