-- ------------------------------------------------------------------
-- Title: Extraction of procedures
-- Notes: This query extracts information about whether patient required ventilation during ICU stay
---       Before to execute this query, is neccesary create the table "ventfirstday"
---       The description of this table is: https://github.com/MIT-LCP/mimic-code/blob/master/concepts/firstday/ventilation-first-day.sql
-- ------------------------------------------------------------------

drop view ventilacion_nstemi;
create view ventilacion_nstemi as
select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,vent.vent
from ventfirstday vent
inner join nstemi_ccu ids --- for stemi to use stemi_ccu
on vent.subject_id = ids.subject_id  and vent.hadm_id = ids.hadm_id and vent.icustay_id = ids.icustay_id
where ids.los >1  ----length ICU stay > 24 hours
order by ids.subject_id;
\copy (SELECT * FROM ventilacion_nstemi) to '/tmp/ventilacion_nstemi.csv' CSV HEADER;
