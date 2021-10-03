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
-- ------------------------------------------------------------------
-- Title: Extraction of laboratory results
-- Notes: This query extracts information about whether patient required an endotracheal tube for breathing
---       Before to execute this query, is neccesary create the table "gcsfirstday"
---       The description of this table is: https://github.com/MIT-LCP/mimic-code/blob/master/concepts/firstday/gcs-first-day.sql
-- ------------------------------------------------------------------

drop view lab_stemi cascade;
create view lab_stemi as
select
  e.subject_id
  ,e.hadm_id
  ,e.icustay_id

, avg(case when ce.itemid in (50868) then valuenum else null end) as anion_gap_avg
, avg(case when ce.itemid in (50862) then valuenum else null end) as albumin_avg
, avg(case when ce.itemid in (51144) then valuenum else null end) as bands_avg
, avg(case when ce.itemid in (50912,51082,51081) then valuenum else null end) as creatinine_avg
, avg(case when ce.itemid in (51099) then valuenum else null end) as protein_creatinine_ratio_avg
, avg(case when ce.itemid in (51214) then valuenum else null end) as fibrinogen_avg
, avg(case when ce.itemid in (51007) then valuenum else null end) as uric_acid_avg
, avg(case when ce.itemid in (51000) then valuenum else null end) as triglycerides_avg
, avg(case when ce.itemid in (50826) then valuenum else null end) as tidal_Volume_avg
, avg(case when ce.itemid in (50819) then valuenum else null end) as positive_end_expiratory_pressure_avg
, avg(case when ce.itemid in (51200) then valuenum else null end) as eosinophils_avg
, avg(case when ce.itemid in (51256) then valuenum else null end) as neutrophils_avg
, avg(case when ce.itemid in (51244) then valuenum else null end) as lymphocytes_avg
, avg(case when ce.itemid in (51146) then valuenum else null end) as basophils_avg
, avg(case when ce.itemid in (51254) then valuenum else null end) as monocytes_avg
, avg(case when ce.itemid in (50907) then valuenum else null end) as cholesterol_total_avg
, avg(case when ce.itemid in (50904) then valuenum else null end) as cholesterol_hdl_avg
, avg(case when ce.itemid in (50906) then valuenum else null end) as cholesterol_ldl_measured_avg
, avg(case when ce.itemid in (50852) then valuenum else null end) as hemoglobin_a1c_avg
, avg(case when ce.itemid in (51265) then valuenum else null end) as platelet_avg
, avg(case when ce.itemid in (50822, 50971) then valuenum else null end) as potassium_avg
, avg(case when ce.itemid in (51275) then valuenum else null end) as partial_thromboplastin_time_avg ---| HEMATOLOGY | BLOOD | 474937 ---PTT
, avg(case when ce.itemid in (51237) then valuenum else null end) as international_normalized_ratio_avg ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
, avg(case when ce.itemid in (51274) then valuenum else null end) as prothrombin_time_avg -- PT | HEMATOLOGY | BLOOD | 469090
, avg(case when ce.itemid in (50983,50824) then valuenum else null end) as sodium_avg -- SODIUM | CHEMISTRY | BLOOD | 808489
, avg(case when ce.itemid in (51006) then valuenum else null end) as urea_avg -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
, avg(case when ce.itemid in (51301,51300) then valuenum else null end) as white_blood_cells_avg -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
, avg(case when ce.itemid in (50810) then valuenum else null end) as hematocrit_avg
, avg(case when ce.itemid in (50811) then valuenum else null end) as hemoblobin_avg
, avg(case when ce.itemid in (51002) then valuenum else null end) as troponin_i_avg
, avg(case when ce.itemid in (51003) then valuenum else null end) as troponin_t_avg
, avg(case when ce.itemid in (50809,807,811,1529,3745,3744,225664,220621,226537) then valuenum else null end) as glucose_avg
, avg(case when ce.itemid in (50889) then valuenum else null end) as creactive_avg
, avg(case when ce.itemid in (50910) then valuenum else null end) as creatine_kinase_ck_avg
, avg(case when ce.itemid in (50911) then valuenum else null end) as creatine_kinase_mb_avg

, min(case when ce.itemid in (50868) then valuenum else null end) as anion_gap_min
, min(case when ce.itemid in (50862) then valuenum else null end) as albumin_min
, min(case when ce.itemid in (51144) then valuenum else null end) as bands_min
, min(case when ce.itemid in (50912,51082,51081) then valuenum else null end) as creatinine_min
, min(case when ce.itemid in (51099) then valuenum else null end) as protein_creatinine_ratio_min
, min(case when ce.itemid in (51214) then valuenum else null end) as fibrinogen_min
, min(case when ce.itemid in (51007) then valuenum else null end) as uric_acid_min
, min(case when ce.itemid in (51000) then valuenum else null end) as triglycerides_min
, min(case when ce.itemid in (50826) then valuenum else null end) as tidal_Volume_min
, min(case when ce.itemid in (50819) then valuenum else null end) as positive_end_expiratory_pressure_min
, min(case when ce.itemid in (51200) then valuenum else null end) as eosinophils_min
, min(case when ce.itemid in (51256) then valuenum else null end) as neutrophils_min
, min(case when ce.itemid in (51244) then valuenum else null end) as lymphocytes_min
, min(case when ce.itemid in (51146) then valuenum else null end) as basophils_min
, min(case when ce.itemid in (51254) then valuenum else null end) as monocytes_min
, min(case when ce.itemid in (50907) then valuenum else null end) as cholesterol_total_min
, min(case when ce.itemid in (50904) then valuenum else null end) as cholesterol_hdl_min
, min(case when ce.itemid in (50906) then valuenum else null end) as cholesterol_ldl_measured_min
, min(case when ce.itemid in (50852) then valuenum else null end) as hemoglobin_a1c_min
, min(case when ce.itemid in (51265) then valuenum else null end) as platelet_min
, min(case when ce.itemid in (50822, 50971) then valuenum else null end) as potassium_min
, min(case when ce.itemid in (51275) then valuenum else null end) as partial_thromboplastin_time_min ---| HEMATOLOGY | BLOOD | 474937 ---PTT
, min(case when ce.itemid in (51237) then valuenum else null end) as international_normalized_ratio_min ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
, min(case when ce.itemid in (51274) then valuenum else null end) as prothrombin_time_min -- PT | HEMATOLOGY | BLOOD | 469090
, min(case when ce.itemid in (50983,50824) then valuenum else null end) as sodium_min -- SODIUM | CHEMISTRY | BLOOD | 808489
, min(case when ce.itemid in (51006) then valuenum else null end) as urea_min -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
, min(case when ce.itemid in (51301,51300) then valuenum else null end) as white_blood_cells_min -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
, min(case when ce.itemid in (50810) then valuenum else null end) as hematocrit_min
, min(case when ce.itemid in (50811) then valuenum else null end) as hemoblobin_min
, min(case when ce.itemid in (51002) then valuenum else null end) as troponin_i_min
, min(case when ce.itemid in (51003) then valuenum else null end) as troponin_t_min
, min(case when ce.itemid in (50809,807,811,1529,3745,3744,225664,220621,226537) then valuenum else null end) as glucose_min
, min(case when ce.itemid in (50889) then valuenum else null end) as creactive_min
, min(case when ce.itemid in (50910) then valuenum else null end) as creatine_kinase_ck_min
, min(case when ce.itemid in (50911) then valuenum else null end) as creatine_kinase_mb_min

, max(case when ce.itemid in (50868) then valuenum else null end) as anion_gap_max
, max(case when ce.itemid in (50862) then valuenum else null end) as albumin_max
, max(case when ce.itemid in (51144) then valuenum else null end) as bands_max
, max(case when ce.itemid in (50912,51082,51081) then valuenum else null end) as creatinine_max
, max(case when ce.itemid in (51099) then valuenum else null end) as protein_creatinine_ratio_max
, max(case when ce.itemid in (51214) then valuenum else null end) as fibrinogen_max
, max(case when ce.itemid in (51007) then valuenum else null end) as uric_acid_max
, max(case when ce.itemid in (51000) then valuenum else null end) as triglycerides_max
, max(case when ce.itemid in (50826) then valuenum else null end) as tidal_Volume_max
, max(case when ce.itemid in (50819) then valuenum else null end) as positive_end_expiratory_pressure_max
, max(case when ce.itemid in (51200) then valuenum else null end) as eosinophils_max
, max(case when ce.itemid in (51256) then valuenum else null end) as neutrophils_max
, max(case when ce.itemid in (51244) then valuenum else null end) as lymphocytes_max
, max(case when ce.itemid in (51146) then valuenum else null end) as basophils_max
, max(case when ce.itemid in (51254) then valuenum else null end) as monocytes_max
, max(case when ce.itemid in (50907) then valuenum else null end) as cholesterol_total_max
, max(case when ce.itemid in (50904) then valuenum else null end) as cholesterol_hdl_max
, max(case when ce.itemid in (50906) then valuenum else null end) as cholesterol_ldl_measured_max
, max(case when ce.itemid in (50852) then valuenum else null end) as hemoglobin_a1c_max
, max(case when ce.itemid in (51265) then valuenum else null end) as platelet_max
, max(case when ce.itemid in (50822, 50971) then valuenum else null end) as potassium_max
, max(case when ce.itemid in (51275) then valuenum else null end) as partial_thromboplastin_time_max ---| HEMATOLOGY | BLOOD | 474937 ---PTT
, max(case when ce.itemid in (51237) then valuenum else null end) as international_normalized_ratio_max ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
, max(case when ce.itemid in (51274) then valuenum else null end) as prothrombin_time_max -- PT | HEMATOLOGY | BLOOD | 469090
, max(case when ce.itemid in (50983,50824) then valuenum else null end) as sodium_max -- SODIUM | CHEMISTRY | BLOOD | 808489
, max(case when ce.itemid in (51006) then valuenum else null end) as urea_max -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
, max(case when ce.itemid in (51301,51300) then valuenum else null end) as white_blood_cells_max -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
, max(case when ce.itemid in (50810) then valuenum else null end) as hematocrit_max
, max(case when ce.itemid in (50811) then valuenum else null end) as hemoblobin_max
, max(case when ce.itemid in (51002) then valuenum else null end) as troponin_i_max
, max(case when ce.itemid in (51003) then valuenum else null end) as troponin_t_max
, max(case when ce.itemid in (50809,807,811,1529,3745,3744,225664,220621,226537) then valuenum else null end) as glucose_max
, max(case when ce.itemid in (50889) then valuenum else null end) as creactive_max
, max(case when ce.itemid in (50910) then valuenum else null end) as creatine_kinase_ck_max
, max(case when ce.itemid in (50911) then valuenum else null end) as creatine_kinase_mb_max

from stemi_ccu e
inner join labevents ce
on e.subject_id = ce.subject_id and e.hadm_id = ce.hadm_id
and ce.charttime between e.intime and e.intime + interval '1' day
where e.los >1--- me aseguro que sean pacientes que estuvieron más de un día en ICU
group by e.subject_id, e.hadm_id, e.icustay_id
order by e.subject_id, e.hadm_id, e.icustay_id;

----------------- complete records
drop view lab_stemi2 cascade;
create view lab_stemi2 as
select
  ce.subject_id
  ,ce.hadm_id
  ,ce.icustay_id
  ,e.anion_gap_avg
  ,e.albumin_avg
  ,e.bands_avg
  ,e.creatinine_avg
  ,e.protein_creatinine_ratio_avg
  ,e.fibrinogen_avg
  ,e.uric_acid_avg
  ,e.triglycerides_avg
  ,e.tidal_Volume_avg
  ,e.positive_end_expiratory_pressure_avg
  ,e.eosinophils_avg
  ,e.neutrophils_avg
  ,e.lymphocytes_avg
  ,e.basophils_avg
  ,e.monocytes_avg
  ,e.cholesterol_total_avg
  ,e.cholesterol_hdl_avg
  ,e.cholesterol_ldl_measured_avg
  ,e.hemoglobin_a1c_avg
  ,e.platelet_avg
  ,e.potassium_avg
  ,e.partial_thromboplastin_time_avg ---| HEMATOLOGY | BLOOD | 474937 ---PTT
  ,e.international_normalized_ratio_avg ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
  ,e.prothrombin_time_avg -- PT | HEMATOLOGY | BLOOD | 469090
  ,e.sodium_avg -- SODIUM | CHEMISTRY | BLOOD | 808489
  ,e.urea_avg -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
  ,e.white_blood_cells_avg -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
  ,e.hematocrit_avg
  ,e.hemoblobin_avg
  ,e.troponin_i_avg
  ,e.troponin_t_avg
  ,e.glucose_avg
  ,e.creactive_avg
  ,e.creatine_kinase_ck_avg
  ,e.creatine_kinase_mb_avg

    ,e.anion_gap_min
  ,e.albumin_min
  ,e.bands_min
  ,e.creatinine_min
  ,e.protein_creatinine_ratio_min
  ,e.fibrinogen_min
  ,e.uric_acid_min
  ,e.triglycerides_min
  ,e.tidal_Volume_min
  ,e.positive_end_expiratory_pressure_min
  ,e.eosinophils_min
  ,e.neutrophils_min
  ,e.lymphocytes_min
  ,e.basophils_min
  ,e.monocytes_min
  ,e.cholesterol_total_min
  ,e.cholesterol_hdl_min
  ,e.cholesterol_ldl_measured_min
  ,e.hemoglobin_a1c_min
  ,e.platelet_min
  ,e.potassium_min
  ,e.partial_thromboplastin_time_min ---| HEMATOLOGY | BLOOD | 474937 ---PTT
  ,e.international_normalized_ratio_min ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
  ,e.prothrombin_time_min -- PT | HEMATOLOGY | BLOOD | 469090
  ,e.sodium_min -- SODIUM | CHEMISTRY | BLOOD | 808489
  ,e.urea_min -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
  ,e.white_blood_cells_min -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
  ,e.hematocrit_min
  ,e.hemoblobin_min
  ,e.troponin_i_min
  ,e.troponin_t_min
  ,e.glucose_min
  ,e.creactive_min
  ,e.creatine_kinase_ck_min
  ,e.creatine_kinase_mb_min

    ,e.anion_gap_max
  ,e.albumin_max
  ,e.bands_max
  ,e.creatinine_max
  ,e.protein_creatinine_ratio_max
  ,e.fibrinogen_max
  ,e.uric_acid_max
  ,e.triglycerides_max
  ,e.tidal_Volume_max
  ,e.positive_end_expiratory_pressure_max
  ,e.eosinophils_max
  ,e.neutrophils_max
  ,e.lymphocytes_max
  ,e.basophils_max
  ,e.monocytes_max
  ,e.cholesterol_total_max
  ,e.cholesterol_hdl_max
  ,e.cholesterol_ldl_measured_max
  ,e.hemoglobin_a1c_max
  ,e.platelet_max
  ,e.potassium_max
  ,e.partial_thromboplastin_time_max ---| HEMATOLOGY | BLOOD | 474937 ---PTT
  ,e.international_normalized_ratio_max ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
  ,e.prothrombin_time_max -- PT | HEMATOLOGY | BLOOD | 469090
  ,e.sodium_max -- SODIUM | CHEMISTRY | BLOOD | 808489
  ,e.urea_max -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
  ,e.white_blood_cells_max -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
  ,e.hematocrit_max
  ,e.hemoblobin_max
  ,e.troponin_i_max
  ,e.troponin_t_max
  ,e.glucose_max
  ,e.creactive_max
  ,e.creatine_kinase_ck_max
  ,e.creatine_kinase_mb_max

from stemi_ccu ce
left join lab_stemi e
on e.subject_id = ce.subject_id and e.hadm_id = ce.hadm_id and e.icustay_id = ce.icustay_id
group by     
  ce.subject_id
  ,ce.hadm_id
  ,ce.icustay_id
  ,e.anion_gap_avg
  ,e.albumin_avg
  ,e.bands_avg
  ,e.creatinine_avg
  ,e.protein_creatinine_ratio_avg
  ,e.fibrinogen_avg
  ,e.uric_acid_avg
  ,e.triglycerides_avg
  ,e.tidal_Volume_avg
  ,e.positive_end_expiratory_pressure_avg
  ,e.eosinophils_avg
  ,e.neutrophils_avg
  ,e.lymphocytes_avg
  ,e.basophils_avg
  ,e.monocytes_avg
  ,e.cholesterol_total_avg
  ,e.cholesterol_hdl_avg
  ,e.cholesterol_ldl_measured_avg
  ,e.hemoglobin_a1c_avg
  ,e.platelet_avg
  ,e.potassium_avg
  ,e.partial_thromboplastin_time_avg ---| HEMATOLOGY | BLOOD | 474937 ---PTT
  ,e.international_normalized_ratio_avg ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
  ,e.prothrombin_time_avg -- PT | HEMATOLOGY | BLOOD | 469090
  ,e.sodium_avg -- SODIUM | CHEMISTRY | BLOOD | 808489
  ,e.urea_avg -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
  ,e.white_blood_cells_avg -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
  ,e.hematocrit_avg
  ,e.hemoblobin_avg
  ,e.troponin_i_avg
  ,e.troponin_t_avg
  ,e.glucose_avg
  ,e.creactive_avg
  ,e.creatine_kinase_ck_avg
  ,e.creatine_kinase_mb_avg

    ,e.anion_gap_min
  ,e.albumin_min
  ,e.bands_min
  ,e.creatinine_min
  ,e.protein_creatinine_ratio_min
  ,e.fibrinogen_min
  ,e.uric_acid_min
  ,e.triglycerides_min
  ,e.tidal_Volume_min
  ,e.positive_end_expiratory_pressure_min
  ,e.eosinophils_min
  ,e.neutrophils_min
  ,e.lymphocytes_min
  ,e.basophils_min
  ,e.monocytes_min
  ,e.cholesterol_total_min
  ,e.cholesterol_hdl_min
  ,e.cholesterol_ldl_measured_min
  ,e.hemoglobin_a1c_min
  ,e.platelet_min
  ,e.potassium_min
  ,e.partial_thromboplastin_time_min ---| HEMATOLOGY | BLOOD | 474937 ---PTT
  ,e.international_normalized_ratio_min ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
  ,e.prothrombin_time_min -- PT | HEMATOLOGY | BLOOD | 469090
  ,e.sodium_min -- SODIUM | CHEMISTRY | BLOOD | 808489
  ,e.urea_min -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
  ,e.white_blood_cells_min -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
  ,e.hematocrit_min
  ,e.hemoblobin_min
  ,e.troponin_i_min
  ,e.troponin_t_min
  ,e.glucose_min
  ,e.creactive_min
  ,e.creatine_kinase_ck_min
  ,e.creatine_kinase_mb_min

    ,e.anion_gap_max
  ,e.albumin_max
  ,e.bands_max
  ,e.creatinine_max
  ,e.protein_creatinine_ratio_max
  ,e.fibrinogen_max
  ,e.uric_acid_max
  ,e.triglycerides_max
  ,e.tidal_Volume_max
  ,e.positive_end_expiratory_pressure_max
  ,e.eosinophils_max
  ,e.neutrophils_max
  ,e.lymphocytes_max
  ,e.basophils_max
  ,e.monocytes_max
  ,e.cholesterol_total_max
  ,e.cholesterol_hdl_max
  ,e.cholesterol_ldl_measured_max
  ,e.hemoglobin_a1c_max
  ,e.platelet_max
  ,e.potassium_max
  ,e.partial_thromboplastin_time_max ---| HEMATOLOGY | BLOOD | 474937 ---PTT
  ,e.international_normalized_ratio_max ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
  ,e.prothrombin_time_max -- PT | HEMATOLOGY | BLOOD | 469090
  ,e.sodium_max -- SODIUM | CHEMISTRY | BLOOD | 808489
  ,e.urea_max -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
  ,e.white_blood_cells_max -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
  ,e.hematocrit_max
  ,e.hemoblobin_max
  ,e.troponin_i_max
  ,e.troponin_t_max
  ,e.glucose_max
  ,e.creactive_max
  ,e.creatine_kinase_ck_max
  ,e.creatine_kinase_mb_max
order by ce.subject_id, ce.hadm_id, ce.icustay_id;


\copy (SELECT * FROM lab_stemi2) to '/tmp/lab_stemi2.csv' CSV HEADER;


