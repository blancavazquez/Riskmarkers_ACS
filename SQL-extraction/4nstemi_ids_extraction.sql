-- ------------------------------------------------------------------
-- Title: Extraction of NSTEMI patients.
-- Notes: Extraction conditions are:
--        2) Priority of the diagnosis must be "1" (using seq_num fields from diagnoses_icd table)
-- The important point of this query is to extract the patients IDS.
-- ------------------------------------------------------------------

drop view nstemi_ids;
create view nstemi_ids as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4107%_'
  order by icu.subject_id;
