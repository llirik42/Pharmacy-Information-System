create definer = llirik42@`%` trigger check_production_lab_workers_delete
    before delete
    on production_lab_workers
    for each row
begin
    select start into @production_start from production where id = old.production_id;
    call check_production_lab_workers(old.production_id, @production_start);
end;
