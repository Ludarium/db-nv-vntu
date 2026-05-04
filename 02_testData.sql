USE it_department;
-- Тестові ролі
CREATE ROLE 'admin', 'operator';
GRANT SELECT, INSERT, UPDATE ON it_department.* TO 'operator';
-- Забороняємо операторам видаляти або змінювати історію аудіту
-- REVOKE UPDATE, DELETE ON it_department.student_cards_history FROM 'operator';
-- 2. Права для ролі "Адміністратор"
-- Повний доступ до всіх таблиць бази даних (включно з журналом подій)
GRANT ALL PRIVILEGES ON it_department.* TO 'admin';

-- Глобальні права адміністратора (створення користувачів, бекапи)
-- RELOAD потрібен для роботи утиліт резервного копіювання (mysqldump)
GRANT CREATE USER, ROLE_ADMIN, RELOAD ON *.* TO 'admin';

-- Створюємо трьох співробітників
CREATE USER 'emp_olga'@'%' IDENTIFIED BY '123';
CREATE USER 'emp_olena'@'%'  IDENTIFIED BY '123';
CREATE USER 'emp_lyudmila'@'%'  IDENTIFIED BY '123';

-- Створюємо адміністратора системи
CREATE USER 'sys_admin'@'%' IDENTIFIED BY '777';

-- Роздаємо ролі 
GRANT 'operator' TO 'emp_olena'@'%', 'emp_olga'@'%', 'emp_lyudmila'@'%';
GRANT 'admin' TO 'sys_admin'@'%';

SET DEFAULT ROLE 'operator' TO 'emp_olena'@'%', 'emp_olga'@'%', 'emp_lyudmila'@'%';
SET DEFAULT ROLE 'admin' TO 'sys_admin'@'%';

FLUSH PRIVILEGES;

-- ==============================================================================
-- 1. ЗАПОВНЕННЯ БАЗОВИХ ДОВІДНИКІВ
-- ==============================================================================

INSERT INTO genders (gender_name) VALUES 
('Чоловіча'), 
('Жіноча');

INSERT INTO faculties (faculty_name) VALUES 
('ФІТКІ'),
('ФЕЕЕМ'),
('ФІМЕН');

INSERT INTO specialties (speciality_name) VALUES 
('F2 Інженерія програмного забезпечення'),
('F3 Комп''ютерні науки'),
('F7 Комп''ютерна інженерія'),
('G22 Біомедична інженерія');

INSERT INTO student_statuses (status_name) VALUES 
('Навчається'), 
('Відрахований'),  
('Випускник');

INSERT INTO study_forms (form_name) VALUES 
('Денна'), 
('Заочна'), 
('Дуальна');

INSERT INTO admission_reasons (reason_name) VALUES 
('ПЗСО'), 
('Поновлення'), 
('НРК-5'),
('НРК-6');

INSERT INTO study_levels (level_name) VALUES 
('Бакалавр'),
('Молодший спеціаліст'), 
('Магістр'), 
('Доктор філософії');

INSERT INTO funding_forms (form_name) VALUES 
('Бюджет'), 
('Контракт');

INSERT INTO grants (publisher, title) VALUES 
('Міністерство освіти і науки України', 'Державний грант для ІТ-спеціальностей (Рівень 1)'),
('Міністерство освіти і науки України', 'Державний грант для ІТ-спеціальностей (Рівень 2)'),
('Вінницька міська рада', 'Стипендія міського голови для обдарованої молоді');

INSERT INTO vouchers (publisher, title) VALUES 
('Державний центр зайнятості', 'Ваучер на навчання для ВПО'),
('Державний центр зайнятості', 'Ваучер на навчання для учасників бойових дій');

-- ==============================================================================
-- 2. ПРОМІЖНІ ТАБЛИЦІ (Програми, Ціни, Замовники)
-- ==============================================================================

-- Освітні програми (прив'язуємо спеціальності до факультетів)
INSERT INTO study_programs (specialty_id, faculty_id, program_title) VALUES 
(1, 1, 'Інженерія програмного забезпечення'), -- id 1
(2, 1, 'Комп''ютерні науки'),                 -- id 2
(3, 1, 'Системне програмування'),            -- id 3
(4, 2, 'Електромеханічні системи');          -- id 4

-- Ціни на навчання за програмами (у гривнях)
INSERT INTO prices (study_program_id, full_time_price, part_time_price) VALUES 
(1, 35000.00, 18000.00), -- ІПЗ
(2, 32000.00, 17000.00), -- КН
(3, 30000.00, 16000.00), -- КІ
(4, 25000.00, 12000.00); -- ЕЕЕМ

-- Замовники для контрактників (батьки або підприємства)
INSERT INTO contracting_entities (full_name, passport_series, passport_number, passport_code, address, phone_number, identify_number, email) VALUES 
('ТОВ "Вінниця-ІТ-Консалтинг"', NULL, '123456789', 'ЄДРПОУ', 'м. Вінниця, вул. Келецька, 51', '+380432555555', '32165498', 'info@vin-it.com'),
('Коваленко Іван Петрович', 'АВ', '123456', '0512', 'м. Жмеринка, вул. Київська, 12', '+380671112233', '2912345678', 'kovalenko.p@email.com');

-- ==============================================================================
-- 3. ГОЛОВНА ТАБЛИЦЯ: СТУДЕНТИ
-- ==============================================================================

INSERT INTO student_cards (
    full_name, passport_series, passport_number, passport_code, address, phone_number, identify_number, birthday, email, gender_id,
    funding_form_id, study_level_id, study_program_id, study_form_id, admission_reason_id, status_id, gapYearStartDate, gapYearEndDate, additional_info
) VALUES 
-- 1. Студент Бюджетник, отримує грант (ID-картка, серії немає)
('Шевченко Тарас Олегович', NULL, '001122334', '1234', 'м. Вінниця, Хмельницьке шосе, гуртожиток 1', '+380631234567', '3100012345', '2005-04-15', 'shev.t@vntu.edu.ua', 1,
1, 1, 1, 1, 1, 1, NULL, NULL, 'Староста групи 1ПІ-23б'),

-- 2. Студентка Контрактниця (Є договір з батьком, старий паспорт серії АВ)
('Коваленко Олена Іванівна', 'АВ', '654321', '0512', 'м. Вінниця, вул. Соборна, 45, кв. 12', '+380979876543', '3200054321', '2004-11-22', 'koval.o@vntu.edu.ua', 2,
2, 1, 2, 1, 1, 1, NULL, NULL, 'Потребує посиленої уваги до оплати контракту'),

-- 3. Заочник, навчається за ваучером
('Мельник Андрій Васильович', NULL, '009988776', '5678', 'м. Бар, вул. Героїв, 7', '+380505556677', '3055566778', '1998-02-10', 'melnyk.a@vntu.edu.ua', 1,
2, 2, 3, 2, 1, 1, NULL, NULL, 'Навчання оплачується через Центр зайнятості'),

-- 4. Студент в академвідпустці
('Бойко Софія Миколаївна', 'ВВ', '112233', '0522', 'м. Вінниця, вул. Юзвинська, 10', '+380731112233', '3311122233', '2003-08-05', 'boyko.s@vntu.edu.ua', 2,
1, 1, 1, 1, 1, 3, '2025-09-01', '2026-09-01', 'Академвідпустка за станом здоров''я');

-- ==============================================================================
-- 4. ПОВ'ЯЗАНІ ДАНІ (Контракти, Гранти, Ваучери)
-- ==============================================================================

-- Контракти (Прив'язуємо студентку Олену до замовника-батька)
INSERT INTO contracts (student_card_id, contract_number, contracting_entity_id, signing_date, ending_date) VALUES 
(2, 'К-122-2023/45', 2, '2023-08-25', '2027-06-30');

-- Гранти (Прив'язуємо Тараса до двох грантів)
INSERT INTO student_grants (student_card_id, grant_id) VALUES 
(1, 1), -- Державний грант МОН
(1, 3); -- Стипендія мера

-- Ваучери (Прив'язуємо Андрія до ваучера ЦЗ)
INSERT INTO student_vouchers (student_card_id, voucher_id) VALUES 
(3, 2);

-- ==============================================================================
-- 5. ТЕСТОВІ ДАНІ ДЛЯ ЖУРНАЛІВ АУДИТУ ТА ІСТОРІЇ
-- ==============================================================================

-- Тихий аудит тригерів
INSERT INTO student_cards_history (student_card_id, action_type, changed_field, old_value, new_value, app_user, changed_at) VALUES 
(1, 'UPDATE', 'phone_number', '+380630000000', '+380631234567', 'emp_olena@localhost', '2025-10-15 10:00:00'),
(4, 'UPDATE', 'status_id', '1', '3', 'emp_ivan@localhost', '2025-08-20 14:30:00');

-- Офіційний аудит наказів (Те, що оператори вводять через форму)
INSERT INTO student_cards_audit (student_card_id, changed_field, old_value, new_value, order_number, order_date, agreement_number, agreement_date, app_user, changed_at) VALUES 
(2, 'funding_form_id', '1', '2', '45-С', '2024-01-15', 'Дод-1', '2024-01-16', 'emp_olena', '2024-01-16 11:20:00'),
(4, 'status_id', '1', '3', '112-АК', '2025-08-20', NULL, NULL, 'emp_ivan', '2025-08-20 14:35:00');
