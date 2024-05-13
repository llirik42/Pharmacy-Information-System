create definer = llirik42@`%` trigger patients_age_update
    before update
    on patients
    for each row
begin
    call check_date_in_past(new.birthday);
end;
