.open data/duckdb/claims.duckdb;

CREATE OR REPLACE VIEW inpatient_claims_sample1_raw AS
SELECT *
FROM read_csv_auto('data/raw/Sample1/DE1_0_2008_to_2010_Inpatient_Claims_Sample_1.csv');
