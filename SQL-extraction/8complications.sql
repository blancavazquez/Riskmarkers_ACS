-- ------------------------------------------------------------------
-- Title: Extraction of complications
-- Notes: This query extracts information about complications that patients presented during their ICU stay.
-- ------------------------------------------------------------------

drop view complicaciones_nstemi;
create view complicaciones_nstemi as
select
  ids.subject_id,
  ids.hadm_id,
  ids.icustay_id

,CASE WHEN dx.icd9_code = '4264' then '1' else '0' END as rbbb
,CASE WHEN dx.icd9_code in ('4263', '4262') then '1' else '0' END as lbbb
,CASE WHEN dx.icd9_code in ('4260', '42610') then '1' else '0' END as av_block
,CASE WHEN dx.icd9_code = '42731' then '1' else '0' END as atrial_fibrillation
,CASE WHEN dx.icd9_code = '42741'then '1' else '0' END as ventricular_fibrillation
,CASE WHEN dx.icd9_code = '4271' then '1' else '0' END as ventricular_tachycardia
,CASE WHEN dx.icd9_code = '78551' then '1' else '0' END as cardiogenic_shock
,CASE WHEN dx.icd9_code = '5061' then '1' else '0' END as pulmonary_edema --no resultados con nstemi / stemi / ccu
,CASE WHEN dx.icd9_code = '3963' then '1' else '0' END as mitral_regurgitation
,CASE WHEN dx.icd9_code in ('41080', '41081', '41082') then '1' else '0' END as septal_rupture -- no resultados para nstemi
,CASE WHEN dx.icd9_code in ('41090') then '1' else '0' END as free_wall_rupture--no resultados con nstemi / stemi / ccu
,CASE WHEN dx.icd9_code in ('4200', '42090', '42091', '42099', '4231', '4232',
                            '42090', '393') then '1' else '0' END as pericarditis
,CASE WHEN dx.icd9_code = '5849' then '1' else '0' END as Renal_failure
,CASE WHEN dx.icd9_code in ('4130', '4131', '4139') then '1' else '0' END as angina
,CASE WHEN dx.icd9_code in ('43491','43411','V1254', '4359', '43401') then '1' else '0' END as cerebrovascular_accident
,CASE WHEN dx.icd9_code = '4275' then '1' else '0' END as cardiac_arrest
,CASE WHEN dx.icd9_code = '4280' then '1' else '0' END as congestive_heart_failure
,CASE WHEN dx.icd9_code = '496' then '1' else '0' END as Chronic_airway_obstruction
,CASE WHEN dx.icd9_code in ('4010', '4011', '4019') then '1' else '0' END as hypertension
,CASE WHEN dx.icd9_code in ('41410', '41411') then '1' else '0' END as Aneurysm
,CASE WHEN dx.icd9_code in ('25000', '25001','25002', '25003', '25010', '25011', '25012', '25013', '25020', '25021') then '1' END as diabetes
,CASE WHEN dx.icd9_code = '3051' then '1' END as tobacco
,CASE WHEN dx.icd9_code in ('30500', '30501', '30502', '30503') then '1' END as alcohol_abuse

from nstemi_ccu ids --- for stemi patients to use stemi_ccu
inner join diagnoses_icd dx
on ids.subject_id = dx.subject_id and ids.hadm_id = dx.hadm_id
where ids.los >1.0 ----length ICU stay > 24 hours
group by ids.subject_id, ids.hadm_id, ids.icustay_id, dx.icd9_code
order by ids.subject_id;
\copy (SELECT * FROM complicaciones_nstemi) to '/tmp/complicaciones_nstemi.csv' CSV HEADER;
