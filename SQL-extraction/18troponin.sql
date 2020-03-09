-- ------------------------------------------------------------------
-- Title: Extraction of troponin values
-- Notes: An important aspect to review in patients with heart diseases is to identify myocardial size.
---       Using clinical notes, we explored in the text description the word "troponin".
-- ------------------------------------------------------------------

--- Step 1: Search the word troponin in clinical notes
drop view tropo_nstemi;
create view tropo_nstemi as
select
	ids.subject_id
	,ids.hadm_id
  	,case when substring(text, 'troponin (.*?)([0-9]*.[0-9]+)') is not null then
  	cast(substring(substring(text, strpos(text,'troponin'),16),'([0-9]*\.[0-9]+)')as double precision)
		else null end as troponin
from nstemi_ccu ids
inner join noteevents dx
on ids.subject_id = dx.subject_id and ids.hadm_id = dx.hadm_id
and dx.charttime between ids.intime and ids.intime + interval '1' day
where ids.los >1.0
group by ids.subject_id, ids.hadm_id, troponin
order by ids.subject_id;

--- Step 2: Export the table previously created (csv file). Once exported the table, the idea is save the troponin value (it was presented).
\copy (SELECT * FROM tropo_nstemi) to '/tmp/tropo_nstemi.csv' CSV HEADER;

---Step 3: Load the csv file to MIMIC database
drop table nstemi_tropo; --
create table nstemi_tropo (
  subject_id int
	,tropon character varying(30)
);
\copy nstemi_tropo FROM '/tmp/tropo.csv' DELIMITER ',' CSV HEADER NULL ''

--- Step 4: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.

drop view temp cascade;
create view temp as
SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
	,e.tropo_flag
from nstemi_ccu ids -- for STEMI: stemi_ccu
left join nstemi_tropo e
on ids.subject_id = e.subject_id
group by ids.subject_id, ids.hadm_id, ids.icustay_id, e.tropo_flag
order by ids.subject_id;

\copy (SELECT * FROM temp) to '/tmp/temp.csv' CSV HEADER;
