-- ------------------------------------------------------------------
-- Title: Extraction of lab results and blood gas
-- Notes: This query extracts information about lab results and blood gas
--				For each variable, the min, max and avg were extracted
-- ------------------------------------------------------------------

--- Step 1: extract results for each patient
drop view nstemi_dynamic cascade;
create view nstemi_dynamic as

SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
	,ids.icustay_expire_flag
-- ---- vars: blood_gas
, avg(case when ce.itemid in (50801) then valuenum else null end) as alveolar_arterial_gradient ---Gradiente alveolo-arterial of O2
, avg(case when ce.itemid in (50802) then valuenum else null end) as BASEEXCESS
, avg(case when ce.itemid in (50803) then valuenum else null end) as BICARBONATE
, avg(case when ce.itemid in (50804) then valuenum else null end) as TOTALCO2
, avg(case when ce.itemid in (50806) then valuenum else null end) as CHLORIDE
, avg(case when ce.itemid in (50808) then valuenum else null end) as CALCIUM
, avg(case when ce.itemid in (50813) then valuenum else null end) as LACTATE
, avg(case when ce.itemid in (50815) then valuenum else null end) as O2FLOW
, avg(case when ce.itemid in (50816) then valuenum else null end) as FIO2
, avg(case when ce.itemid in (50817) then valuenum else null end) as SO2-- OXYGENSATURATION
, avg(case when ce.itemid in (50818) then valuenum else null end) as PCO2
, avg(case when ce.itemid in (50820) then valuenum else null end) as PH
, avg(case when ce.itemid in (50821) then valuenum else null end) as PO2
, avg(case when ce.itemid in (50825) then valuenum else null end) as TEMPERATURE

-- ---- vars: laboratorio
, avg(case when ce.itemid in (50868) then valuenum else null end) as anion_gap
, avg(case when ce.itemid in (50862) then valuenum else null end) as ALBUMIN
, avg(case when ce.itemid in (51144) then valuenum else null end) as BANDS
, avg(case when ce.itemid in (50912,51082,51081) then valuenum else null end) as CREATININE
, avg(case when ce.itemid in (51099) then valuenum else null end) as protein_creatinine_ratio --Protein/Creatinine Ratio
, avg(case when ce.itemid in (51214) then valuenum else null end) as Fibrinogen
, avg(case when ce.itemid in (51007) then valuenum else null end) as Uric_acid
, avg(case when ce.itemid in (51000) then valuenum else null end) as Triglycerides
, avg(case when ce.itemid in (51091) then valuenum else null end) as Myoglobin_urine
, avg(case when ce.itemid in (50826) then valuenum else null end) as Tidal_Volume
, avg(case when ce.itemid in (50819) then valuenum else null end) as positive_end_expiratory_pressure----PEEP
, avg(case when ce.itemid in (51200) then valuenum else null end) as Eosinophils
, avg(case when ce.itemid in (51256) then valuenum else null end) as Neutrophils
, avg(case when ce.itemid in (51244) then valuenum else null end) as Lymphocytes
, avg(case when ce.itemid in (51146) then valuenum else null end) as Basophils
, avg(case when ce.itemid in (51254) then valuenum else null end) as Monocytes
, avg(case when ce.itemid in (50907) then valuenum else null end) as Cholesterol_Total
, avg(case when ce.itemid in (50904) then valuenum else null end) as Cholesterol_HDL
, avg(case when ce.itemid in (50906) then valuenum else null end) as Cholesterol_LDL_Measured
, avg(case when ce.itemid in (50852) then valuenum else null end) as Hemoglobin_A1c
, avg(case when ce.itemid in (51265) then valuenum else null end) as PLATELET
, avg(case when ce.itemid in (50822, 50971) then valuenum else null end) as POTASSIUM
, avg(case when ce.itemid in (51275) then valuenum else null end) as partial_thromboplastin_time ---| HEMATOLOGY | BLOOD | 474937 ---PTT
, avg(case when ce.itemid in (51237) then valuenum else null end) as international_normalized_ratio ---INR(PT) | HEMATOLOGY | BLOOD | 471183 --The INR is derived from prothrombin time (PT) which is calculated as a ratio of the patient's PT to a control PT standardized for the potency of the thromboplastin reagent
, avg(case when ce.itemid in (51274) then valuenum else null end) as prothrombin_time -- PT | HEMATOLOGY | BLOOD | 469090
, avg(case when ce.itemid in (50983,50824) then valuenum else null end) as SODIUM -- SODIUM | CHEMISTRY | BLOOD | 808489
, avg(case when ce.itemid in (51006) then valuenum else null end) as urea -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
, avg(case when ce.itemid in (51301,51300) then valuenum else null end) as white_blood_cells -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
, avg(case when ce.itemid in (50810) then valuenum else null end) as HEMATOCRIT
, avg(case when ce.itemid in (50811) then valuenum else null end) as HEMOGLOBIN
, min(case when ce.itemid in (51002) then valuenum else null end) as TROPONIN_I_min
, max(case when ce.itemid in (51002) then valuenum else null end) as TROPONIN_I_max
, min(case when ce.itemid in (51003) then valuenum else null end) as TROPONIN_T_min
, max(case when ce.itemid in (51003) then valuenum else null end) as TROPONIN_T_max
, min(case when ce.itemid in (50809,807,811,1529,3745,3744,225664,220621,226537) then valuenum else null end) as GLUCOSE_min
, max(case when ce.itemid in (50809,807,811,1529,3745,3744,225664,220621,226537) then valuenum else null end) as GLUCOSE_max
, min(case when ce.itemid in (50889) then valuenum else null end) as CReactive_min
, max(case when ce.itemid in (50889) then valuenum else null end) as CReactive_max
, min(case when ce.itemid in (50910) then valuenum else null end) as Creatine_kinase_CK_min
, max(case when ce.itemid in (50910) then valuenum else null end) as Creatine_kinase_CK_max
, min(case when ce.itemid in (50911) then valuenum else null end) as Creatine_kinase_MB_min
, max(case when ce.itemid in (50911) then valuenum else null end) as Creatine_kinase_MB_max

from nstemi_ccu ids --- for stemi to use stemi_ccu
inner join labevents ce
on ids.subject_id = ce.subject_id and ids.hadm_id = ce.hadm_id
and ce.charttime between ids.intime and ids.intime + interval '1' day ---- This is important: we only extracted results extracted during the first 24 hours
where ids.los >1----length ICU stay > 24 hours
group by ids.subject_id, ids.hadm_id, ids.icustay_id, ids.icustay_expire_flag
order by ids.subject_id, ids.hadm_id, ids.icustay_id;

--- Step 2: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.

drop view nstemi_lab_blood;
create view nstemi_lab_blood as
SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
-- ---- vars: blood_gas
,var.alveolar_arterial_gradient
,var.BASEEXCESS
,var.BICARBONATE
,var.TOTALCO2
,var.CHLORIDE
,var.CALCIUM
,var.LACTATE
,var.O2FLOW
,var.FIO2
,var.SO2-- OXYGENSATURATION
,var.PCO2
,var.PH
,var.PO2
,var.TEMPERATURE
---- vars: laboratorio
,var.anion_gap
,var.ALBUMIN
,var.BANDS
,var.CREATININE
,var.protein_creatinine_ratio
,var.Fibrinogen
,var.Uric_acid
,var.Triglycerides
,var.Myoglobin_urine
,var.positive_end_expiratory_pressure
,var.Eosinophils
,var.Neutrophils
,var.Lymphocytes
,var.Basophils
,var.Monocytes
,var.Cholesterol_Total
,var.Cholesterol_HDL
,var.Cholesterol_LDL_Measured
,var.Hemoglobin_A1c
,var.PLATELET
,var.POTASSIUM
,var.partial_thromboplastin_time ---| HEMATOLOGY | BLOOD | 474937
,var.international_normalized_ratio ---INR(PT) | HEMATOLOGY | BLOOD | 471183
,var.prothrombin_time -- PT | HEMATOLOGY | BLOOD | 469090
,var.SODIUM -- SODIUM | CHEMISTRY | BLOOD | 808489
,var.urea -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
,var.white_blood_cells -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
,var.HEMATOCRIT
,var.HEMOGLOBIN
,var.TROPONIN_I_min
,var.TROPONIN_I_max
,var.TROPONIN_T_min
,var.TROPONIN_T_max
,var.GLUCOSE_min
,var.GLUCOSE_max
,var.CReactive_min
,var.CReactive_max
,var.Creatine_kinase_CK_min
,var.Creatine_kinase_CK_max
,var.Creatine_kinase_MB_min
,var.Creatine_kinase_MB_max

from nstemi_ccu ids --- for stemi to use stemi_ccu
left join nstemi_dynamic var
on ids.subject_id = var.subject_id and ids.hadm_id = var.hadm_id and ids.icustay_id = var.icustay_id
where ids.los >1--- me aseguro que sean pacientes que estuvieron más de un día en ICU
order by ids.subject_id, ids.hadm_id, ids.icustay_id;
\copy (SELECT * FROM nstemi_lab_blood) to '/tmp/nstemi_lab_blood.csv' CSV HEADER;
