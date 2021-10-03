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

-- Code for obtaining the hadm_id & icustay_id for all patients with STEMI
-- ---
drop view STEMI_icustays_rm;
create view STEMI_icustays_rm as

select ids.subject_id, 
	   icu.hadm_id, 
	   icu.icustay_id,
	   icu.los,
	   icu.intime,
	   icu.outtime
from icustays icu
inner join STEMI_patients_rm ids
on icu.subject_id = ids.subject_id
where icu.los>1
order by subject_id;

select * from STEMI_icustays_rm;