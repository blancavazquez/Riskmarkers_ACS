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

-- Code for obtaning demographic data for NSTEMI patients
-- ---
drop view demo_nstemi_rm cascade;
create view demo_nstemi_rm as

select  ids.subject_id, ids.hadm_id, ids.icustay_id,ids.los
        ,CASE WHEN ad.admission_type = 'ELECTIVE' then '1' else '0' END as adm_elective
        ,CASE WHEN ad.admission_type = 'EMERGENCY' then '1' else '0' END as adm_emergency
        ,CASE WHEN ad.admission_type = 'URGENT' then '1' else '0' END as adm_urgent
        ,CASE WHEN ad.marital_status = 'DIVORCED' then '1' else '0' END as status_divorced
        ,CASE WHEN ad.marital_status = 'MARRIED' then '1' else '0' END as status_married
        ,CASE WHEN ad.marital_status = 'SINGLE' then '1' else '0' END as status_single
        ,CASE WHEN ad.marital_status = 'WIDOWED' then '1' else '0' END as status_widow

from nstemi_ccu ids
inner join admissions ad
on ids.subject_id = ad.subject_id and ids.hadm_id = ad.hadm_id
where ids.los>1

group by ids.subject_id, ids.hadm_id, ids.icustay_id,ad.admission_type,ad.marital_status,ids.los
order by ids.subject_id;


----Join demo + weight
drop view demo_weigth_nstemi_rm;
create view demo_weigth_nstemi_rm as

select  ids.subject_id, ids.hadm_id, ids.icustay_id,ids.los
        ,ids.adm_elective
        ,ids.adm_emergency
        ,ids.adm_urgent
        ,ids.status_divorced
        ,ids.status_married
        ,ids.status_single
        ,ids.status_widow
        ,w.weight_admit

from demo_nstemi_rm ids
inner join weightfirstday w
on ids.icustay_id=w.icustay_id
group by ids.subject_id, ids.hadm_id, ids.icustay_id,ids.los
        ,ids.adm_elective
        ,ids.adm_emergency
        ,ids.adm_urgent
        ,ids.status_divorced
        ,ids.status_married
        ,ids.status_single
        ,ids.status_widow
        ,w.weight_admit
order by ids.subject_id;


\copy (SELECT * FROM demo_weigth_nstemi_rm) to '/tmp/demo_weigth_nstemi_rm.csv' CSV HEADER;
