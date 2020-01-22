-- ------------------------------------------------------------------
-- Title: Extraction of clinical notes for NSTEMI.
-- Notes: This query extract the text captured from noteevents table.
-- ------------------------------------------------------------------

drop view notas_nstemi;
create view notas_nstemi as
select
  ids.subject_id,
  ids.hadm_id,
  n.category,
  n.text

from noteevents n
inner join nstemi_ccu ids
on n.subject_id = ids.subject_id and n.hadm_id = ids.hadm_id
group by ids.subject_id, ids.hadm_id, n.category, n.text
order by ids.subject_id;
