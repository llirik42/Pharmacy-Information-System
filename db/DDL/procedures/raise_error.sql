create
    definer = llirik42@`%` procedure raise_error(in message text)
begin
    signal sqlstate '50001' set message_text = message;
end;
