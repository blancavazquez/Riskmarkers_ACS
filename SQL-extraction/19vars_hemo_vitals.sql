-- ------------------------------------------------------------------
-- Title: Extraction of hemodynamic and vital signs
-- Notes: This query extracts information about hemodynamic and vital signs
--				For each variable, the min, max and avg were extracted
-- ------------------------------------------------------------------

--- Step 1: extract results for each patient
drop view pat_dynamic_vars cascade;
create view pat_dynamic_vars as

SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
	,ids.icustay_expire_flag

---- vars: hemodinamia
, min(case when ce.itemid in (1367,1371,224842) then valuenum else null end) as cardiac_out_min
, max(case when ce.itemid in (1367,1371,224842) then valuenum else null end) as cardiac_out_max
, min(case when ce.itemid in (226,5856,220765) then valuenum else null end) as intra_craneal_pressure_min--no results for ccu
, max(case when ce.itemid in (226,5856,220765) then valuenum else null end) as intra_craneal_pressure_max--no results for ccu
, min(case when ce.itemid in (492,220059) then valuenum else null end) as pap_systolic_min --Pulmonary Artery Pressure systolic
, max(case when ce.itemid in (492,220059) then valuenum else null end) as pap_systolic_max --Pulmonary Artery Pressure systolic
, min(case when ce.itemid in (8448,220060) then valuenum else null end) as pap_diastolic_min --Pulmonary Artery Pressure diastolic
, max(case when ce.itemid in (8448,220060) then valuenum else null end) as pap_diastolic_max --Pulmonary Artery Pressure diastolic
, min(case when ce.itemid in (491,220061) then valuenum else null end) as pap_mean_min --Pulmonary Artery Pressure mean
, max(case when ce.itemid in (491,220061) then valuenum else null end) as pap_mean_max --Pulmonary Artery Pressure mean
, min(case when ce.itemid in (420,220069,6166) then valuenum else null end) as lap_min --Left Artrial Pressure --no results for nnstemi--no results for ccu
, max(case when ce.itemid in (420,220069,6166) then valuenum else null end) as lap_max --Left Artrial Pressure --no results for nnstemi--no results for ccu
, min(case when ce.itemid in (1103,113,220074) then valuenum else null end) as cvp_min --Central Venous Pressure
, max(case when ce.itemid in (1103,113,220074) then valuenum else null end) as cvp_max --Central Venous Pressure
, min(case when ce.itemid in (41562,42165,44920,44970,41946,40909,41440,220088) then valuenum else null end) as co_min --Cardiac Output (thermodilution)
, max(case when ce.itemid in (41562,42165,44920,44970,41946,40909,41440,220088) then valuenum else null end) as co_max --Cardiac Output (thermodilution)
, min(case when ce.itemid in (429,5938,220125) then valuenum else null end) as lvap_min --Left Ventricular Assit Device Flow--no results for ccu
, max(case when ce.itemid in (429,5938,220125) then valuenum else null end) as lvap_max --Left Ventricular Assit Device Flow--no results for ccu
, min(case when ce.itemid in (600,220128) then valuenum else null end) as rvap_min --Right Ventricular Assist Device Flow--no results for ccu
, max(case when ce.itemid in (600,220128) then valuenum else null end) as rvap_max --Right Ventricular Assist Device Flow--no results for ccu
, min(case when ce.itemid in (226272) then valuenum else null end) as ef_cco_min --EF (CCO) --no results for nnstemi--no results for ccu
, max(case when ce.itemid in (226272) then valuenum else null end) as ef_cco_max --EF (CCO) --no results for nnstemi--no results for ccu
, min(case when ce.itemid in (504,223771) then valuenum else null end) as pcwp_min --PCWP
, max(case when ce.itemid in (504,223771) then valuenum else null end) as pcwp_max --PCWP
, min(case when ce.itemid in (7361,223772) then valuenum else null end) as svO2_min --SvO2
, max(case when ce.itemid in (7361,223772) then valuenum else null end) as svO2_max --SvO2
, min(case when ce.itemid in (1704,223773) then valuenum else null end) as pa_line_min --PA Line cm Mark
, max(case when ce.itemid in (1704,223773) then valuenum else null end) as pa_line_max --PA Line cm Mark
, min(case when ce.itemid in (223775,708) then valuenum else null end) as vad_beat_rate_r_min --VAD Beat Rate R--no results for ccu
, max(case when ce.itemid in (223775,708) then valuenum else null end) as vad_beat_rate_r_max --VAD Beat Rate R--no results for ccu
, min(case when ce.itemid in (8481,224363) then valuenum else null end) as vad_beat_rate_l_min --VAD Beat Rate [Left]--no results for ccu
, max(case when ce.itemid in (8481,224363) then valuenum else null end) as vad_beat_rate_l_max --VAD Beat Rate [Left]--no results for ccu

----- signos vitales
, min(case when ce.itemid in (211,220045) then valuenum else null end) as HeartRate_min
, max(case when ce.itemid in (211,220045) then valuenum else null end) as HeartRate_max
, avg(case when ce.itemid in (211,220045) then valuenum else null end) as HeartRate_avg
, min(case when ce.itemid in (51,442,455,6701,220179,220050) then valuenum else null end) as SysBP_min
, max(case when ce.itemid in (51,442,455,6701,220179,220050) then valuenum else null end) as SysBP_max
, avg(case when ce.itemid in (51,442,455,6701,220179,220050) then valuenum else null end) as SysBP_avg
, min(case when ce.itemid in (8368,8440,8441,8555,220180,220051) then valuenum else null end) as DiasBP_min
, max(case when ce.itemid in (8368,8440,8441,8555,220180,220051) then valuenum else null end) as DiasBP_max
, avg(case when ce.itemid in (8368,8440,8441,8555,220180,220051) then valuenum else null end) as DiasBP_avg
, min(case when ce.itemid in (456,52,6702,443,220052,220181,225312) then valuenum else null end) as MeanBP_min
, max(case when ce.itemid in (456,52,6702,443,220052,220181,225312) then valuenum else null end) as MeanBP_max
, avg(case when ce.itemid in (456,52,6702,443,220052,220181,225312) then valuenum else null end) as MeanBP_avg
, min(case when ce.itemid in (615,618,220210,224690) then valuenum else null end) as RespRate_min
, max(case when ce.itemid in (615,618,220210,224690) then valuenum else null end) as RespRate_max
, avg(case when ce.itemid in (615,618,220210,224690) then valuenum else null end) as RespRate_avg
, min(case when ce.itemid in (646,220277) then valuenum else null end) as SpO2_min
, max(case when ce.itemid in (646,220277) then valuenum else null end) as SpO2_max
, avg(case when ce.itemid in (646,220277) then valuenum else null end) as SpO2_avg
, avg(case when ce.itemid in (223761,678) then (valuenum-32)/1.8  else null end) as TempF_avg-- TempF, -- convert F to C
, avg(case when ce.itemid in (223762,676) then valuenum  else null end) as TempC_avg

from nstemi_ccu ids --- for stemi to use stemi_ccu
inner join chartevents ce
on ids.subject_id = ce.subject_id and ids.hadm_id = ce.hadm_id and ids.icustay_id = ce.icustay_id
and ce.charttime between ids.intime and ids.intime + interval '1' day ---- This is important: we only extracted results extracted during the first 24 hours
and ce.error IS DISTINCT FROM 1 -- exclude rows marked as error
where ids.los >1 ----length ICU stay > 24 hours
group by ids.subject_id, ids.hadm_id, ids.icustay_id, ids.icustay_expire_flag
order by ids.subject_id, ids.hadm_id, ids.icustay_id;

--- Step 2: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.
drop view nstemi_hemo_sigvitals;
create view nstemi_hemo_sigvitals as

SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
	,var.cardiac_out_min
	,var.cardiac_out_max
,var.intra_craneal_pressure_min
,var.intra_craneal_pressure_max
,var.pap_systolic_min --Pulmonary Artery Pressure systolic
,var.pap_systolic_max --Pulmonary Artery Pressure systolic
,var.pap_diastolic_min --Pulmonary Artery Pressure diastolic
,var.pap_diastolic_max --Pulmonary Artery Pressure diastolic
,var.pap_mean_min --Pulmonary Artery Pressure mean
,var.pap_mean_max --Pulmonary Artery Pressure mean
,var.lap_min --Left Artrial Pressure
,var.lap_max --Left Artrial Pressure
,var.cvp_min --Central Venous Pressure
,var.cvp_max --Central Venous Pressure
,var.co_min --Cardiac Output (thermodilution)
,var.co_max --Cardiac Output (thermodilution)
,var.lvap_min --Left Ventricular Assit Device Flow
,var.lvap_max --Left Ventricular Assit Device Flow
,var.rvap_min --Right Ventricular Assist Device Flow
,var.rvap_max --Right Ventricular Assist Device Flow
,var.ef_cco_min --EF (CCO)
,var.ef_cco_max --EF (CCO)
,var.pcwp_min --PCWP
,var.pcwp_max --PCWP
,var.svO2_min --SvO2
,var.svO2_max --SvO2
,var.pa_line_min --PA Line cm Mark
,var.pa_line_max --PA Line cm Mark
,var.vad_beat_rate_r_min --VAD Beat Rate R
,var.vad_beat_rate_r_max --VAD Beat Rate R
,var.vad_beat_rate_l_min --VAD Beat Rate [Left]
,var.vad_beat_rate_l_max --VAD Beat Rate [Left]
----- signos vitales
,var.HeartRate_min
,var.HeartRate_max
,var.HeartRate_avg
,var.SysBP_min
,var.SysBP_max
,var.SysBP_avg
,var.DiasBP_min
,var.DiasBP_max
,var.DiasBP_avg
,var.MeanBP_min
,var.MeanBP_max
,var.MeanBP_avg
,var.RespRate_min
,var.RespRate_max
,var.RespRate_avg
,var.SpO2_min
,var.SpO2_max
,var.SpO2_avg
,var.TempF_avg-- TempF, -- convert F to C
,var.TempC_avg

from nstemi_ccu ids --- for stemi to use stemi_ccu
left join pat_dynamic_vars var
on ids.subject_id = var.subject_id and ids.hadm_id = var.hadm_id and ids.icustay_id = var.icustay_id
where ids.los >1----length ICU stay > 24 hours
order by ids.subject_id, ids.hadm_id, ids.icustay_id;
\copy (SELECT * FROM nstemi_hemo_sigvitals) to '/tmp/nstemi_hemo_sigvitals.csv' CSV HEADER;
