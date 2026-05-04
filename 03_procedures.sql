USE it_department;

-- Процедура для пошуку студента за ПІБ

DELIMITER //
CREATE PROCEDURE sp_SearchStudent(IN p_search_name VARCHAR(255))
BEGIN
    SELECT 		
        sc.id AS student_card_id, 
        sc.full_name AS "ПІБ Студента", 
        ss.status_name AS "Статус"
    FROM student_cards sc
    JOIN student_statuses ss ON sc.status_id = ss.id
    -- шукаємо частковий збіг (наприклад, "Іван" знайде "Іваненко")
    WHERE full_name LIKE CONCAT('%', p_search_name, '%') COLLATE utf8mb4_unicode_ci;
END //
DELIMITER ;

-- Триггер для відстеження змін у картці студента (для аудиту)
DELIMITER //

CREATE TRIGGER trg_student_cards_after_update
AFTER UPDATE ON student_cards
FOR EACH ROW
BEGIN

    -- ==========================================
    -- 1. ОСОБИСТІ ДАНІ
    -- ==========================================

    IF NOT (OLD.full_name <=> NEW.full_name) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'full_name', OLD.full_name, NEW.full_name, USER());
    END IF;

    IF NOT (OLD.passport_series <=> NEW.passport_series) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'passport_series', OLD.passport_series, NEW.passport_series, USER());
    END IF;

    IF NOT (OLD.passport_number <=> NEW.passport_number) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'passport_number', OLD.passport_number, NEW.passport_number, USER());
    END IF;

    IF NOT (OLD.passport_code <=> NEW.passport_code) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'passport_code', OLD.passport_code, NEW.passport_code, USER());
    END IF;

    IF NOT (OLD.address <=> NEW.address) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'address', OLD.address, NEW.address, USER());
    END IF;

    IF NOT (OLD.phone_number <=> NEW.phone_number) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'phone_number', OLD.phone_number, NEW.phone_number, USER());
    END IF;

    IF NOT (OLD.identify_number <=> NEW.identify_number) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'identify_number', OLD.identify_number, NEW.identify_number, USER());
    END IF;

    IF NOT (OLD.birthday <=> NEW.birthday) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'birthday', OLD.birthday, NEW.birthday, USER());
    END IF;

    IF NOT (OLD.email <=> NEW.email) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'email', OLD.email, NEW.email, USER());
    END IF;

    IF NOT (OLD.gender_id <=> NEW.gender_id) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'gender_id', OLD.gender_id, NEW.gender_id, USER());
    END IF;

    -- ==========================================
    -- 2. НАВЧАЛЬНІ ТА ОРГАНІЗАЦІЙНІ ДАНІ
    -- ==========================================

    IF NOT (OLD.funding_form_id <=> NEW.funding_form_id) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'funding_form_id', OLD.funding_form_id, NEW.funding_form_id, USER());
    END IF;

    IF NOT (OLD.study_level_id <=> NEW.study_level_id) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'study_level_id', OLD.study_level_id, NEW.study_level_id, USER());
    END IF;

    IF NOT (OLD.study_program_id <=> NEW.study_program_id) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'study_program_id', OLD.study_program_id, NEW.study_program_id, USER());
    END IF;

    IF NOT (OLD.study_form_id <=> NEW.study_form_id) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'study_form_id', OLD.study_form_id, NEW.study_form_id, USER());
    END IF;

    IF NOT (OLD.admission_reason_id <=> NEW.admission_reason_id) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'admission_reason_id', OLD.admission_reason_id, NEW.admission_reason_id, USER());
    END IF;

    IF NOT (OLD.status_id <=> NEW.status_id) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'status_id', OLD.status_id, NEW.status_id, USER());
    END IF;

    IF NOT (OLD.gapYearStartDate <=> NEW.gapYearStartDate) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'gapYearStartDate', OLD.gapYearStartDate, NEW.gapYearStartDate, USER());
    END IF;

    IF NOT (OLD.gapYearEndDate <=> NEW.gapYearEndDate) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        VALUES (NEW.id, 'UPDATE', 'gapYearEndDate', OLD.gapYearEndDate, NEW.gapYearEndDate, USER());
    END IF;

    -- ==========================================
    -- 3. ІНШЕ
    -- ==========================================

    IF NOT (OLD.additional_info <=> NEW.additional_info) THEN
        INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user)
        -- Обрізаємо TEXT до 255 символів, щоб не було помилки переповнення поля VARCHAR(255) у таблиці історії
        VALUES (NEW.id, 'UPDATE', 'additional_info', SUBSTRING(OLD.additional_info, 1, 255), SUBSTRING(NEW.additional_info, 1, 255), USER());
    END IF;

END //

DELIMITER ;

