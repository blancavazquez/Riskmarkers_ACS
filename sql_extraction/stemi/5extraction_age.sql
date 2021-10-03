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

-- Code for obtaining demographic data for STEMI patients
-- ---
drop view age_stemi_rm cascade;
create view age_stemi_rm as

select 
        ids.subject_id, ids.hadm_id
        ,ROUND((cast(ids.intime as date) - cast(pt.dob as date))/365.242, 2) AS age
        ,pt.gender

from stemi_ccu ids
inner join patients pt
on ids.subject_id = pt.subject_id
group by ids.subject_id, ids.hadm_id, pt.gender,ids.intime,pt.dob
order by ids.subject_id;

\copy (SELECT * FROM age_stemi_rm) to '/tmp/age_stemi_rm.csv' CSV HEADER;
