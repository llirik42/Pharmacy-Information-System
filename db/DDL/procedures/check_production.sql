create procedure check_production(in id int, in start datetime, in end datetime)
begin
    call check_production_start_end(start, end);
    call check_production_lab_workers(id, start);
end;
