-- ------------------------------------------------------------------
-- Title: Identificación of STEMI patients.
-- Notes: Extraction conditions are:
--        1) Priority of the diagnosis must be "1" (using seq_num fields from diagnoses_icd table)
-- Once extracted each set of data, join them in a csv.file
-- The important point of this query is to extract the patients IDS.
-- ------------------------------------------------------------------

drop view stemi_1;
create view stemi_1 as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4100%_%'
  order by icu.subject_id;
  \copy (SELECT * FROM stemi_1) to '/tmp/stemi_1.csv' CSV HEADER;

drop view stemi_2;
create view stemi_2 as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4101%_%'
  order by icu.subject_id;
  \copy (SELECT * FROM stemi_2) to '/tmp/stemi_2.csv' CSV HEADER;


drop view stemi_3;
create view stemi_3 as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4102%_%'
  order by icu.subject_id;
  \copy (SELECT * FROM stemi_3) to '/tmp/stemi_3.csv' CSV HEADER;

drop view stemi_4;
create view stemi_4 as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4103%_%'
  order by icu.subject_id;
  \copy (SELECT * FROM stemi_4) to '/tmp/stemi_4.csv' CSV HEADER;


drop view stemi_5;
create view stemi_5 as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4104%_%'
  order by icu.subject_id;
  \copy (SELECT * FROM stemi_5) to '/tmp/stemi_5.csv' CSV HEADER;


drop view stemi_6;
create view stemi_6 as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4105%_%'
  order by icu.subject_id;
  \copy (SELECT * FROM stemi_6) to '/tmp/stemi_6.csv' CSV HEADER;

drop view stemi_7;
create view stemi_7 as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4108%_%'
  order by icu.subject_id;
  \copy (SELECT * FROM stemi_7) to '/tmp/stemi_7.csv' CSV HEADER;

drop view stemi_8;
create view stemi_8 as
  select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
  from icustays icu
  inner join diagnoses_icd dx
  on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
  where dx.seq_num ='1' and dx.icd9_code like '4109%_%'
  order by icu.subject_id;
  \copy (SELECT * FROM stemi_8) to '/tmp/stemi_8.csv' CSV HEADER;

drop view stemi_9;
create view stemi_9 as
    select distinct icu.subject_id, icu.hadm_id, icu.icustay_id
    from icustays icu
    inner join diagnoses_icd dx
    on icu.subject_id = dx.subject_id and icu.hadm_id = dx.hadm_id
    where dx.seq_num ='1' and dx.icd9_code like '4110'
    order by icu.subject_id;
    \copy (SELECT * FROM stemi_9) to '/tmp/stemi_9.csv' CSV HEADER;
