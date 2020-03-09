-- ------------------------------------------------------------------
-- Title: Extraction of pcwp values (Pulmonary capillary wedge pressure)
-- Notes: Using clinical notes, we explored in the text description the word "pcwp".
-- ------------------------------------------------------------------

--- Step 1: Search the word pcwpnin in clinical notes
drop view pcwp_nstemi;
create view pcwp_nstemi as
  select
    subject_id
    ,hadm_id
    ,case when substring(text, 'pcwp (.*?)([0-9]*.[0-9]+)') is not null then
    cast(substring(substring(text, strpos(text,'pcwp'),16),'([0-9]*\.[0-9]+)')as double precision)
    else null end as pcwp
from notas_nstemi -- for STEMI: notas_stemi
order by subject_id;

--- Step 2: Export the table previously created (csv file). Once exported the table, the idea is save the pcwpnin value (it was presented).
\copy (SELECT * FROM pcwp_nstemi) to '/tmp/pcwp_nstemi.csv' CSV HEADER;

---Step 3: Load the csv file to MIMIC database
drop table nstemi_pcwp cascade; --
create table nstemi_pcwp (
	subject_id int
	,hadm_id int
	,pcwp character varying(20)
);
\copy nstemi_pcwp FROM '/tmp/pcwp.csv' DELIMITER ',' CSV HEADER NULL ''

--- Step 4: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.

drop view temp cascade;
create view temp as
SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
	,e.pcwp
from nstemi_ccu ids -- for STEMI: stemi_ccu
left join nstemi_pcwp e
on ids.subject_id = e.subject_id
group by ids.subject_id, ids.hadm_id, ids.icustay_id, e.pcwp
order by ids.subject_id;
\copy (SELECT * FROM temp) to '/tmp/temp.csv' CSV HEADER;
