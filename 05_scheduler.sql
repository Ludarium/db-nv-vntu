USE it_department;
SET GLOBAL event_scheduler = ON;
-- Автоматична зміна статусу студента коли настає дата завершення навчання
CREATE EVENT update_student_status_daily
ON SCHEDULE EVERY 1 DAY STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY)
DO
    UPDATE student_cards sc
    JOIN contracts c ON sc.id = c.student_card_id
    SET sc.status_id = 3
    WHERE c.ending_date <= CURDATE() 
      AND sc.status_id = 1;
      
