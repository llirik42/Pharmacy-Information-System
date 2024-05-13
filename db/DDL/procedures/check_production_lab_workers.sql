create
    definer = llirik42@`%` procedure check_production_lab_workers(in id int, in start datetime)
begin
    if (select count(*) from production_lab_workers where production_lab_workers.production_id = id) = 0
            and start is not null then
        call raise_error('production must have at least one lab worker');
    end if;
end;
