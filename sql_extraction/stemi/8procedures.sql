-- ---
-- Blanca Vázquez <blancavazquez2013@gmail.com>
-- IIMAS, UNAM
-- 2020

-- -------------------------------------------------------------------------
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- -------------------------------------------------------------------------

-- Title: Extraction of procedures
-- Notes: This query extracts information about whether patient required an endotracheal tube for breathing
---       Before to execute this query, is neccesary create the table "gcsfirstday"
---       The description of this table is: https://github.com/MIT-LCP/mimic-code/blob/master/concepts/firstday/gcs-first-day.sql
-- ---
drop view proce_stemi cascade;
create view proce_stemi as
select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id

,CASE WHEN icd9_code in ('8856','8855') then '1' END as Coronary_arteriography
,CASE WHEN icd9_code = '9920' then '1' END as Injection_or_infusion_of_platelet_inhibitor
,CASE WHEN icd9_code = '3723' then '1' END as Combined_right_and_left_heart_cardiac_catheterization
,CASE WHEN icd9_code = '3722' then '1' END as Replacement_of_tracheostomy_tube
,CASE WHEN icd9_code = '3606' then '1' END as Insertion_of_non_drug_eluting_coronary_artery_stent
,CASE WHEN icd9_code = '3607' then '1' END as Insertion_of_drug_eluting_coronary_artery_stent
,CASE WHEN icd9_code = '8853' then '1' END as Angiocardiography_of_left_heart_structures
,CASE WHEN icd9_code = '9604' then '1' END as Insertion_of_endotracheal_tube
,CASE WHEN icd9_code = '3961' then '1' END as Extracorporeal_circulation_auxiliary_to_open_heart_surgery
,CASE WHEN icd9_code = '3761' then '1' END as Implant_of_pulsation_balloon
,CASE WHEN icd9_code = '3893' then '1' END as Venous_catheterization
,CASE WHEN icd9_code in ('3615', '3612', '3613') then '1' END as bypass
,CASE WHEN icd9_code = '8852' then '1' END as Angiocardiography_of_right_heart_structures
,CASE WHEN icd9_code = '3891' then '1' END as Arterial_catheterization
,CASE WHEN icd9_code = '3778' then '1' END as Insertion_of_temporary_transvenous_pacemaker_system--#marcapasos

from stemi_ccu ids
inner join procedures_icd pro
on ids.subject_id = pro.subject_id and ids.hadm_id = pro.hadm_id
where ids.los >1.0 --- me aseguro que sean pacientes que estuvieron más de un día en ICU
group by ids.subject_id, ids.hadm_id,ids.icustay_id, pro.icd9_code
order by ids.subject_id,ids.hadm_id,ids.icustay_id;
\copy (SELECT * FROM proce_stemi) to '/tmp/proce_stemi.csv' CSV HEADER;


drop view endotrach_stemi;
create view endotrach_stemi as
select
	ids.subject_id,
	ids.hadm_id,
	ids.icustay_id,
	gcs.endotrachflag

from gcsfirstday gcs
inner join stemi_ccu ids --- for stemi to use stemi_ccu
on gcs.subject_id = ids.subject_id  and gcs.hadm_id = ids.hadm_id and gcs.icustay_id = ids.icustay_id
where ids.los >1 ----length ICU stay > 24 hours
order by ids.subject_id,ids.hadm_id,ids.icustay_id;
\copy (SELECT * FROM endotrach_stemi) to '/tmp/endotrach_stemi.csv' CSV HEADER;