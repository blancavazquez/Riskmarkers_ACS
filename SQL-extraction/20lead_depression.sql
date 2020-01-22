-- ------------------------------------------------------------------
-- Title: Extraction of depression type for each patients
-- Notes: Using this query identified what type of depression patient presented:i_lead,ii_lead,iii_lead,v1_lead,v2_lead,v3_lead,
--       v4_lead,v5_lead,v6_lead,avf_lead,avr_lead,avl_lead,lv,l,v,anterolateral,t_wave,precordial,r_wave,qt_t,inverted_t_waves,
--       inferolateral,anterior,inferior,rv,qrs,lvh,lateral_,mid_lateral,posterolateral
---       Using clinical notes, we explored in the text description the word "depression".
-- ------------------------------------------------------------------

--- Step 1: Search the word depression in clinical notes
drop view depression_nstemi;
create view depression_nstemi as
  select
    subject_id
    ,hadm_id
    ,substring(text, 'depression (.*?)\n') as depression
from notas_nstemi -- for STEMI: notas_stemi
order by subject_id;

--- Step 2: Export the table previously created (csv file). Once exported the table, the idea is save what type of depression was presented (as one-hot encoding)
\copy (SELECT * FROM depression_nstemi) to '/tmp/depression_nstemi.csv' CSV HEADER;

---Step 3: Load the csv file to MIMIC database
drop table nstemi_depression cascade; --
create table nstemi_depression (
	subject_id int
	,hadm_id int
	,i_lead int
	,ii_lead int
	,iii_lead int
	,v1_lead int
	,v2_lead int
	,v3_lead int
	,v4_lead int
	,v5_lead int
	,v6_lead int
	,avf_lead int
	,avr_lead int
	,avl_lead int
	,lv int
	,L int
	,V int
	,anterolateral int
	,T_wave int
	,precordial int
	,R_wave int
	,Qt_t int
	,inverted_T_waves int
	,inferolateral int
	,anterior int
	,inferior int
	,RV int
	,QRS int
	,lvh int
	,lateral_ int
	,mid_lateral int
	,posterolateral int
);
\copy nstemi_depression FROM '/tmp/depression.csv' DELIMITER ',' CSV HEADER NULL ''

--- Step 4: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.

drop view temp cascade;
create view temp as
SELECT
	ids.subject_id
	,ids.hadm_id
	,ids.icustay_id
	,e.i_lead
	,e.ii_lead
	,e.iii_lead
	,e.v1_lead
	,e.v2_lead
	,e.v3_lead
	,e.v4_lead
	,e.v5_lead
	,e.v6_lead
	,e.avf_lead
	,e.avr_lead
	,e.avl_lead
	,e.lv
	,e.L
	,e.V
	,e.anterolateral
	,e.T_wave
	,e.precordial
	,e.R_wave
	,e.Qt_t
	,e.inverted_T_waves
	,e.inferolateral
	,e.anterior
	,e.inferior
	,e.RV
	,e.QRS
	,e.lvh
	,e.lateral_
	,e.mid_lateral
	,e.posterolateral
from nstemi_ccu ids -- for STEMI: stemi_ccu
left join nstemi_depression e
on ids.subject_id = e.subject_id
group by ids.subject_id, ids.hadm_id, ids.icustay_id,e.i_lead,e.ii_lead,e.iii_lead,e.v1_lead,e.v2_lead,e.v3_lead
				,e.v4_lead,e.v5_lead,e.v6_lead,e.avf_lead,e.avr_lead,e.avl_lead,e.lv,e.L,e.V,e.anterolateral,e.T_wave
				,e.precordial,e.R_wave,e.Qt_t,e.inverted_T_waves,e.inferolateral,e.anterior,e.inferior,e.RV,e.QRS
				,e.lvh,e.lateral_,e.mid_lateral,e.posterolateral
order by ids.subject_id;
\copy (SELECT * FROM temp) to '/tmp/temp.csv' CSV HEADER;
