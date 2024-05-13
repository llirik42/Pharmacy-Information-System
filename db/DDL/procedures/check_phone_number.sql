create
    definer = llirik42@`%` procedure check_phone_number(in phone_number text)
begin
    if (not (regexp_like(phone_number, '^\\+7-\\(9\\d\\d\\)-\\d\\d\\d-\\d\\d-\\d\\d$'))) then
        call raise_error('invalid phone number');
    end if;
end;
