.open data/duckdb/claims.duckdb;

CREATE OR REPLACE VIEW inpatient_claims_sample1_clean AS
SELECT
  t.*,
  TRY_STRPTIME(CAST(CLM_FROM_DT AS VARCHAR), '%Y%m%d')::DATE AS clm_from_date,
  TRY_STRPTIME(CAST(CLM_THRU_DT AS VARCHAR),  '%Y%m%d')::DATE AS clm_thru_date
FROM inpatient_claims_sample1_raw AS t;

CREATE OR REPLACE VIEW inpatient_2008 AS
SELECT * FROM inpatient_claims_sample1_clean
WHERE clm_from_date >= DATE '2008-01-01' AND clm_from_date < DATE '2009-01-01';

CREATE OR REPLACE VIEW inpatient_2009 AS
SELECT * FROM inpatient_claims_sample1_clean
WHERE clm_from_date >= DATE '2009-01-01' AND clm_from_date < DATE '2010-01-01';

CREATE OR REPLACE VIEW inpatient_2010 AS
SELECT * FROM inpatient_claims_sample1_clean
WHERE clm_from_date >= DATE '2010-01-01' AND clm_from_date < DATE '2011-01-01';
