.open data/duckdb/claims.duckdb;

-- Step 5: RADV-style Chase List (2009)

.open data/duckdb/claims.duckdb;

-- Create the table in the DB
.open data/duckdb/claims.duckdb;

COPY (
  WITH sampled AS (
    SELECT DESYNPUF_ID
    FROM cohort_2009_enriched
    WHERE diabetes = 1
    USING SAMPLE 200
  ),
  earliest_claim AS (
    SELECT
      DESYNPUF_ID,
      MIN(clm_from_date) AS index_claim_date,
      MIN(clm_thru_date) AS index_claim_thru
    FROM inpatient_2009
    GROUP BY DESYNPUF_ID
  )
  SELECT
    s.DESYNPUF_ID,
    e.index_claim_date,
    'IP' AS claim_type,
    CASE WHEN b.birth_date IS NOT NULL THEN 1 ELSE 0 END AS dob_present,
    CASE WHEN b.sex_code IS NOT NULL THEN 1 ELSE 0 END AS sex_present,
    CASE WHEN e.index_claim_date IS NOT NULL AND e.index_claim_thru IS NOT NULL THEN 1 ELSE 0 END AS service_dates_present,
    1 AS any_dx_present,  -- placeholder until dx fields available
    CASE WHEN e.index_claim_thru < e.index_claim_date THEN 1 ELSE 0 END AS date_anomaly,
    CASE WHEN (b.birth_date IS NULL OR b.sex_code IS NULL OR e.index_claim_date IS NULL OR e.index_claim_thru IS NULL)
         THEN 1 ELSE 0 END AS missing_any_required
  FROM sampled s
  LEFT JOIN earliest_claim e USING (DESYNPUF_ID)
  LEFT JOIN cohort_2009_enriched b USING (DESYNPUF_ID)
) TO 'data/clean/chase_list_2009.csv' (HEADER, DELIMITER ',');
