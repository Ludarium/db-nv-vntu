USE it_department;

CREATE OR REPLACE VIEW view_student_year AS
SELECT 
    sc.id,
    sc.full_name,
    c.ending_date,
    CASE 
        WHEN c.ending_date < CURDATE() THEN 'Випускник'
        WHEN TIMESTAMPDIFF(YEAR, CURDATE(), c.ending_date) >= 3 THEN '1 курс'
        WHEN TIMESTAMPDIFF(YEAR, CURDATE(), c.ending_date) = 2 THEN '2 курс'
        WHEN TIMESTAMPDIFF(YEAR, CURDATE(), c.ending_date) = 1 THEN '3 курс'
        ELSE '4 курс'
    END AS current_course
FROM student_cards sc
JOIN contracts c ON sc.id = c.student_card_id;

CREATE OR REPLACE VIEW view_StudentsWithGrants AS
SELECT 
    sg.id AS grant_record_id,   
    sc.id AS student_card_id,
    sc.full_name AS "ПІБ Студента",
    g.title AS "Назва гранту",
    g.publisher AS "Організація"
FROM student_cards sc
JOIN student_grants sg ON sc.id = sg.student_card_id
JOIN grants g ON sg.grant_id = g.id;

CREATE OR REPLACE VIEW view_StudentsWithVouchers AS
SELECT 
    sc.id AS student_card_id,
    sc.full_name AS "ПІБ Студента",
    v.title AS "Назва ваучера",
    v.publisher AS "Видавник"
FROM student_cards sc
JOIN student_vouchers sv ON sc.id = sv.student_card_id
JOIN vouchers v ON sv.voucher_id = v.id;

CREATE OR REPLACE VIEW view_StudentsOnGapYear AS
SELECT 
    sc.id AS student_card_id,
    sc.full_name AS "ПІБ Студента",
    sc.gapYearStartDate AS "Дата початку відпустки"
FROM student_cards sc
WHERE sc.gapYearStartDate IS NOT NULL;


CREATE OR REPLACE VIEW view_student_audit_human AS
SELECT 
    a.id,
    a.student_card_id,
    -- 1. Переклад назв полів
    CASE a.changed_field
        WHEN 'status_id' THEN 'Статус'
        WHEN 'funding_form_id' THEN 'Форма фінансування'
        WHEN 'study_program_id' THEN 'Освітня програма'
        WHEN 'gender_id' THEN 'Стать'
        WHEN 'full_name' THEN 'ПІБ здобувача'
        WHEN 'passport_series' THEN 'Серія паспорта'
        WHEN 'passport_number' THEN 'Номер паспорта'
        WHEN 'passport_code' THEN 'Ким виданий (Код)'
        WHEN 'identify_number' THEN 'Ідентифікаційний код'
        WHEN 'address' THEN 'Адреса проживання'
        WHEN 'phone_number' THEN 'Номер телефону'
        WHEN 'email' THEN 'Електронна пошта'
        WHEN 'gapYearStartDate' THEN 'Початок академвідпустки'
        WHEN 'gapYearEndDate' THEN 'Завершення академвідпустки'
        ELSE a.changed_field 
    END AS field_name_ua,
    
    -- 2. Розшифровка старого значення
    CASE a.changed_field
        WHEN 'status_id' THEN (SELECT status_name FROM student_statuses WHERE id = a.old_value)
        WHEN 'funding_form_id' THEN (SELECT form_name FROM funding_forms WHERE id = a.old_value)
        WHEN 'study_program_id' THEN (SELECT program_title FROM study_programs WHERE id = a.old_value)
        WHEN 'gender_id' THEN (SELECT gender_name FROM genders WHERE id = a.old_value)
        ELSE a.old_value 
    END AS old_val_ua,

    -- 3. Розшифровка нового значення
    CASE a.changed_field
        WHEN 'status_id' THEN (SELECT status_name FROM student_statuses WHERE id = a.new_value)
        WHEN 'funding_form_id' THEN (SELECT form_name FROM funding_forms WHERE id = a.new_value)
        WHEN 'study_program_id' THEN (SELECT program_title FROM study_programs WHERE id = a.new_value)
        WHEN 'gender_id' THEN (SELECT gender_name FROM genders WHERE id = a.new_value)
        ELSE a.new_value 
    END AS new_val_ua,
    
    a.order_number,
    a.order_date,
    a.agreement_number, 
    a.agreement_date,  
    a.app_user,
    a.changed_at
FROM student_cards_audit a;