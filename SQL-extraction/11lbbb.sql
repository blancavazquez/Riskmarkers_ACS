-- ------------------------------------------------------------------
-- Title: Extraction of lbbb complications
-- Notes: An important aspect to validate in patients with myocardial infarction is to find what brach is blocked.
---       Using clinical notes, we explored in the text description the words "lbb" and "lbbb_bundle".
---       Previously, we examined that these words are using to describe left bundle branch.
-- ------------------------------------------------------------------

--- Step 1: Search the words "lbb" and "lbbb_bundle" in clinical notes
drop view lbbb_nstemi;
create view lbbb_nstemi as
  select
    subject_id
    ,hadm_id
    ,substring(text, ' lbb (.*?)\n') as lbbb
    ,substring(text, ' left (.*?)\n') as lbbb_bundle

from notas_nstemi -- for STEMI: notas_stemi
order by subject_id;

--- Step 2: Export the table previously created (csv file). Once exported the table, the idea is validate that patient presented this complication.
--- In the csv file, we added the field "lbbb_flag". This is a label and it is positive when patient presented the complication and false  when the
--- complication is absent
\copy (SELECT * FROM lbbb_nstemi) to '/tmp/lbbb_nstemi.csv' CSV HEADER;

---Step 3: Load the csv file to MIMIC database
drop table nstemi_lbbb; --
create table nstemi_lbbb (
	subject_id int
  ,hadm_id int
	,lbbb_flag int
);
\copy nstemi_lbbb FROM '/tmp/lbbb.csv' DELIMITER ',' CSV HEADER NULL ''

--- Step 4: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.

drop view temp cascade;
create view temp as
SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
	,e.lbbb_flag
from nstemi_ccu ids -- for STEMI: stemi_ccu
left join nstemi_lbbb e
on ids.subject_id = e.subject_id
group by ids.subject_id, ids.hadm_id, ids.icustay_id, e.lbbb_flag
order by ids.subject_id;

\copy (SELECT * FROM temp) to '/tmp/temp.csv' CSV HEADER;
