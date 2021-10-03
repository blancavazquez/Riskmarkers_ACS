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

drop view blood_stemi cascade;
create view blood_stemi as
select
  e.subject_id
  ,e.hadm_id
  ,e.icustay_id

, avg(case when ce.itemid in (50801) then valuenum else null end) as alveolar_arterial_gradient_avg ---Gradiente alveolo-arterial de O2 (A-aO2). El un indicador global de la capacidad de pulmón como intercambiador de gases
, avg(case when ce.itemid in (50802) then valuenum else null end) as baseexcess_avg
, avg(case when ce.itemid in (50803) then valuenum else null end) as BICARBONATE_avg
, avg(case when ce.itemid in (50804) then valuenum else null end) as TOTALCO2_avg
, avg(case when ce.itemid in (50806) then valuenum else null end) as CHLORIDE_avg
, avg(case when ce.itemid in (50808) then valuenum else null end) as CALCIUM_avg
, avg(case when ce.itemid in (50813) then valuenum else null end) as LACTATE_avg
, avg(case when ce.itemid in (50815) then valuenum else null end) as O2FLOW_avg
, avg(case when ce.itemid in (50816) then valuenum else null end) as FIO2_avg
, avg(case when ce.itemid in (50817) then valuenum else null end) as SO2_avg-- OXYGENSATURATION
, avg(case when ce.itemid in (50818) then valuenum else null end) as PCO2_avg
, avg(case when ce.itemid in (50820) then valuenum else null end) as PH_avg
, avg(case when ce.itemid in (50821) then valuenum else null end) as PO2_avg
, avg(case when ce.itemid in (50825) then valuenum else null end) as TEMPERATURE_avg

, min(case when ce.itemid in (50801) then valuenum else null end) as alveolar_arterial_gradient_min ---Gradiente alveolo-arterial de O2 (A-aO2). El un indicador global de la capacidad de pulmón como intercambiador de gases
, min(case when ce.itemid in (50802) then valuenum else null end) as baseexcess_min
, min(case when ce.itemid in (50803) then valuenum else null end) as BICARBONATE_min
, min(case when ce.itemid in (50804) then valuenum else null end) as TOTALCO2_min
, min(case when ce.itemid in (50806) then valuenum else null end) as CHLORIDE_min
, min(case when ce.itemid in (50808) then valuenum else null end) as CALCIUM_min
, min(case when ce.itemid in (50813) then valuenum else null end) as LACTATE_min
, min(case when ce.itemid in (50815) then valuenum else null end) as O2FLOW_min
, min(case when ce.itemid in (50816) then valuenum else null end) as FIO2_min
, min(case when ce.itemid in (50817) then valuenum else null end) as SO2_min-- OXYGENSATURATION
, min(case when ce.itemid in (50818) then valuenum else null end) as PCO2_min
, min(case when ce.itemid in (50820) then valuenum else null end) as PH_min
, min(case when ce.itemid in (50821) then valuenum else null end) as PO2_min
, min(case when ce.itemid in (50825) then valuenum else null end) as TEMPERATURE_min

, max(case when ce.itemid in (50801) then valuenum else null end) as alveolar_arterial_gradient_max ---Gradiente alveolo-arterial de O2 (A-aO2). El un indicador global de la capacidad de pulmón como intercambiador de gases
, max(case when ce.itemid in (50802) then valuenum else null end) as baseexcess_max
, max(case when ce.itemid in (50803) then valuenum else null end) as BICARBONATE_max
, max(case when ce.itemid in (50804) then valuenum else null end) as TOTALCO2_max
, max(case when ce.itemid in (50806) then valuenum else null end) as CHLORIDE_max
, max(case when ce.itemid in (50808) then valuenum else null end) as CALCIUM_max
, max(case when ce.itemid in (50813) then valuenum else null end) as LACTATE_max
, max(case when ce.itemid in (50815) then valuenum else null end) as O2FLOW_max
, max(case when ce.itemid in (50816) then valuenum else null end) as FIO2_max
, max(case when ce.itemid in (50817) then valuenum else null end) as SO2_max-- OXYGENSATURATION
, max(case when ce.itemid in (50818) then valuenum else null end) as PCO2_max
, max(case when ce.itemid in (50820) then valuenum else null end) as PH_max
, max(case when ce.itemid in (50821) then valuenum else null end) as PO2_max
, max(case when ce.itemid in (50825) then valuenum else null end) as TEMPERATURE_max

from stemi_ccu e
inner join labevents ce
on e.subject_id = ce.subject_id and e.hadm_id = ce.hadm_id
and ce.charttime between e.intime and e.intime + interval '1' day
where e.los >1--- me aseguro que sean pacientes que estuvieron más de un día en ICU
group by e.subject_id, e.hadm_id, e.icustay_id
order by e.subject_id, e.hadm_id, e.icustay_id;

drop view blood_stemi2 cascade;
create view blood_stemi2 as
select
  e.subject_id
  ,e.hadm_id
  ,e.icustay_id
	, ce.alveolar_arterial_gradient_avg
	, ce.baseexcess_avg
	, ce.BICARBONATE_avg
	, ce.TOTALCO2_avg
	, ce.CHLORIDE_avg
	, ce.CALCIUM_avg
	, ce.LACTATE_avg
	, ce.O2FLOW_avg
	, ce.FIO2_avg
	, ce.SO2_avg
	, ce.PCO2_avg
	, ce.PH_avg
	, ce.PO2_avg
	, ce.TEMPERATURE_avg
	, ce.alveolar_arterial_gradient_min
	, ce.baseexcess_min
	, ce.BICARBONATE_min
	, ce.TOTALCO2_min
	, ce.CHLORIDE_min
	, ce.CALCIUM_min
	, ce.LACTATE_min
	, ce.O2FLOW_min
	, ce.FIO2_min
	, ce.SO2_min
	, ce.PCO2_min
	, ce.PH_min
	, ce.PO2_min
	, ce.TEMPERATURE_min
	, ce.alveolar_arterial_gradient_max
	, ce.baseexcess_max
	, ce.BICARBONATE_max
	, ce.TOTALCO2_max
	, ce.CHLORIDE_max
	, ce.CALCIUM_max
	, ce.LACTATE_max
	, ce.O2FLOW_max
	, ce.FIO2_max
	, ce.SO2_max
	, ce.PCO2_max
	, ce.PH_max
	, ce.PO2_max
	, ce.TEMPERATURE_max


from stemi_ccu e
left join blood_stemi ce
on e.subject_id = ce.subject_id and e.hadm_id = ce.hadm_id and e.icustay_id = ce.icustay_id
group by   e.subject_id
  ,e.hadm_id
  ,e.icustay_id
	, ce.alveolar_arterial_gradient_avg
	, ce.baseexcess_avg
	, ce.BICARBONATE_avg
	, ce.TOTALCO2_avg
	, ce.CHLORIDE_avg
	, ce.CALCIUM_avg
	, ce.LACTATE_avg
	, ce.O2FLOW_avg
	, ce.FIO2_avg
	, ce.SO2_avg
	, ce.PCO2_avg
	, ce.PH_avg
	, ce.PO2_avg
	, ce.TEMPERATURE_avg
	, ce.alveolar_arterial_gradient_min
	, ce.baseexcess_min
	, ce.BICARBONATE_min
	, ce.TOTALCO2_min
	, ce.CHLORIDE_min
	, ce.CALCIUM_min
	, ce.LACTATE_min
	, ce.O2FLOW_min
	, ce.FIO2_min
	, ce.SO2_min
	, ce.PCO2_min
	, ce.PH_min
	, ce.PO2_min
	, ce.TEMPERATURE_min
	, ce.alveolar_arterial_gradient_max
	, ce.baseexcess_max
	, ce.BICARBONATE_max
	, ce.TOTALCO2_max
	, ce.CHLORIDE_max
	, ce.CALCIUM_max
	, ce.LACTATE_max
	, ce.O2FLOW_max
	, ce.FIO2_max
	, ce.SO2_max
	, ce.PCO2_max
	, ce.PH_max
	, ce.PO2_max
	, ce.TEMPERATURE_max
order by e.subject_id, e.hadm_id, e.icustay_id;


\copy (SELECT * FROM blood_stemi2) to '/tmp/blood_stemi2.csv' CSV HEADER;


