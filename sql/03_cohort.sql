.open data/duckdb/claims.duckdb;

-- Step 3: Cohort Definition (2009)

-- Base cohort
CREATE OR REPLACE VIEW cohort_2009 AS
SELECT DISTINCT DESYNPUF_ID
FROM beneficiary_2009_clean;

-- Enriched cohort
CREATE OR REPLACE VIEW cohort_2009_enriched AS
WITH base AS (
  SELECT
    c.DESYNPUF_ID,
    b.birth_date,
    DATE_DIFF('year', b.birth_date, DATE '2009-12-31') AS age_2009,
    b.SEX_IDENT_CD AS sex_code,
    COALESCE(b.DIABETES_FLAG, 0) AS diabetes,
    COALESCE(b.CHF_FLAG, 0)      AS chf,
    COALESCE(b.COPD_FLAG, 0)     AS copd
  FROM cohort_2009 c
  LEFT JOIN beneficiary_2009_clean b USING (DESYNPUF_ID)
)
SELECT * FROM base;
