create trigger check_production_lab_workers_update
    before update
    on production_lab_workers
    for each row
begin
    select start into @production_start from production where id = new.production_id;
    call check_production_lab_workers(new.production_id, @production_start);
end;
