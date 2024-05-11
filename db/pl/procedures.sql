CREATE PROCEDURE IF NOT EXISTS check_production_lab_workers(IN id integer, IN start datetime)
    BEGIN
        IF (select count(*) from production_lab_workers where production_lab_workers.production_id = id) = 0
               AND start is not NULL THEN
            SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Production must have at least one lab worker';
        END IF;
    END;

CREATE PROCEDURE IF NOT EXISTS check_production_start_end(IN start datetime, IN end datetime)
    BEGIN
        IF (end is not null and (start is null or start > end)) THEN
            SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Invalid start datetime';
        END IF;
    END;
