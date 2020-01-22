-- ------------------------------------------------------------------
-- Title: Extraction of procedures
-- Notes: This query extracts information about whether patient required an endotracheal tube for breathing
---       Before to execute this query, is neccesary create the table "gcsfirstday"
---       The description of this table is: https://github.com/MIT-LCP/mimic-code/blob/master/concepts/firstday/gcs-first-day.sql
-- ------------------------------------------------------------------

drop view glascow_nstemi;
create view glascow_nstemi as
select
ids.subject_id,
ids.hadm_id,
ids.icustay_id,
endotrachflag

from gcsfirstday gcs
inner join nstemi_ccu ids --- for stemi to use stemi_ccu
on gcs.subject_id = ids.subject_id  and gcs.hadm_id = ids.hadm_id and gcs.icustay_id = ids.icustay_id
where ids.los >1 ----length ICU stay > 24 hours
order by ids.subject_id;
\copy (SELECT * FROM glascow_nstemi) to '/tmp/glascow_nstemi.csv' CSV HEADER;
