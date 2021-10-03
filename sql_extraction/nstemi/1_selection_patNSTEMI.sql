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

-- Code for obtaining the subject_ids for all patients with NSTEMI
-- ---
drop view NSTEMI_patients_rm;
create view NSTEMI_patients_rm as

with icd_codes as
(
  select
    dx.subject_id,
  CASE WHEN dx.icd9_code = '41070' then '1' else '0' END as "41070"
  ,CASE WHEN dx.icd9_code = '41071' then '1' else '0' END as "41071"
  ,CASE WHEN dx.icd9_code = '41072' then '1' else '0' END as "41072"
  from diagnoses_icd dx
  where dx.seq_num ='1'
  group by dx.subject_id, dx.icd9_code
  order by dx.subject_id
)
select distinct subject_id
  from icd_codes
  where
  "41070"='1' or
  "41071"='1' or
  "41072"='1'
  order by subject_id;
