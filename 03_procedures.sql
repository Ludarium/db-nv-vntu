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

DELIMITER //
DROP PROCEDURE IF EXISTS sp_ProcessExcelImport //
CREATE PROCEDURE sp_ProcessExcelImport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_error_msg TEXT;
    DECLARE v_row_error BOOLEAN DEFAULT FALSE;
    
    DECLARE v_import_id INT;
    DECLARE v_contract_num, v_contract_date, v_student_name, v_student_bday, v_student_ps, v_student_pn, v_student_pi, v_student_addr, v_student_inn, v_student_phone, v_student_email VARCHAR(255);
    DECLARE v_entity_name, v_entity_ps, v_entity_pn, v_entity_pi, v_entity_addr, v_entity_inn, v_entity_phone, v_entity_email VARCHAR(255);
    DECLARE v_study_form, v_study_level, v_specialty, v_study_program, v_funding_form, v_faculty VARCHAR(255);
    
    DECLARE v_study_form_id, v_study_level_id, v_study_program_id, v_funding_form_id INT;
    DECLARE v_student_id, v_entity_id INT;
    
    DECLARE cur CURSOR FOR 
        SELECT import_id, contract_number, contract_date, student_name, student_birthday, student_pass_series, student_pass_num, student_pass_issued, student_address, student_inn, student_phone, student_email, entity_name, entity_pass_series, entity_pass_num, entity_pass_issued, entity_address, entity_inn, entity_phone, entity_email, study_form, study_level, specialty, study_program, funding_form, faculty
        FROM import_staging_students 
        WHERE is_processed = FALSE;


    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET v_row_error = TRUE;
        UPDATE import_staging_students SET has_error = TRUE, error_message = CONCAT('Системна помилка БД: ', v_error_msg) WHERE import_id = v_import_id;
    END;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_import_id, v_contract_num, v_contract_date, v_student_name, v_student_bday, v_student_ps, v_student_pn, v_student_pi, v_student_addr, v_student_inn, v_student_phone, v_student_email, v_entity_name, v_entity_ps, v_entity_pn, v_entity_pi, v_entity_addr, v_entity_inn, v_entity_phone, v_entity_email, v_study_form, v_study_level, v_specialty, v_study_program, v_funding_form, v_faculty;
        
        IF done THEN 
            LEAVE read_loop; 
        END IF;

        SET v_row_error = FALSE;
        
        SET v_study_form = TRIM(REPLACE(REPLACE(v_study_form, '\r', ''), '\n', ''));
        SET v_study_form_id = (SELECT id FROM study_forms WHERE form_name = v_study_form COLLATE utf8mb4_unicode_ci LIMIT 1);
        IF v_study_form_id IS NULL THEN
            UPDATE import_staging_students SET has_error = TRUE, error_message = CONCAT('Довідник: не знайдено форму навчання "', v_study_form, '"') WHERE import_id = v_import_id;
            ITERATE read_loop; 
        END IF;

        SET v_study_level = TRIM(REPLACE(REPLACE(v_study_level, '\r', ''), '\n', ''));
        SET v_study_level_id = (SELECT id FROM study_levels WHERE level_name = v_study_level COLLATE utf8mb4_unicode_ci LIMIT 1);
        IF v_study_level_id IS NULL THEN
            UPDATE import_staging_students SET has_error = TRUE, error_message = CONCAT('Довідник: не знайдено рівень освіти "', v_study_level, '"') WHERE import_id = v_import_id;
            ITERATE read_loop; 
        END IF;

        SET v_funding_form = TRIM(REPLACE(REPLACE(v_funding_form, '\r', ''), '\n', ''));
        SET v_funding_form_id = (SELECT id FROM funding_forms WHERE form_name = v_funding_form COLLATE utf8mb4_unicode_ci LIMIT 1);
        IF v_funding_form_id IS NULL THEN
            UPDATE import_staging_students SET has_error = TRUE, error_message = CONCAT('Довідник: не знайдено форму фінансування "', v_funding_form, '"') WHERE import_id = v_import_id;
            ITERATE read_loop; 
        END IF;

        SET v_study_program = TRIM(REPLACE(REPLACE(v_study_program, '\r', ''), '\n', ''));
        SET v_study_program_id = (SELECT id FROM study_programs WHERE program_title = v_study_program COLLATE utf8mb4_unicode_ci LIMIT 1);
        IF v_study_program_id IS NULL THEN
            UPDATE import_staging_students SET has_error = TRUE, error_message = CONCAT('Довідник: не знайдено програму "', v_study_program, '"') WHERE import_id = v_import_id;
            ITERATE read_loop; 
        END IF;

	
        SET v_entity_id = NULL;
        IF v_entity_name IS NOT NULL AND TRIM(v_entity_name) != '' THEN
            SET v_entity_id = (SELECT id FROM contracting_entities WHERE identify_number = TRIM(v_entity_inn) COLLATE utf8mb4_unicode_ci LIMIT 1);
            IF v_entity_id IS NULL THEN
                INSERT INTO contracting_entities (full_name, passport_series, passport_number, passport_code, address, phone_number, identify_number, email)
                VALUES (v_entity_name, v_entity_ps, v_entity_pn, v_entity_pi, v_entity_addr, v_entity_inn, v_entity_phone, v_entity_email);
                SET v_entity_id = LAST_INSERT_ID();
            END IF;
        END IF;
        
        IF v_row_error THEN ITERATE read_loop; END IF;

        
        SET v_student_id = (SELECT id FROM student_cards WHERE identify_number = TRIM(v_student_inn) COLLATE utf8mb4_unicode_ci LIMIT 1);
        IF v_student_id IS NULL THEN
            INSERT INTO student_cards (
                full_name, passport_series, passport_number, passport_code, address, phone_number, identify_number, birthday, email, 
                gender_id, funding_form_id, study_level_id, study_program_id, study_form_id, admission_reason_id, status_id
            ) VALUES (
                v_student_name, v_student_ps, v_student_pn, v_student_pi, v_student_addr, v_student_phone, v_student_inn, 
                STR_TO_DATE(TRIM(v_student_bday), '%d.%m.%Y'), v_student_email,
                1, v_funding_form_id, v_study_level_id, v_study_program_id, v_study_form_id, 1, 1
            );
            SET v_student_id = LAST_INSERT_ID();
        END IF;

        IF v_row_error THEN ITERATE read_loop; END IF;

     
        IF v_contract_num IS NULL OR TRIM(v_contract_num) = '' THEN
            SET v_contract_num = CONCAT('№-', TRIM(v_student_inn));
        END IF;

        IF NOT EXISTS (SELECT 1 FROM contracts WHERE contract_number = v_contract_num COLLATE utf8mb4_unicode_ci) THEN
            INSERT INTO contracts (
                student_card_id, contract_number, contracting_entity_id, signing_date, ending_date
            ) VALUES (
                v_student_id, 
                v_contract_num, 
                v_entity_id, 
                STR_TO_DATE(TRIM(v_contract_date), '%d.%m.%Y'), 
                DATE_ADD(STR_TO_DATE(TRIM(v_contract_date), '%d.%m.%Y'), INTERVAL 4 YEAR)
            );
        END IF;

    
        IF NOT v_row_error THEN
            UPDATE import_staging_students 
            SET is_processed = TRUE, has_error = FALSE, error_message = 'Успішно' 
            WHERE import_id = v_import_id;
        END IF;

    END LOOP;
    CLOSE cur;
END //

DELIMITER ;
