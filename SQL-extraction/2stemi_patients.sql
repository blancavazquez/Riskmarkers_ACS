-- ------------------------------------------------------------------
-- Title: Extraction of STEMI patients.
-- Notes: Extraction conditions are:
--        1) Length ICU stay > 24 hours
--        2) Priority of the diagnosis must be "1" (using seq_num fields from diagnoses_icd table)
-- To generate this table, first should executed "1stemi_ids_extraction.sql".
-- ------------------------------------------------------------------

-- Query to complete the patient information
drop view stemi_icuflag;
create view stemi_icuflag as
  select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,icu.intime
  ,icu.outtime
  ,icu.first_careunit
  ,icu.los
  from stemi_ids ids --table generated in "1stemi_ids_extraction.sql"
  inner join icustays icu
  on ids.subject_id = icu.subject_id and ids.hadm_id = icu.hadm_id and ids.icustay_id = icu.icustay_id
  order by ids.subject_id;

-- Query to add the label for each patient.
drop view stemi_ccu cascade;
create view stemi_ccu as
  SELECT
   e.subject_id
  ,e.hadm_id
  ,e.icustay_id
  ,e.intime
  ,e.outtime
  ,e.first_careunit
  ,e.los
  ,adm.deathtime
  ,adm.hospital_expire_flag
  ,CASE
      WHEN adm.deathtime BETWEEN e.intime and e.outtime
          THEN '1'
      WHEN adm.deathtime <= e.intime
          THEN '1'
      WHEN adm.dischtime <= e.outtime AND adm.discharge_location = 'DEAD/EXPIRED'
          THEN '1'
      ELSE '0'
      END AS ICUSTAY_EXPIRE_FLAG

 FROM stemi_icuflag e
 inner join admissions adm
 ON e.subject_id = adm.subject_id and e.hadm_id = adm.hadm_id
 where e.los > 1--- me aseguro que sean pacientes que estuvieron más de un día en ICU
 GROUP BY e.subject_id,e.hadm_id,e.icustay_id,e.intime,e.outtime,e.first_careunit,
          e.los,adm.hospital_expire_flag, adm.deathtime, adm.dischtime, adm.discharge_location
 ORDER BY e.subject_id; -- we obtained 1,299 patients with STEMI (lenght stay ICU > 24)
