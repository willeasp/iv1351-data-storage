BEGIN;

CREATE TABLE instrument (
 instrument_id SERIAL NOT NULL PRIMARY KEY,
 name VARCHAR(100),
 type VARCHAR(100)
);


CREATE TABLE parent_contact_details (
 parent_id INT NOT NULL PRIMARY KEY,
 email VARCHAR(500) NOT NULL,
 phone VARCHAR(30) NOT NULL
);


CREATE TABLE person (
 person_id SERIAL NOT NULL PRIMARY KEY,
 person_number CHAR(12) UNIQUE,
 first_name VARCHAR(500),
 last_name VARCHAR(500),
 phone VARCHAR(30),
 email VARCHAR(500),
 street_name VARCHAR(500),
 street_number VARCHAR(30),
 postal_code VARCHAR(500),
 city VARCHAR(500)
);


CREATE TABLE school (
 school_id SERIAL NOT NULL PRIMARY KEY,
 max_number_of_students INT,
 minimum_age INT
);


CREATE TABLE student (
 student_id SERIAL NOT NULL PRIMARY KEY,
 person_id INT NOT NULL REFERENCES person (person_id) ON DELETE NO ACTION,
);


CREATE TABLE student_instrument_skill (
 student_id SERIAL NOT NULL,
 instrument_id INT NOT NULL REFERENCES instrument (instrument_id) ON DELETE CASCADE,
 CONSTRAINT pk_student_instrument
  PRIMARY KEY(student_id, instrument_id),
 skill_level VARCHAR(500)
);


CREATE TABLE student_parent (
 parent_id INT NOT NULL REFERENCES parent_contact_details (parent_id) ON DELETE CASCADE,
 student_id INT NOT NULL REFERENCES student (student_id) ON DELETE CASCADE,
 CONSTRAINT pk_student_parent
  PRIMARY KEY (parent_id, student_id)
);


CREATE TABLE application (
 application_id SERIAL NOT NULL PRIMARY KEY,
 school_id INT NOT NULL REFERENCES school (school_id) ON DELETE CASCADE,
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
 student_id INT REFERENCES student (student_id) ON DELETE SET NULL
);


CREATE TABLE audition (
 audition_id SERIAL NOT NULL PRIMARY KEY,
 application_id INT REFERENCES application (application_id) ON DELETE SET NULL,
 instrument VARCHAR(500),
 result VARCHAR(500),
 date DATE
);


CREATE TABLE days_of_extra_charge (
 school_id INT NOT NULL PRIMARY KEY REFERENCES school (school_id),
 monday BOOLEAN,
 tuesday BOOLEAN,
 wednesday BOOLEAN,
 thursday BOOLEAN,
 friday BOOLEAN,
 saturday BOOLEAN,
 sunday BOOLEAN
);


CREATE TABLE instructor (
 instructor_id SERIAL NOT NULL PRIMARY KEY,
 person_id INT NOT NULL REFERENCES person (person_id) ON DELETE NO ACTION,
 teaches_ensembles BOOLEAN
);


CREATE TABLE instructor_availability (
 id SERIAL NOT NULL PRIMARY KEY,
 instructor_id INT NOT NULL REFERENCES instructor (instructor_id) ON DELETE CASCADE,
 start_time TIME(0),
 end_time TIME(0),
 "date" DATE
);


CREATE TABLE instructor_instrument (
 instructor_id INT NOT NULL REFERENCES instructor (instructor_id) ON DELETE CASCADE,
 instrument_id INT NOT NULL REFERENCES instrument (instrument_id) ON DELETE CASCADE,
 CONSTRAINT PK_instructor_instrument
  PRIMARY KEY (instructor_id, instrument_id)
);


CREATE TABLE lesson_pricing (
 pricing_id SERIAL NOT NULL PRIMARY KEY,
 type VARCHAR(30) NOT NULL,
 level VARCHAR(30) NOT NULL,
 student_price DECIMAL(3),
 instructor_pay DECIMAL(3),
 school_id INT NOT NULL REFERENCES school (school_id) ON DELETE CASCADE
);


CREATE TABLE pricing_specification (
 school_id INT NOT NULL PRIMARY KEY REFERENCES school (school_id) ON DELETE CASCADE,
 discount_amount DECIMAL(3),
 extra_charge DECIMAL(3)
);

CREATE TABLE rental_instrument (
 ri_id SERIAL NOT NULL PRIMARY KEY,
 name VARCHAR(500) NOT NULL,
 type VARCHAR(500) NOT NULL,
 brand VARCHAR(500),
 monthly_cost DECIMAL(3)
);


CREATE TABLE rental (
 rental_id SERIAL NOT NULL PRIMARY KEY,
 start_date DATE,
 end_date DATE,
 student_id INT NOT NULL REFERENCES student (student_id) ON DELETE NO ACTION,
 ri_id INT NOT NULL REFERENCES rental_instrument (ri_id) ON DELETE NO ACTION
);


CREATE TABLE siblings (
 student_id_1 INT NOT NULL REFERENCES student (student_id),
 student_id_2 INT NOT NULL REFERENCES student (student_id),
 CONSTRAINT PK_siblings 
  PRIMARY KEY (student_id_1,student_id_2)
);


CREATE TABLE ensemble (
 ensemble_id SERIAL NOT NULL PRIMARY KEY,
 genre VARCHAR(500),
 max_students INT NOT NULL,
 min_students INT NOT NULL,
 level VARCHAR(20),
 instructor_id INT REFERENCES instructor (instructor_id),
 start_time TIME(0),
 end_time TIME(0),
 "date" DATE,
 price DECIMAL(3),
 pay DECIMAL(3)
);


CREATE TABLE ensemble_lesson_student (
 student_id INT NOT NULL REFERENCES student (student_id),
 ensemble_id INT NOT NULL REFERENCES ensemble (ensemble_id),
 CONSTRAINT PK_ensemble_lesson_student 
  PRIMARY KEY (student_id,ensemble_id)
);


CREATE TABLE group_lesson (
 g_lesson_id INT NOT NULL PRIMARY KEY,
 instrument_id INT NOT NULL REFERENCES instrument (instrument_id),
 instructor_id INT REFERENCES instructor (instructor_id),
 max_students INT NOT NULL,
 min_students INT NOT NULL,
 level VARCHAR(50),
 start_time TIME(0),
 end_time TIME(0),
 "date" DATE,
 price DECIMAL(3),
 pay DECIMAL(3)
);


CREATE TABLE individual_lesson (
 i_lesson_id INT NOT NULL PRIMARY KEY,
 instrument_id INT NOT NULL REFERENCES instrument (instrument_id),
 level VARCHAR(20),
 instructor_id INT REFERENCES instructor (instructor_id),
 student_id INT REFERENCES student (student_id),
 start_time TIME(0),
 end_time TIME(0),
 "date" DATE,
 price CHAR(10),
 pay CHAR(10)
);


CREATE TABLE g_lesson_student (
 student_id INT NOT NULL REFERENCES student (student_id),
 g_lesson_id INT NOT NULL REFERENCES group_lesson (g_lesson_id),
 CONSTRAINT PK_g_lesson_student 
  PRIMARY KEY (student_id, g_lesson_id)
);

COMMIT;