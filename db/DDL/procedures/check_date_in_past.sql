create procedure check_date_in_past(in some_date datetime)
begin
    if (some_date > now()) then
        call raise_error('invalid date');
    end if;
end;
