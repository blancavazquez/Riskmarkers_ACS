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

-- Code for obtaining the subject_ids for all patients with STEMI
-- ---

drop view STEMI_patients_rm;
create view STEMI_patients_rm as

with icd_codes as
(
  select
    dx.subject_id,
  CASE WHEN dx.icd9_code = '41000' then '1' else '0' END as "41000"
  ,CASE WHEN dx.icd9_code = '41001' then '1' else '0' END as "41001"
  ,CASE WHEN dx.icd9_code = '41002' then '1' else '0' END as "41002"
  ,CASE WHEN dx.icd9_code = '41010' then '1' else '0' END as "41010"
  ,CASE WHEN dx.icd9_code = '41011' then '1' else '0' END as "41011"
  ,CASE WHEN dx.icd9_code = '41012' then '1' else '0' END as "41012"
  ,CASE WHEN dx.icd9_code = '41020' then '1' else '0' END as "41020"
  ,CASE WHEN dx.icd9_code = '41021' then '1' else '0' END as "41021"
  ,CASE WHEN dx.icd9_code = '41022' then '1' else '0' END as "41022"
  ,CASE WHEN dx.icd9_code = '41030' then '1' else '0' END as "41030"
  ,CASE WHEN dx.icd9_code = '41031' then '1' else '0' END as "41031"
  ,CASE WHEN dx.icd9_code = '41032' then '1' else '0' END as "41032"
  ,CASE WHEN dx.icd9_code = '41040' then '1' else '0' END as "41040"
  ,CASE WHEN dx.icd9_code = '41041' then '1' else '0' END as "41041"
  ,CASE WHEN dx.icd9_code = '41042' then '1' else '0' END as "41042"
  ,CASE WHEN dx.icd9_code = '41050' then '1' else '0' END as "41050"
  ,CASE WHEN dx.icd9_code = '41051' then '1' else '0' END as "41051"
  ,CASE WHEN dx.icd9_code = '41052' then '1' else '0' END as "41052"
  ,CASE WHEN dx.icd9_code = '41080' then '1' else '0' END as "41080"
  ,CASE WHEN dx.icd9_code = '41081' then '1' else '0' END as "41081"
  ,CASE WHEN dx.icd9_code = '41082' then '1' else '0' END as "41082"
  ,CASE WHEN dx.icd9_code = '41090' then '1' else '0' END as "41090"
  ,CASE WHEN dx.icd9_code = '41091' then '1' else '0' END as "41091"
  ,CASE WHEN dx.icd9_code = '41092' then '1' else '0' END as "41092"
  ,CASE WHEN dx.icd9_code = '4110' then '1' else '0' END as "4110"
  ,CASE WHEN dx.icd9_code = '4111' then '1' else '0' END as "4111"
  from diagnoses_icd dx
  where dx.seq_num ='1'
  group by dx.subject_id, dx.icd9_code
  order by dx.subject_id
)
select distinct subject_id
  from icd_codes
  where
  "41000"='1' or
  "41001"='1' or
  "41002"='1' or
  "41010"='1' or
  "41011"='1' or
  "41012"='1' or
  "41020"='1' or
  "41021"='1' or
  "41022"='1' or
  "41030"='1' or
  "41031"='1' or
  "41032"='1' or
  "41040"='1' or
  "41041"='1' or
  "41042"='1' or
  "41050"='1' or
  "41051"='1' or
  "41052"='1' or
  "41080"='1' or
  "41081"='1' or
  "41082"='1' or
  "41090"='1' or
  "41091"='1' or
  "41092"='1' or
  "4110"='1' or
  "4111"='1'
  order by subject_id;