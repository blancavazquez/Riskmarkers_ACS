-- ------------------------------------------------------------------
-- Title: Extraction of procedures
-- Notes: This query extracts information about procedures that patients received during their ICU stay.
-- ------------------------------------------------------------------
drop view procedimientos_nstemi cascade;
create view procedimientos_nstemi as
select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id

,CASE WHEN icd9_code = '8856' then '1' END as Coronary_arteriography_using_two_catheters
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
,CASE WHEN icd9_code = '3615' then '1' END as Single_internal_mammary_coronary_artery_bypass
,CASE WHEN icd9_code = '8852' then '1' END as Angiocardiography_of_right_heart_structures
,CASE WHEN icd9_code = '8855' then '1' END as Coronary_arteriography_using_a_single_catheter
,CASE WHEN icd9_code = '3612' then '1' END as Aorto_coronary_bypass_of_two_coronary_arteries
,CASE WHEN icd9_code = '3891' then '1' END as Arterial_catheterization
,CASE WHEN icd9_code = '3613' then '1' END as Aorto_coronary_bypass_of_three_coronary_arteries
,CASE WHEN icd9_code = '3778' then '1' END as Insertion_of_temporary_transvenous_pacemaker_system--#marcapasos

from nstemi_ccu ids--- for stemi to use stemi_ccu
inner join procedures_icd pro
on ids.subject_id = pro.subject_id and ids.hadm_id = pro.hadm_id
where ids.los >1.0 ----length ICU stay > 24 hours
group by ids.subject_id, ids.hadm_id,ids.icustay_id, pro.icd9_code
order by ids.subject_id;

--- Step 2: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.

drop view procedimientos;
create view procedimientos as
select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id

,pro.Coronary_arteriography_using_two_catheters
,pro.Injection_or_infusion_of_platelet_inhibitor
,pro.Combined_right_and_left_heart_cardiac_catheterization
,pro.Replacement_of_tracheostomy_tube
,pro.Insertion_of_non_drug_eluting_coronary_artery_stent
,pro.Insertion_of_drug_eluting_coronary_artery_stent
,pro.Angiocardiography_of_left_heart_structures
,pro.Insertion_of_endotracheal_tube
,pro.Extracorporeal_circulation_auxiliary_to_open_heart_surgery
,pro.Implant_of_pulsation_balloon
,pro.Venous_catheterization
,pro.Single_internal_mammary_coronary_artery_bypass
,pro.Angiocardiography_of_right_heart_structures
,pro.Coronary_arteriography_using_a_single_catheter
,pro.Aorto_coronary_bypass_of_two_coronary_arteries
,pro.Arterial_catheterization
,pro.Aorto_coronary_bypass_of_three_coronary_arteries
,pro.Insertion_of_temporary_transvenous_pacemaker_system

from nstemi_ccu ids --- for stemi to use stemi_ccu
left join procedimientos_nstemi pro
on ids.subject_id = pro.subject_id
where ids.los > 1.0
order by ids.subject_id;
\copy (SELECT * FROM procedimientos) to '/tmp/procedimientos.csv' CSV HEADER;
