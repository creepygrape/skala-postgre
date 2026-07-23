-- ============================================================
-- 1. ENUM 타입 생성
-- ============================================================
CREATE TYPE student_status_enum AS ENUM ('재학', '휴학', '제적', '졸업');
CREATE TYPE course_status_enum AS ENUM ('ACTIVE', 'INACTIVE');
CREATE TYPE semester_enum AS ENUM ('1학기', '2학기', '여름학기', '겨울학기');
CREATE TYPE enrollment_status_enum AS ENUM ('APPLIED', 'COMPLETED', 'CANCELED');
CREATE TYPE major_type_enum AS ENUM ('주전공', '복수전공', '부전공');
CREATE TYPE day_of_week_enum AS ENUM ('월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일');


-- ============================================================
-- 2. TABLE 생성 (ENUM 적용)
-- ============================================================

-- 2-1. Student (학생)
CREATE TABLE Student (
    id BIGSERIAL PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    birth DATE NOT NULL,
    phone VARCHAR(20),
    grade SMALLINT NOT NULL CHECK (grade BETWEEN 1 AND 4),
    status student_status_enum NOT NULL DEFAULT '재학', -- ENUM 적용
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2-2. Department (학과)
CREATE TABLE Department (
    id BIGSERIAL PRIMARY KEY,
    department_id VARCHAR(50) NOT NULL UNIQUE,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    office_location VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2-3. Professor (교수)
CREATE TABLE Professor (
    id BIGSERIAL PRIMARY KEY,
    professor_id VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    birth DATE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(20) NOT NULL,
    department_id BIGINT NOT NULL REFERENCES Department(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2-4. Course (과목)
CREATE TABLE Course (
    id BIGSERIAL PRIMARY KEY,
    course_id VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(100) NOT NULL,
    credit SMALLINT NOT NULL,
    status course_status_enum NOT NULL DEFAULT 'ACTIVE', -- ENUM 적용
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2-5. Section (개설강좌)
CREATE TABLE Section (
    id BIGSERIAL PRIMARY KEY,
    section_id VARCHAR(50) NOT NULL UNIQUE,
    class INT NOT NULL,
    classroom VARCHAR(50),
    year SMALLINT NOT NULL,
    semester semester_enum NOT NULL, -- ENUM 적용
    capacity INT NOT NULL DEFAULT 30,
    course_id BIGINT NOT NULL REFERENCES Course(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    department_id BIGINT NOT NULL REFERENCES Department(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    professor_id BIGINT NOT NULL REFERENCES Professor(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_course_year_semester_class UNIQUE (course_id, year, semester, class)
);

-- 2-6. Section_Schedule (강좌 시간표)
CREATE TABLE Section_Schedule (
    id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL REFERENCES Section(id) ON DELETE CASCADE ON UPDATE CASCADE,
    day_of_week day_of_week_enum NOT NULL, -- ENUM 적용
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2-7. Enrollment (수강신청)
CREATE TABLE Enrollment (
    id BIGSERIAL PRIMARY KEY,
    enrollment_id VARCHAR(50) NOT NULL UNIQUE,
    student_id BIGINT NOT NULL REFERENCES Student(id) ON DELETE CASCADE ON UPDATE CASCADE,
    section_id BIGINT NOT NULL REFERENCES Section(id) ON DELETE CASCADE ON UPDATE CASCADE,
    mid_score NUMERIC(5,2),
    final_score NUMERIC(5,2),
    grade VARCHAR(5),
    grade_remark VARCHAR(200),
    is_retake BOOLEAN NOT NULL DEFAULT FALSE,
    status enrollment_status_enum NOT NULL DEFAULT 'APPLIED', -- ENUM 적용
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_student_section UNIQUE (student_id, section_id)
);

-- 2-8. Student_Department (학생 전공)
CREATE TABLE Student_Department (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES Student(id) ON DELETE CASCADE ON UPDATE CASCADE,
    department_id BIGINT NOT NULL REFERENCES Department(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    major_type major_type_enum NOT NULL, -- ENUM 적용
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_student_department UNIQUE (student_id, department_id),
    CONSTRAINT uk_student_majortype UNIQUE (student_id, major_type)
);

-- 2-9. Student_Professor (지도교수 배정)
CREATE TABLE Student_Professor (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES Student(id) ON DELETE CASCADE ON UPDATE CASCADE,
    professor_id BIGINT NOT NULL REFERENCES Professor(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    department_id BIGINT NOT NULL REFERENCES Department(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_student_dept_advisor UNIQUE (student_id, department_id)
);
