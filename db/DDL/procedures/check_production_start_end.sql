create procedure check_production_start_end(in start datetime, in end datetime)
begin
    if (end is not null and (start is null or start >= end)) then
        call raise_error('invalid start datetime');
    end if;
end;
