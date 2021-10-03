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

-- This query pivots the vital signs for the first 24 hours of a patient's stay
-- Vital signs include heart rate, blood pressure, respiration rate, and temperature
-- Only for patients in ICU with stay>1 day
-- ---


DROP MATERIALIZED VIEW IF EXISTS vitals_stemi CASCADE;
create materialized view vitals_stemi as
SELECT e.subject_id, e.hadm_id, e.icustay_id

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
--, avg(case when ce.itemid in (223761,678) then (valuenum-32)/1.8  else null end) as TempF_avg-- TempF, -- convert F to C
--, avg(case when ce.itemid in (223762,676) then valuenum  else null end) as TempC_avg --- few records


from stemi_ccu e
inner join chartevents ce
on e.subject_id = ce.subject_id and e.hadm_id = ce.hadm_id and e.icustay_id = ce.icustay_id
group by e.subject_id, e.hadm_id, e.icustay_id
order by e.subject_id, e.hadm_id, e.icustay_id;

--------------
---vamos a unir tablas, para completar los registros!
drop view vitals_stemi2;
create view vitals_stemi2 as

SELECT
    e.subject_id
    ,e.hadm_id
    ,e.icustay_id
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


from stemi_ccu e
left join vitals_stemi var
on e.subject_id = var.subject_id and e.hadm_id = var.hadm_id and e.icustay_id = var.icustay_id
group by     e.subject_id
            ,e.hadm_id
            ,e.icustay_id
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
order by e.subject_id, e.hadm_id, e.icustay_id;

\copy (SELECT * FROM vitals_stemi2) to '/tmp/vitals_stemi2.csv' CSV HEADER;

