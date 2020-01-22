-- ------------------------------------------------------------------
-- Title: Extraction of weight at admission
-- Notes: This query extracts static informacion about the weight patient at admission
---       Before to execute this query, is neccesary create the table "weightfirstday"
---       The description of this table is: https://github.com/MIT-LCP/mimic-code/blob/master/concepts/firstday/weight-first-day.sql
-- ------------------------------------------------------------------

drop view nstemi_peso;
create view nstemi_peso as --- creamos una tabla unicamente con ids y peso para nnstemi
select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,peso.weight_admit

from nstemi_ccu ids --- for stemi to use stemi_ccu
inner join weightfirstday peso
on ids.icustay_id = peso.icustay_id
where ids.los >1.0 ----length ICU stay > 24 hours
order by ids.subject_id;

\copy (SELECT * FROM nstemi_peso) to '/tmp/nstemi_peso.csv' CSV HEADER;
