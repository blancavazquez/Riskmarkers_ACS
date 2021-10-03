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
-- Title: Extraction of hemodynamic features
-- Notes: This query extracts information about whether patient required an endotracheal tube for breathing
---       Before to execute this query, is neccesary create the table "gcsfirstday"
---       The description of this table is: https://github.com/MIT-LCP/mimic-code/blob/master/concepts/firstday/gcs-first-day.sql
-- ------------------------------------------------------------------

drop view hemo_nstemi cascade;
create view hemo_nstemi as
select
  e.subject_id
  ,e.hadm_id
  ,e.icustay_id

, min(case when ce.itemid in (1367,1371,224842) then valuenum else null end) as cardiac_out_min
, max(case when ce.itemid in (1367,1371,224842) then valuenum else null end) as cardiac_out_max
, avg(case when ce.itemid in (1367,1371,224842) then valuenum else null end) as cardiac_out_avg

, min(case when ce.itemid in (226,5856,220765) then valuenum else null end) as intra_craneal_pressure_min--no results for ccu
, max(case when ce.itemid in (226,5856,220765) then valuenum else null end) as intra_craneal_pressure_max--no results for ccu
, avg(case when ce.itemid in (226,5856,220765) then valuenum else null end) as intra_craneal_pressure_avg--no results for ccu

, min(case when ce.itemid in (492,220059) then valuenum else null end) as pap_systolic_min --Pulmonary Artery Pressure systolic
, max(case when ce.itemid in (492,220059) then valuenum else null end) as pap_systolic_max --Pulmonary Artery Pressure systolic
, avg(case when ce.itemid in (492,220059) then valuenum else null end) as pap_systolic_avg --Pulmonary Artery Pressure systolic

, min(case when ce.itemid in (8448,220060) then valuenum else null end) as pap_diastolic_min --Pulmonary Artery Pressure diastolic
, max(case when ce.itemid in (8448,220060) then valuenum else null end) as pap_diastolic_max --Pulmonary Artery Pressure diastolic
, avg(case when ce.itemid in (8448,220060) then valuenum else null end) as pap_diastolic_avg --Pulmonary Artery Pressure diastolic


, min(case when ce.itemid in (491,220061) then valuenum else null end) as pap_mean_min --Pulmonary Artery Pressure mean
, max(case when ce.itemid in (491,220061) then valuenum else null end) as pap_mean_max --Pulmonary Artery Pressure mean
, avg(case when ce.itemid in (491,220061) then valuenum else null end) as pap_mean_avg --Pulmonary Artery Pressure mean


, min(case when ce.itemid in (420,220069,6166) then valuenum else null end) as lap_min --Left Artrial Pressure --no results for nnnstemi--no results for ccu
, max(case when ce.itemid in (420,220069,6166) then valuenum else null end) as lap_max --Left Artrial Pressure --no results for nnnstemi--no results for ccu
, avg(case when ce.itemid in (420,220069,6166) then valuenum else null end) as lap_avg --Left Artrial Pressure --no results for nnnstemi--no results for ccu

, min(case when ce.itemid in (1103,113,220074) then valuenum else null end) as cvp_min --Central Venous Pressure
, max(case when ce.itemid in (1103,113,220074) then valuenum else null end) as cvp_max --Central Venous Pressure
, avg(case when ce.itemid in (1103,113,220074) then valuenum else null end) as cvp_avg --Central Venous Pressure


, min(case when ce.itemid in (41562,42165,44920,44970,41946,40909,41440,220088) then valuenum else null end) as co_min --Cardiac Output (thermodilution)
, max(case when ce.itemid in (41562,42165,44920,44970,41946,40909,41440,220088) then valuenum else null end) as co_max --Cardiac Output (thermodilution)
, avg(case when ce.itemid in (41562,42165,44920,44970,41946,40909,41440,220088) then valuenum else null end) as co_avg --Cardiac Output (thermodilution)


, min(case when ce.itemid in (429,5938,220125) then valuenum else null end) as lvap_min --Left Ventricular Assit Device Flow--no results for ccu
, max(case when ce.itemid in (429,5938,220125) then valuenum else null end) as lvap_max --Left Ventricular Assit Device Flow--no results for ccu
, avg(case when ce.itemid in (429,5938,220125) then valuenum else null end) as lvap_avg --Left Ventricular Assit Device Flow--no results for ccu


, min(case when ce.itemid in (600,220128) then valuenum else null end) as rvap_min --Right Ventricular Assist Device Flow--no results for ccu
, max(case when ce.itemid in (600,220128) then valuenum else null end) as rvap_max --Right Ventricular Assist Device Flow--no results for ccu
, avg(case when ce.itemid in (600,220128) then valuenum else null end) as rvap_avg --Right Ventricular Assist Device Flow--no results for ccu


, min(case when ce.itemid in (226272) then valuenum else null end) as ef_cco_min --EF (CCO) --no results for nnnstemi--no results for ccu
, max(case when ce.itemid in (226272) then valuenum else null end) as ef_cco_max --EF (CCO) --no results for nnnstemi--no results for ccu
, avg(case when ce.itemid in (226272) then valuenum else null end) as ef_cco_avg --EF (CCO) --no results for nnnstemi--no results for ccu

, min(case when ce.itemid in (504,223771) then valuenum else null end) as pcwp_min --PCWP
, max(case when ce.itemid in (504,223771) then valuenum else null end) as pcwp_max --PCWP
, avg(case when ce.itemid in (504,223771) then valuenum else null end) as pcwp_avg --PCWP


, min(case when ce.itemid in (7361,223772) then valuenum else null end) as svO2_min --SvO2
, max(case when ce.itemid in (7361,223772) then valuenum else null end) as svO2_max --SvO2
, avg(case when ce.itemid in (7361,223772) then valuenum else null end) as svO2_avg --SvO2


, min(case when ce.itemid in (1704,223773) then valuenum else null end) as pa_line_min --PA Line cm Mark
, max(case when ce.itemid in (1704,223773) then valuenum else null end) as pa_line_max --PA Line cm Mark
, avg(case when ce.itemid in (1704,223773) then valuenum else null end) as pa_line_avg --PA Line cm Mark

, min(case when ce.itemid in (223775,708) then valuenum else null end) as vad_beat_rate_r_min --VAD Beat Rate R--no results for ccu
, max(case when ce.itemid in (223775,708) then valuenum else null end) as vad_beat_rate_r_max --VAD Beat Rate R--no results for ccu
, avg(case when ce.itemid in (223775,708) then valuenum else null end) as vad_beat_rate_r_avg --VAD Beat Rate R--no results for ccu


, min(case when ce.itemid in (8481,224363) then valuenum else null end) as vad_beat_rate_l_min --VAD Beat Rate [Left]--no results for ccu
, max(case when ce.itemid in (8481,224363) then valuenum else null end) as vad_beat_rate_l_max --VAD Beat Rate [Left]--no results for ccu
, avg(case when ce.itemid in (8481,224363) then valuenum else null end) as vad_beat_rate_l_avg --VAD Beat Rate [Left]--no results for ccu


from nstemi_ccu e
inner join chartevents ce
on e.subject_id = ce.subject_id and e.hadm_id = ce.hadm_id and e.icustay_id = ce.icustay_id
--and ce.charttime between e.intime and e.intime + interval '1' day
--where e.los >1--- me aseguro que sean pacientes que estuvieron más de un día en ICU
group by e.subject_id, e.hadm_id, e.icustay_id
order by e.subject_id, e.hadm_id, e.icustay_id;

----------------- complete records
drop view hemo_nstemi2 cascade;
create view hemo_nstemi2 as
select
  ce.subject_id
  ,ce.hadm_id
  ,ce.icustay_id
  ,e.cardiac_out_min
  ,e.cardiac_out_max
  ,e.cardiac_out_avg
  ,e.intra_craneal_pressure_min--no results for ccu
  ,e.intra_craneal_pressure_max--no results for ccu
  ,e.intra_craneal_pressure_avg--no results for ccu
  ,e.pap_systolic_min --Pulmonary Artery Pressure systolic
  ,e.pap_systolic_max --Pulmonary Artery Pressure systolic
  ,e.pap_systolic_avg --Pulmonary Artery Pressure systolic
  ,e.pap_diastolic_min --Pulmonary Artery Pressure diastolic
  ,e.pap_diastolic_max --Pulmonary Artery Pressure diastolic
  ,e.pap_diastolic_avg --Pulmonary Artery Pressure diastolic
  ,e.pap_mean_min --Pulmonary Artery Pressure mean
  ,e.pap_mean_max --Pulmonary Artery Pressure mean
  ,e.pap_mean_avg --Pulmonary Artery Pressure mean
  ,e.lap_min --Left Artrial Pressure --no results for nnnstemi--no results for ccu
  ,e.lap_max --Left Artrial Pressure --no results for nnnstemi--no results for ccu
  ,e.lap_avg --Left Artrial Pressure --no results for nnnstemi--no results for ccu
  ,e.cvp_min --Central Venous Pressure
  ,e.cvp_max --Central Venous Pressure
  ,e.cvp_avg --Central Venous Pressure
  ,e.co_min --Cardiac Output (thermodilution)
  ,e.co_max --Cardiac Output (thermodilution)
  ,e.co_avg --Cardiac Output (thermodilution)
  ,e.lvap_min --Left Ventricular Assit Device Flow--no results for ccu
  ,e.lvap_max --Left Ventricular Assit Device Flow--no results for ccu
  ,e.lvap_avg --Left Ventricular Assit Device Flow--no results for ccu
  ,e.rvap_min --Right Ventricular Assist Device Flow--no results for ccu
  ,e.rvap_max --Right Ventricular Assist Device Flow--no results for ccu
  ,e.rvap_avg --Right Ventricular Assist Device Flow--no results for ccu
  ,e.ef_cco_min --EF (CCO) --no results for nnnstemi--no results for ccu
  ,e.ef_cco_max --EF (CCO) --no results for nnnstemi--no results for ccu
  ,e.ef_cco_avg --EF (CCO) --no results for nnnstemi--no results for ccu
  ,e.pcwp_min --PCWP
  ,e.pcwp_max --PCWP
  ,e.pcwp_avg --PCWP
  ,e.svO2_min --SvO2
  ,e.svO2_max --SvO2
  ,e.svO2_avg --SvO2
  ,e.pa_line_min --PA Line cm Mark
  ,e.pa_line_max --PA Line cm Mark
  ,e.pa_line_avg --PA Line cm Mark
  ,e.vad_beat_rate_r_min --VAD Beat Rate R--no results for ccu
  ,e.vad_beat_rate_r_max --VAD Beat Rate R--no results for ccu
  ,e.vad_beat_rate_r_avg --VAD Beat Rate R--no results for ccu
  ,e.vad_beat_rate_l_min --VAD Beat Rate [Left]--no results for ccu
  ,e.vad_beat_rate_l_max --VAD Beat Rate [Left]--no results for ccu
  ,e.vad_beat_rate_l_avg --VAD Beat Rate [Left]--no results for ccu


from nstemi_ccu ce
left join hemo_nstemi e
on ce.subject_id = e.subject_id and ce.hadm_id = e.hadm_id and ce.icustay_id = e.icustay_id
group by     ce.subject_id
            ,ce.hadm_id
            ,ce.icustay_id
              ,e.cardiac_out_min
  ,e.cardiac_out_max
  ,e.cardiac_out_avg
  ,e.intra_craneal_pressure_min--no results for ccu
  ,e.intra_craneal_pressure_max--no results for ccu
  ,e.intra_craneal_pressure_avg--no results for ccu
  ,e.pap_systolic_min --Pulmonary Artery Pressure systolic
  ,e.pap_systolic_max --Pulmonary Artery Pressure systolic
  ,e.pap_systolic_avg --Pulmonary Artery Pressure systolic
  ,e.pap_diastolic_min --Pulmonary Artery Pressure diastolic
  ,e.pap_diastolic_max --Pulmonary Artery Pressure diastolic
  ,e.pap_diastolic_avg --Pulmonary Artery Pressure diastolic
  ,e.pap_mean_min --Pulmonary Artery Pressure mean
  ,e.pap_mean_max --Pulmonary Artery Pressure mean
  ,e.pap_mean_avg --Pulmonary Artery Pressure mean
  ,e.lap_min --Left Artrial Pressure --no results for nnnstemi--no results for ccu
  ,e.lap_max --Left Artrial Pressure --no results for nnnstemi--no results for ccu
  ,e.lap_avg --Left Artrial Pressure --no results for nnnstemi--no results for ccu
  ,e.cvp_min --Central Venous Pressure
  ,e.cvp_max --Central Venous Pressure
  ,e.cvp_avg --Central Venous Pressure
  ,e.co_min --Cardiac Output (thermodilution)
  ,e.co_max --Cardiac Output (thermodilution)
  ,e.co_avg --Cardiac Output (thermodilution)
  ,e.lvap_min --Left Ventricular Assit Device Flow--no results for ccu
  ,e.lvap_max --Left Ventricular Assit Device Flow--no results for ccu
  ,e.lvap_avg --Left Ventricular Assit Device Flow--no results for ccu
  ,e.rvap_min --Right Ventricular Assist Device Flow--no results for ccu
  ,e.rvap_max --Right Ventricular Assist Device Flow--no results for ccu
  ,e.rvap_avg --Right Ventricular Assist Device Flow--no results for ccu
  ,e.ef_cco_min --EF (CCO) --no results for nnnstemi--no results for ccu
  ,e.ef_cco_max --EF (CCO) --no results for nnnstemi--no results for ccu
  ,e.ef_cco_avg --EF (CCO) --no results for nnnstemi--no results for ccu
  ,e.pcwp_min --PCWP
  ,e.pcwp_max --PCWP
  ,e.pcwp_avg --PCWP
  ,e.svO2_min --SvO2
  ,e.svO2_max --SvO2
  ,e.svO2_avg --SvO2
  ,e.pa_line_min --PA Line cm Mark
  ,e.pa_line_max --PA Line cm Mark
  ,e.pa_line_avg --PA Line cm Mark
  ,e.vad_beat_rate_r_min --VAD Beat Rate R--no results for ccu
  ,e.vad_beat_rate_r_max --VAD Beat Rate R--no results for ccu
  ,e.vad_beat_rate_r_avg --VAD Beat Rate R--no results for ccu
  ,e.vad_beat_rate_l_min --VAD Beat Rate [Left]--no results for ccu
  ,e.vad_beat_rate_l_max --VAD Beat Rate [Left]--no results for ccu
  ,e.vad_beat_rate_l_avg --VAD Beat Rate [Left]--no results for ccu
order by ce.subject_id, ce.hadm_id, ce.icustay_id;

\copy (SELECT * FROM hemo_nstemi2) to '/tmp/hemo_nstemi2.csv' CSV HEADER;


