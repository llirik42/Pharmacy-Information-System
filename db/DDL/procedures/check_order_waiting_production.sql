create
    definer = llirik42@`%` procedure check_order_waiting_production(in order_id int, in production_id int)
begin
    select technologies.drug_id into @drug_id
    from production
        join technologies on production.technology_id = technologies.id
    where production.id = production_id;

    call check_order_requires_drug(order_id, @drug_id);
end;
