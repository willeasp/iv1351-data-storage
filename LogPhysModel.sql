CREATE TABLE instrument (
 instrument_id SERIAL NOT NULL,
 name VARCHAR(100),
 type VARCHAR(100)
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (instrument_id);


CREATE TABLE parent_contact_details (
 parent_id INT NOT NULL,
 email VARCHAR(500) NOT NULL,
 phone VARCHAR(30) NOT NULL
);

ALTER TABLE parent_contact_details ADD CONSTRAINT PK_parent_contact_details PRIMARY KEY (parent_id);


CREATE TABLE person (
 person_id SERIAL NOT NULL,
 person_number CHAR(12),
 first_name VARCHAR(500),
 last_name VARCHAR(500),
 phone VARCHAR(30),
 email VARCHAR(500),
 street_name VARCHAR(500),
 street_number VARCHAR(30),
 postal_code VARCHAR(500),
 city VARCHAR(500)
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (person_id);


CREATE TABLE school_data (
 school_id SERIAL NOT NULL,
 max_number_of_students INT,
 minimum_age INT
);

ALTER TABLE school_data ADD CONSTRAINT PK_school_data PRIMARY KEY (school_id);


CREATE TABLE student (
 student_id SERIAL NOT NULL,
 person_id SERIAL NOT NULL,
 monthly_charge DECIMAL(3),
 discount DECIMAL(3)
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (student_id);


CREATE TABLE student_instrument_skill (
 student_id SERIAL NOT NULL,
 instrument_id SERIAL NOT NULL,
 skill_level VARCHAR(500)
);

ALTER TABLE student_instrument_skill ADD CONSTRAINT PK_student_instrument_skill PRIMARY KEY (student_id,instrument_id);


CREATE TABLE student_parent (
 parent_id SERIAL NOT NULL,
 student_id SERIAL NOT NULL
);

ALTER TABLE student_parent ADD CONSTRAINT PK_student_parent PRIMARY KEY (parent_id,student_id);


CREATE TABLE application (
 application_id SERIAL NOT NULL,
 school_id SERIAL NOT NULL,
 date DATE NOT NULL,
 person_number CHAR(12) NOT NULL,
 first_name VARCHAR(500),
 last_name VARCHAR(500),
 phone VARCHAR(20),
 email VARCHAR(500),
 instrument VARCHAR(50),
 ensemble VARCHAR(500),
 skill VARCHAR(20) NOT NULL,
 sibling_person_number CHAR(12),
 accepted BOOLEAN,
 student_id SERIAL
);

ALTER TABLE application ADD CONSTRAINT PK_application PRIMARY KEY (application_id);


CREATE TABLE audition (
 audition_id SERIAL NOT NULL,
 application_id SERIAL NOT NULL,
 instrument VARCHAR(500),
 result VARCHAR(500),
 date DATE
);

ALTER TABLE audition ADD CONSTRAINT PK_audition PRIMARY KEY (audition_id,application_id);


CREATE TABLE days_of_extra_charge (
 school_id SERIAL NOT NULL,
 monday BOOLEAN,
 tuesday BOOLEAN,
 wednesday BOOLEAN,
 thursday BOOLEAN,
 friday BOOLEAN,
 saturday BOOLEAN,
 sunday BOOLEAN
);

ALTER TABLE days_of_extra_charge ADD CONSTRAINT PK_days_of_extra_charge PRIMARY KEY (school_id);


CREATE TABLE instructor (
 instructor_id SERIAL NOT NULL,
 school_id VARCHAR(500),
 person_id SERIAL NOT NULL,
 pay DOUBLE PRECISION,
 teaches_ensembles BOOLEAN
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (instructor_id);


CREATE TABLE instructor_availability (
 instructor_id SERIAL NOT NULL,
 start_time TIME(0),
 end_time TIME(0),
 date DATE
);

ALTER TABLE instructor_availability ADD CONSTRAINT PK_instructor_availability PRIMARY KEY (instructor_id);


CREATE TABLE instructor_instrument (
 instructor_id SERIAL NOT NULL,
 instrument_id SERIAL NOT NULL
);

ALTER TABLE instructor_instrument ADD CONSTRAINT PK_instructor_instrument PRIMARY KEY (instructor_id,instrument_id);


CREATE TABLE lesson_pricing (
 pricing_id SERIAL NOT NULL,
 type VARCHAR(30) NOT NULL,
 level VARCHAR(30) NOT NULL,
 student_price DECIMAL(3),
 instructor_pay DECIMAL(3),
 school_id SERIAL NOT NULL
);

ALTER TABLE lesson_pricing ADD CONSTRAINT PK_lesson_pricing PRIMARY KEY (pricing_id);


CREATE TABLE pricing_specification (
 school_id SERIAL NOT NULL,
 discount_amount DECIMAL(3),
 extra_charge DECIMAL(3)
);

ALTER TABLE pricing_specification ADD CONSTRAINT PK_pricing_specification PRIMARY KEY (school_id);


CREATE TABLE rental (
 rental_id SERIAL NOT NULL,
 start_date DATE,
 end_date DATE,
 student_id SERIAL NOT NULL
);

ALTER TABLE rental ADD CONSTRAINT PK_rental PRIMARY KEY (rental_id);


CREATE TABLE rental_instrument (
 ri_id SERIAL NOT NULL,
 name VARCHAR(500) NOT NULL,
 type VARCHAR(500) NOT NULL,
 brand VARCHAR(500),
 monthly_cost DECIMAL(3),
 rental_id SERIAL
);

ALTER TABLE rental_instrument ADD CONSTRAINT PK_rental_instrument PRIMARY KEY (ri_id);


CREATE TABLE siblings (
 student_id_1 SERIAL NOT NULL,
 student_id_2 SERIAL NOT NULL
);

ALTER TABLE siblings ADD CONSTRAINT PK_siblings PRIMARY KEY (student_id_1,student_id_2);


CREATE TABLE ensemble (
 ensemble_id SERIAL NOT NULL,
 genre VARCHAR(500),
 max_students INT NOT NULL,
 min_students INT NOT NULL,
 level VARCHAR(20),
 instructor_id SERIAL,
 start_time TIME(0),
 end_time TIME(0),
 date DATE,
 price CHAR(10),
 pay CHAR(10)
);

ALTER TABLE ensemble ADD CONSTRAINT PK_ensemble PRIMARY KEY (ensemble_id);


CREATE TABLE ensemble_lesson_student (
 student_id SERIAL NOT NULL,
 ensemble_id SERIAL NOT NULL
);

ALTER TABLE ensemble_lesson_student ADD CONSTRAINT PK_ensemble_lesson_student PRIMARY KEY (student_id,ensemble_id);


CREATE TABLE group_lesson (
 g_lesson_id INT NOT NULL,
 instrument_id SERIAL NOT NULL,
 instructor_id SERIAL,
 max_students INT NOT NULL,
 min_students INT NOT NULL,
 level VARCHAR(50),
 start_time TIME(0),
 end_time TIME(0),
 date DATE,
 price CHAR(10),
 pay CHAR(10)
);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (g_lesson_id);


CREATE TABLE individual_lesson (
 i_lesson_id INT NOT NULL,
 instrument_id SERIAL NOT NULL,
 level VARCHAR(20),
 instructor_id SERIAL,
 student_id SERIAL,
 start_time TIME(0),
 end_time TIME(0),
 date DATE,
 price CHAR(10),
 pay CHAR(10)
);

ALTER TABLE individual_lesson ADD CONSTRAINT PK_individual_lesson PRIMARY KEY (i_lesson_id);


CREATE TABLE g_lesson_student (
 student_id SERIAL NOT NULL,
 g_lesson_id SERIAL NOT NULL
);

ALTER TABLE g_lesson_student ADD CONSTRAINT PK_g_lesson_student PRIMARY KEY (student_id,g_lesson_id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE student_instrument_skill ADD CONSTRAINT FK_student_instrument_skill_0 FOREIGN KEY (student_id) REFERENCES student (student_id);
ALTER TABLE student_instrument_skill ADD CONSTRAINT FK_student_instrument_skill_1 FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id);


ALTER TABLE student_parent ADD CONSTRAINT FK_student_parent_0 FOREIGN KEY (parent_id) REFERENCES parent_contact_details (parent_id);
ALTER TABLE student_parent ADD CONSTRAINT FK_student_parent_1 FOREIGN KEY (student_id) REFERENCES student (student_id);


ALTER TABLE application ADD CONSTRAINT FK_application_0 FOREIGN KEY (school_id) REFERENCES school_data (school_id);
ALTER TABLE application ADD CONSTRAINT FK_application_1 FOREIGN KEY (student_id) REFERENCES student (student_id);


ALTER TABLE audition ADD CONSTRAINT FK_audition_0 FOREIGN KEY (application_id) REFERENCES application (application_id);


ALTER TABLE days_of_extra_charge ADD CONSTRAINT FK_days_of_extra_charge_0 FOREIGN KEY (school_id) REFERENCES school_data (school_id);


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_id) REFERENCES person (person_id);


ALTER TABLE instructor_availability ADD CONSTRAINT FK_instructor_availability_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE instructor_instrument ADD CONSTRAINT FK_instructor_instrument_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);
ALTER TABLE instructor_instrument ADD CONSTRAINT FK_instructor_instrument_1 FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id);


ALTER TABLE lesson_pricing ADD CONSTRAINT FK_lesson_pricing_0 FOREIGN KEY (school_id) REFERENCES school_data (school_id);


ALTER TABLE pricing_specification ADD CONSTRAINT FK_pricing_specification_0 FOREIGN KEY (school_id) REFERENCES school_data (school_id);


ALTER TABLE rental ADD CONSTRAINT FK_rental_0 FOREIGN KEY (student_id) REFERENCES student (student_id);


ALTER TABLE rental_instrument ADD CONSTRAINT FK_rental_instrument_0 FOREIGN KEY (rental_id) REFERENCES rental (rental_id);


ALTER TABLE siblings ADD CONSTRAINT FK_siblings_0 FOREIGN KEY (student_id_1) REFERENCES student (student_id);
ALTER TABLE siblings ADD CONSTRAINT FK_siblings_1 FOREIGN KEY (student_id_2) REFERENCES student (student_id);


ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_0 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE ensemble_lesson_student ADD CONSTRAINT FK_ensemble_lesson_student_0 FOREIGN KEY (student_id) REFERENCES student (student_id);
ALTER TABLE ensemble_lesson_student ADD CONSTRAINT FK_ensemble_lesson_student_1 FOREIGN KEY (ensemble_id) REFERENCES ensemble (ensemble_id);


ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id);
ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_1 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);


ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_0 FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id);
ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_1 FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id);
ALTER TABLE individual_lesson ADD CONSTRAINT FK_individual_lesson_2 FOREIGN KEY (student_id) REFERENCES student (student_id);


ALTER TABLE g_lesson_student ADD CONSTRAINT FK_g_lesson_student_0 FOREIGN KEY (student_id) REFERENCES student (student_id);
ALTER TABLE g_lesson_student ADD CONSTRAINT FK_g_lesson_student_1 FOREIGN KEY (g_lesson_id) REFERENCES group_lesson (g_lesson_id);


