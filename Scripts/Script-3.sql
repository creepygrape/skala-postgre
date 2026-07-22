
-- 2. Student (학생)
CREATE TABLE IF NOT EXISTS academic.Student (
    id BIGSERIAL PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    birth DATE NOT NULL,
    phone VARCHAR(20),
    grade SMALLINT NOT NULL CHECK (grade BETWEEN 1 AND 4),
    status VARCHAR(10) NOT NULL DEFAULT '재학',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Department (학과)
CREATE TABLE IF NOT EXISTS academic.Department (
    id BIGSERIAL PRIMARY KEY,
    department_id VARCHAR(20) NOT NULL UNIQUE,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    office_location VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Professor (교수)
CREATE TABLE IF NOT EXISTS academic.Professor (
    id BIGSERIAL PRIMARY KEY,
    professor_id VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    birth DATE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(20) NOT NULL,
    department_id BIGINT NOT NULL REFERENCES academic.Department(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5. Course (과목)
CREATE TABLE IF NOT EXISTS academic.Course (
    id BIGSERIAL PRIMARY KEY,
    course_id VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(100) NOT NULL,
    credit SMALLINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. Section (개설강좌)
CREATE TABLE IF NOT EXISTS academic.Section (
    id BIGSERIAL PRIMARY KEY,
    section_id VARCHAR(20) NOT NULL UNIQUE,
    class INT NOT NULL,
    classroom VARCHAR(50),
    year SMALLINT NOT NULL,
    semester VARCHAR(10) NOT NULL,
    capacity INT NOT NULL DEFAULT 30,
    course_id BIGINT NOT NULL REFERENCES academic.Course(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    department_id BIGINT NOT NULL REFERENCES academic.Department(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    professor_id BIGINT NOT NULL REFERENCES academic.Professor(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_course_year_semester_class UNIQUE (course_id, year, semester, class)
);

-- 7. Section_Schedule (강좌 시간표)
CREATE TABLE IF NOT EXISTS academic.Section_Schedule (
    id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL REFERENCES academic.Section(id) ON DELETE CASCADE ON UPDATE CASCADE,
    day_of_week VARCHAR(10) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 8. Enrollment (수강신청)
CREATE TABLE IF NOT EXISTS academic.Enrollment (
    id BIGSERIAL PRIMARY KEY,
    enrollment_id VARCHAR(20) NOT NULL UNIQUE,
    student_id BIGINT NOT NULL REFERENCES academic.Student(id) ON DELETE CASCADE ON UPDATE CASCADE,
    section_id BIGINT NOT NULL REFERENCES academic.Section(id) ON DELETE CASCADE ON UPDATE CASCADE,
    mid_score NUMERIC(5,2),
    final_score NUMERIC(5,2),
    grade VARCHAR(5),
    grade_remark VARCHAR(200),
    is_retake BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(20) NOT NULL DEFAULT 'APPLIED',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_student_section UNIQUE (student_id, section_id)
);

-- 9. Student_Department (학생 전공)
CREATE TABLE IF NOT EXISTS academic.Student_Department (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES academic.Student(id) ON DELETE CASCADE ON UPDATE CASCADE,
    department_id BIGINT NOT NULL REFERENCES academic.Department(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    major_type VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_student_department UNIQUE (student_id, department_id),
    CONSTRAINT uk_student_majortype UNIQUE (student_id, major_type)
);

-- 10. Student_Professor (지도교수 배정)
CREATE TABLE IF NOT EXISTS academic.Student_Professor (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES academic.Student(id) ON DELETE CASCADE ON UPDATE CASCADE,
    professor_id BIGINT NOT NULL REFERENCES academic.Professor(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    department_id BIGINT NOT NULL REFERENCES academic.Department(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_student_dept_advisor UNIQUE (student_id, department_id)
);