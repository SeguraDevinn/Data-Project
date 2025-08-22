.open data/duckdb/claims.duckdb;

-- Step 4: Descriptives (2009)

-- Age × Sex counts
COPY (
  WITH banded AS (
    SELECT
      CASE
        WHEN age_2009 < 65 THEN '<65'
        WHEN age_2009 BETWEEN 65 AND 74 THEN '65-74'
        WHEN age_2009 BETWEEN 75 AND 84 THEN '75-84'
        ELSE '85+'
      END AS age_band,
      sex_code
    FROM cohort_2009_enriched
  )
  SELECT age_band, sex_code, COUNT(*) AS n
  FROM banded
  GROUP BY age_band, sex_code
  ORDER BY
    CASE age_band WHEN '<65' THEN 1 WHEN '65-74' THEN 2 WHEN '75-84' THEN 3 ELSE 4 END,
    sex_code
) TO 'data/clean/ageband_sex_counts_2009.csv' (HEADER, DELIMITER ',');

-- Chronic condition prevalence
COPY (
  SELECT
    AVG(diabetes::DOUBLE) AS diabetes_prev,
    AVG(chf::DOUBLE)      AS chf_prev,
    AVG(copd::DOUBLE)     AS copd_prev
  FROM cohort_2009_enriched
) TO 'data/clean/chronic_prev_2009.csv' (HEADER, DELIMITER ',');

-- Utilization averages (IP claims only for now)
COPY (
  WITH cohort AS (
    SELECT DESYNPUF_ID FROM cohort_2009
  ),
  ip_counts AS (
    SELECT DESYNPUF_ID, COUNT(*) AS ip_claims_2009
    FROM inpatient_2009
    GROUP BY DESYNPUF_ID
  ),
  cohort_counts AS (
    SELECT
      c.DESYNPUF_ID,
      COALESCE(i.ip_claims_2009, 0) AS ip_claims_2009
    FROM cohort c
    LEFT JOIN ip_counts i USING (DESYNPUF_ID)
  )
  SELECT
    AVG(ip_claims_2009::DOUBLE) AS avg_ip_claims_per_person_2009
  FROM cohort_counts
) TO 'data/clean/utilization_avgs_2009.csv' (HEADER, DELIMITER ',');
