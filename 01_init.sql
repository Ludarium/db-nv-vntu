USE it_department;

-- access потребує id та поля last_updated
-- щоб запобігти конфлікту конкуренції

CREATE TABLE grants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    publisher VARCHAR(150) NOT NULL,
    title VARCHAR(255) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE faculties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_name VARCHAR(150) NOT NULL UNIQUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE specialties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    speciality_name VARCHAR(150) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE study_forms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    form_name VARCHAR(50) NOT NULL UNIQUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE admission_reasons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reason_name VARCHAR(150) NOT NULL UNIQUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE study_programs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_id INT NOT NULL,
    faculty_id INT NOT NULL,
    program_title VARCHAR(255) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_program_specialty 
        FOREIGN KEY (specialty_id) REFERENCES specialties(id) 
        ON DELETE RESTRICT,
        
    CONSTRAINT fk_program_faculty 
        FOREIGN KEY (faculty_id) REFERENCES faculties(id) 
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE study_levels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    level_name VARCHAR(50) NOT NULL UNIQUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE funding_forms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    form_name VARCHAR(50) NOT NULL UNIQUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Особисті дані
    full_name VARCHAR(150) NOT NULL,
    passport_series VARCHAR(10) DEFAULT NULL, -- NULL дозволено, оскільки ID-картки не мають серії
    passport_number VARCHAR(20) NOT NULL,     -- VARCHAR зберігає нулі на початку
    passport_code VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(30) NOT NULL,
    identify_number VARCHAR(20) NOT NULL UNIQUE, -- VARCHAR для нулів + перевірка на унікальність
    birthday DATE NOT NULL,                      -- Правильний формат дати (YYYY-MM-DD)
    email VARCHAR(150) UNIQUE,
    gender_id INT NOT NULL,
    
    -- Навчальні та організаційні дані
    funding_form_id INT NOT NULL,
    study_level_id INT NOT NULL,
    study_program_id INT NOT NULL,
    study_form_id INT NOT NULL,
    admission_reason_id INT NOT NULL,
    status_id INT NOT NULL,
    gapYearStartDate DATE NULL,
    gapYearEndDate DATE NULL,
    
    additional_info TEXT,
    
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Захист від видалення довідників
    CONSTRAINT fk_card_funding 
        FOREIGN KEY (funding_form_id) REFERENCES funding_forms(id) ON DELETE RESTRICT,
    CONSTRAINT fk_card_level 
        FOREIGN KEY (study_level_id) REFERENCES study_levels(id) ON DELETE RESTRICT,
    CONSTRAINT fk_card_program 
        FOREIGN KEY (study_program_id) REFERENCES study_programs(id) ON DELETE RESTRICT,
    CONSTRAINT fk_card_study_form 
        FOREIGN KEY (study_form_id) REFERENCES study_forms(id) ON DELETE RESTRICT,
    CONSTRAINT fk_card_reason 
        FOREIGN KEY (admission_reason_id) REFERENCES admission_reasons(id) ON DELETE RESTRICT,
    CONSTRAINT fk_card_status 
        FOREIGN KEY (status_id) REFERENCES student_statuses(id) ON DELETE RESTRICT,
	CONSTRAINT fk_student_gender 
		FOREIGN KEY (gender_id) REFERENCES genders(id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE contracting_entities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    passport_series VARCHAR(10) DEFAULT NULL,
    passport_number VARCHAR(20) NOT NULL,
    passport_code VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(30) NOT NULL,
    identify_number VARCHAR(20) NOT NULL, 
    email VARCHAR(150),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE contracts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_card_id INT NOT NULL,
    contract_number VARCHAR(30) NOT NULL,
    contracting_entity_id INT DEFAULT NULL, -- якщо студент = замовник, тоді залишаємо NULL
    signing_date DATE NOT NULL,
    ending_date DATE NOT NULL, -- access при обробці форми буде сам пропонувати дату через 4 роки

    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_contract_student 
        FOREIGN KEY (student_card_id) REFERENCES student_cards(id) 
        ON DELETE CASCADE, -- якщо видалити картку студента, договір видалиться автоматично?

    CONSTRAINT fk_contract_entity 
        FOREIGN KEY (contracting_entity_id) REFERENCES contracting_entities(id) 
        ON DELETE RESTRICT -- не можна видалити замовника, поки на нього посилається договір

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_grants (
    id INT AUTO_INCREMENT PRIMARY KEY,

    student_card_id INT NOT NULL,
    grant_id INT NOT NULL,
    
    -- один студент не може отримати той самий грант двічі 
    UNIQUE KEY unique_grant_assignment (student_card_id, grant_id),
    
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_sg_student 
        FOREIGN KEY (student_card_id) REFERENCES student_cards(id) 
        ON DELETE CASCADE, -- якщо видаляємо студента, інформація про його гранти теж зникає
        
    CONSTRAINT fk_sg_grant 
        FOREIGN KEY (grant_id) REFERENCES grants(id) 
        ON DELETE RESTRICT -- не даємо видалити грант з довідника, якщо його вже хтось отримує

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vouchers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    publisher VARCHAR(150) NOT NULL,
    title VARCHAR(255) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_vouchers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_card_id INT NOT NULL,
    voucher_id INT NOT NULL,
    UNIQUE KEY unique_voucher_assignment (student_card_id, voucher_id),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_sv_student 
        FOREIGN KEY (student_card_id) REFERENCES student_cards(id) 
        ON DELETE CASCADE, 
    CONSTRAINT fk_sv_voucher 
        FOREIGN KEY (voucher_id) REFERENCES vouchers(id) 
        ON DELETE RESTRICT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    study_program_id INT NOT NULL UNIQUE, 
    -- DECIMAL(10, 2) дозволяє зберігати числа до 99 999 999.99
    full_time_price DECIMAL(10, 2) NOT NULL,
    part_time_price DECIMAL(10, 2) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_price_program 
        FOREIGN KEY (study_program_id) REFERENCES study_programs(id) 
        ON DELETE CASCADE 
        -- якщо видалити програму, ціна на неї автоматично видалиться
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE genders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    gender_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_cards_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_card_id INT NOT NULL,
    action_type VARCHAR(10) NOT NULL,
    changed_field VARCHAR(50) NOT NULL,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    app_user VARCHAR(100) NOT NULL, 
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE student_cards_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_card_id INT NOT NULL,
    changed_field VARCHAR(50) NOT NULL, -- Наприклад, 'status_id' або 'funding_form_id'
    old_value VARCHAR(255),             -- Значення ДО наказу
    new_value VARCHAR(255),             -- Значення ПІСЛЯ наказу
    order_number VARCHAR(50) NOT NULL,  -- Номер наказу
    order_date DATE NOT NULL,           -- Дата наказу
    agreement_number VARCHAR(50),       -- Номер додаткової угоди (може бути порожнім)
    agreement_date DATE,                -- Дата додаткової угоди (може бути порожнім)
    app_user VARCHAR(100) NOT NULL,     -- Логін оператора (наприклад, emp_olena@%)
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);