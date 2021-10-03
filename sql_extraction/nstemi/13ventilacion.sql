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

-- Code for obtaining ventilation data
-- ---
drop view vent_nstemi cascade;
create view vent_nstemi as
select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
  ,vent.vent

from ventfirstday vent
inner join nstemi_ccu ids
on vent.subject_id = ids.subject_id  
    and vent.hadm_id = ids.hadm_id 
    and vent.icustay_id = ids.icustay_id
where ids.los >1
order by ids.subject_id;

\copy (SELECT * FROM vent_nstemi) to '/tmp/vent_nstemi.csv' CSV HEADER;
