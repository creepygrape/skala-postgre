-- ============================================================
-- 2. SCHEMA 생성 및 경로 설정
-- ============================================================
CREATE SCHEMA IF NOT EXISTS academic;

-- 스키마 기본 탐색 경로 설정 (academic 스키마 우선 참조)
SET search_path TO academic, public;