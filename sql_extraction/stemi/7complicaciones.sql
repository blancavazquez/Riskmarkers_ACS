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

-- Code for obtaining complications data for STEMI patients
-- ---


drop view complicaciones_stemi_rm cascade;
create view complicaciones_stemi_rm as
select
  ids.subject_id,
  ids.hadm_id,
  ids.icustay_id

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
,CASE WHEN dx.icd9_code = '5849' then '1' else '0' END as renal_failure
,CASE WHEN dx.icd9_code in ('4130', '4131', '4139') then '1' else '0' END as angina
,CASE WHEN dx.icd9_code in ('43491','43411','V1254', '4359', '43401') then '1' else '0' END as cerebrovascular_accident
,CASE WHEN dx.icd9_code = '4275' then '1' else '0' END as cardiac_arrest
,CASE WHEN dx.icd9_code = '4280' then '1' else '0' END as congestive_heart_failure
,CASE WHEN dx.icd9_code = '496' then '1' else '0' END as Chronic_airway_obstruction
,CASE WHEN dx.icd9_code in ('41410', '41411') then '1' else '0' END as Aneurysm
,CASE WHEN dx.icd9_code in ('25000', '25001','25002', '25003', '25010', '25011', '25012', '25013', '25020', '25021') then '1' END as diabetes

from stemi_ccu ids
inner join diagnoses_icd dx
on ids.subject_id = dx.subject_id and ids.hadm_id = dx.hadm_id
where ids.los >1.0 --- me aseguro que sean pacientes que estuvieron más de un día en ICU
group by ids.subject_id, ids.hadm_id, ids.icustay_id, dx.icd9_code
order by ids.subject_id;


------------Join: complicaciones_stemi_rm+ stemi_rbbb
drop view complicaciones_stemi_rm_rbbb;
create view complicaciones_stemi_rm_rbbb as
select 
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,ids.av_block
  ,rbbb.rbbb_flag
  ,ids.atrial_fibrillation
  ,ids.ventricular_fibrillation
  ,ids.ventricular_tachycardia
  ,ids.cardiogenic_shock
  ,ids.pulmonary_edema --no resultados con nstemi / stemi / ccu
  ,ids.mitral_regurgitation
  ,ids.septal_rupture -- no resultados para nstemi
  ,ids.free_wall_rupture--no resultados con nstemi / stemi / ccu
  ,ids.pericarditis
  ,ids.renal_failure
  ,ids.angina
  ,ids.cerebrovascular_accident
  ,ids.cardiac_arrest
  ,ids.congestive_heart_failure
  ,ids.Chronic_airway_obstruction
  ,ids.Aneurysm
  ,ids.diabetes
from complicaciones_stemi_rm ids
left join stemi_rbbb rbbb
on ids.subject_id = rbbb.subject_id and ids.hadm_id = rbbb.hadm_id
group by   
   ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,ids.av_block
  ,rbbb.rbbb_flag
  ,ids.atrial_fibrillation
  ,ids.ventricular_fibrillation
  ,ids.ventricular_tachycardia
  ,ids.cardiogenic_shock
  ,ids.pulmonary_edema --no resultados con nstemi / stemi / ccu
  ,ids.mitral_regurgitation
  ,ids.septal_rupture -- no resultados para nstemi
  ,ids.free_wall_rupture--no resultados con nstemi / stemi / ccu
  ,ids.pericarditis
  ,ids.renal_failure
  ,ids.angina
  ,ids.cerebrovascular_accident
  ,ids.cardiac_arrest
  ,ids.congestive_heart_failure
  ,ids.Chronic_airway_obstruction
  ,ids.Aneurysm
  ,ids.diabetes
order by ids.subject_id;

------------Join: complicaciones_stemi_rm+ stemi_rbbb + stemi_lbbb
drop view complicaciones_stemi_rm_rbbb_lbbb;
create view complicaciones_stemi_rm_rbbb_lbbb as
select 
   ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,ids.av_block
  ,ids.rbbb_flag
  ,ids.atrial_fibrillation
  ,ids.ventricular_fibrillation
  ,ids.ventricular_tachycardia
  ,ids.cardiogenic_shock
  ,ids.pulmonary_edema --no resultados con nstemi / stemi / ccu
  ,ids.mitral_regurgitation
  ,ids.septal_rupture -- no resultados para nstemi
  ,ids.free_wall_rupture--no resultados con nstemi / stemi / ccu
  ,ids.pericarditis
  ,ids.renal_failure
  ,ids.angina
  ,ids.cerebrovascular_accident
  ,ids.cardiac_arrest
  ,ids.congestive_heart_failure
  ,ids.Chronic_airway_obstruction
  ,ids.Aneurysm
  ,ids.diabetes
  ,left_bbb.lbbb_flag

from complicaciones_stemi_rm_rbbb ids
left join stemi_lbbb left_bbb
on ids.subject_id = left_bbb.subject_id and ids.hadm_id = left_bbb.hadm_id
group by   
   ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,ids.av_block
  ,ids.rbbb_flag
  ,ids.atrial_fibrillation
  ,ids.ventricular_fibrillation
  ,ids.ventricular_tachycardia
  ,ids.cardiogenic_shock
  ,ids.pulmonary_edema --no resultados con nstemi / stemi / ccu
  ,ids.mitral_regurgitation
  ,ids.septal_rupture -- no resultados para nstemi
  ,ids.free_wall_rupture--no resultados con nstemi / stemi / ccu
  ,ids.pericarditis
  ,ids.renal_failure
  ,ids.angina
  ,ids.cerebrovascular_accident
  ,ids.cardiac_arrest
  ,ids.congestive_heart_failure
  ,ids.Chronic_airway_obstruction
  ,ids.Aneurysm
  ,ids.diabetes
  ,left_bbb.lbbb_flag
order by ids.subject_id;

\copy (SELECT * FROM complicaciones_stemi_rm_rbbb_lbbb) to '/tmp/complicaciones_stemi_rm_rbbb_lbbb.csv' CSV HEADER;


----------------------------- Extraction of leads (depression ST)

drop view leads_stemi cascade;
create view leads_stemi as
SELECT
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,e.i_lead
  ,e.ii_lead
  ,e.iii_lead
  ,e.v1_lead
  ,e.v2_lead
  ,e.v3_lead
  ,e.v4_lead
  ,e.v5_lead
  ,e.v6_lead
  ,e.avf_lead
  ,e.avr_lead
  ,e.avl_lead
  ,e.f
  ,e.v1r
  ,e.v2r
  ,e.t_wave
  ,e.qtc_wave

from stemi_ccu ids
left join stemi_depression e
on ids.subject_id = e.subject_id and ids.hadm_id = e.hadm_id
group by ids.subject_id
        ,ids.hadm_id
        ,ids.icustay_id
        ,e.i_lead
        ,e.ii_lead
        ,e.iii_lead
        ,e.v1_lead
        ,e.v2_lead
        ,e.v3_lead
        ,e.v4_lead
        ,e.v5_lead
        ,e.v6_lead
        ,e.avf_lead
        ,e.avr_lead
        ,e.avl_lead
        ,e.f
        ,e.v1r
        ,e.v2r
        ,e.t_wave
        ,e.qtc_wave
order by ids.subject_id;

\copy (SELECT * FROM leads_stemi) to '/tmp/leads_stemi.csv' CSV HEADER;

