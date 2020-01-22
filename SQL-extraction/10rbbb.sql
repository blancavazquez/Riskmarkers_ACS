-- ------------------------------------------------------------------
-- Title: Extraction of RBBB complications
-- Notes: An important aspect to validate in patients with myocardial infarction is to find what brach is blocked.
---       Using clinical notes, we explored in the text description the words "rbb" and "rbbb_bundle".
---       Previously, we examined that these words are using to describe right bundle branch.
-- ------------------------------------------------------------------

--- Step 1: Search the words "rbb" and "rbbb_bundle" in clinical notes
drop view rbbb_nstemi;
create view rbbb_nstemi as
  select
    subject_id
    ,hadm_id
    ,substring(text, ' rbb (.*?)\n') as rbbb
    ,substring(text, ' right (.*?)\n') as rbbb_bundle

from notas_nstemi -- for STEMI: notas_stemi
order by subject_id;

--- Step 2: Export the table previously created (csv file). Once exported the table, the idea is validate that patient presented this complication.
--- In the csv file, we added the field "rbbb_flag". This is a label and it is positive when patient presented the complication and false  when the
--- complication is absent
\copy (SELECT * FROM rbbb_nstemi) to '/tmp/rbbb_nstemi.csv' CSV HEADER;

---Step 3: Load the csv file to MIMIC database
drop table nstemi_rbbb; --
create table nstemi_rbbb (
	subject_id int
  ,hadm_id int
	,rbbb_flag int
);
\copy nstemi_rbbb FROM '/tmp/rbbb.csv' DELIMITER ',' CSV HEADER NULL ''

--- Step 4: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.

drop view temp cascade;
create view temp as
SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
	,e.rbbb_flag
from nstemi_ccu ids
left join nstemi_rbbb e
on ids.subject_id = e.subject_id
group by ids.subject_id, ids.hadm_id, ids.icustay_id, e.rbbb_flag
order by ids.subject_id;

\copy (SELECT * FROM temp) to '/tmp/temp.csv' CSV HEADER;
