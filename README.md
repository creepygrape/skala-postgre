# 🎓 학사관리시스템 (Academic Management System)

PostgreSQL 기반의 대학 학사관리 시스템 데이터베이스 설계 및 구축 명세서입니다.

---

## 📌 0. 목차
1. [시스템 요구사항 및 설계 방향](#-1-시스템-요구사항-및-설계-방향)
2. [데이터베이스 ERD 및 접속 화면](#-2-데이터베이스-erd-및-접속-화면)
3. [DB 및 스키마 생성 (SQL)](#-3-db-및-스키마-생성-sql)
4. [테이블 생성 DDL (SQL)](#-4-테이블-생성-ddl-sql)
5. [샘플 데이터 INSERT (SQL)](#-5-sample-data-insert-sql)
6. [주요 기능별 SELECT 실습 (SQL)](#-6-주요-기능별-select-실습-sql)

---

## 📋 1. 시스템 요구사항 및 설계 방향

### 0️⃣ PostgreSQL ENUM 타입 정의
데이터 무결성 확보 및 잘못된 코드 값 입력을 방지하기 위해 아래 항목들은 PostgreSQL ENUM 타입으로 관리합니다.
* `student_status_enum` : `'재학'`, `'휴학'`, `'제적'`, `'졸업'`
* `course_status_enum` : `'ACTIVE'`, `'INACTIVE'`
* `semester_enum` : `'1학기'`, `'2학기'`, `'여름학기'`, `'겨울학기'`
* `enrollment_status_enum` : `'APPLIED'`, `'COMPLETED'`, `'CANCELED'`
* `major_type_enum` : `'주전공'`, `'복수전공'`, `'부전공'`
* `day_of_week_enum` : `'월요일'`, `'화요일'`, `'수요일'`, `'목요일'`, `'금요일'`, `'토요일'`, `'일요일'`

### 👤 1. 회원 및 사용자 관리
* **학생 (Student)**: 학번, 이름, 이메일, 비밀번호, 생년월일, 연락처 관리 (학년 `1~4` 제한, 상태 기본값 `'재학'`, 유일성 보장)
* **교수 (Professor)**: 교번, 이름, 이메일, 비밀번호, 생년월일, 연락처, 직급 관리 (학과 소속 필수, 소속 교수 존재 시 학과 삭제 방지 `ON DELETE RESTRICT`)

### 🏫 2. 조직 및 교과목 관리
* **학과 (Department)**: 학과 코드, 학과명, 사무실 위치, 전화번호 관리 (유일성 보장)
* **과목 (Course)**: 과목 코드, 과목명, 이수 학점, 과목 상태 관리 (표준 교과목 마스터 정보)

### 📅 3. 강좌 및 시간표 관리
* **개설강좌 (Section)**: 연도, 학기, 분반, 강의실, 정원 설정 및 동일 `[과목 + 연도 + 학기 + 분반]` 중복 개설 방지 제약
* **강좌 시간표 (Section_Schedule)**: 요일/시간대 관리 (1:N 관계, 강좌 삭제 시 연쇄 삭제 `ON DELETE CASCADE`)

### 📝 4. 수강 및 성적 관리
* **수강신청 (Enrollment)**: 학생별 개설강좌 신청 상태 및 재수강 여부 관리 (동일 학생·강좌 중복 신청 방지)
* **성적 처리**: 중간/기말고사 점수 및 최종 학점, 사유 기록

### 🔗 5. 학생 전공 및 지도교수 매핑
* **학생 전공 (Student_Department)**: 주/복수/부전공 관리 (동일 학과 중복 등록 및 동일 전공 유형 중복 제한)
* **지도교수 배정 (Student_Professor)**: 학과별 지도교수 1명 배정 제한

### ⚙️ 6. 시스템 공통 규칙
* **데이터 이력 관리**: `created_at`, `updated_at` 자동 기록
* **무결성 및 연쇄 정책**: 학생 삭제 시 관련 내역 연쇄 삭제(`CASCADE`), 마스터 데이터 무단 삭제 방지(`RESTRICT`)

---

## 🖼️ 2. 데이터베이스 ERD 및 접속 화면

### ERD (Entity-Relationship Diagram)
<img src="exec/ERD.png" width="800">

### PostgreSQL 접속 확인
<img src="exec/postgres_connect_test.png" width="600">

---

## 🛠️ 3. DB 및 스키마 생성 (SQL)

### `create_db.sql`
```sql
CREATE DATABASE university_db
    WITH ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE = template0;