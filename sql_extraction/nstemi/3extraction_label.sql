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

-- Code for obtaining the label in nstemi patients: ICUSTAY_EXPIRE_FLAG
-- ---
drop view label_nstemi_rm cascade;
create view label_nstemi_rm as
  SELECT
  e.subject_id
  ,e.hadm_id
  ,e.icustay_id
  ,e.intime
  ,e.outtime
  ,e.los
  ,CASE
      WHEN adm.deathtime BETWEEN e.intime and e.outtime
          THEN '1'
      WHEN adm.deathtime <= e.intime
          THEN '1'
      WHEN adm.dischtime <= e.outtime AND adm.discharge_location = 'DEAD/EXPIRED'
          THEN '1'
      ELSE '0'
      END AS ICUSTAY_EXPIRE_FLAG

FROM nstemi_ccu e
inner join admissions adm
ON e.subject_id = adm.subject_id and e.hadm_id = adm.hadm_id
GROUP BY e.subject_id,e.hadm_id,e.icustay_id,e.intime,e.outtime,
          e.los,adm.deathtime,adm.dischtime, adm.discharge_location
ORDER BY e.subject_id;

\copy (SELECT * FROM label_nstemi_rm) to '/tmp/label_nstemi_rm.csv' CSV HEADER;