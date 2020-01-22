-- ------------------------------------------------------------------
-- Title: Extraction of demographic data.
-- Notes: This query extracts demographic data: age, gender, admission type and marital status.
--        This data are captured at hospital admission
-- ------------------------------------------------------------------

drop view demografico_nstemi;
create view demografico_nstemi as

with age_patient as (
select ids.subject_id, ids.hadm_id
, ROUND((cast(ids.intime as date) - cast(pt.dob as date))/365.242, 2) AS age
, pt.gender
from nstemi_ccu ids --- for stemi patients to use stemi_ccu
inner join patients pt
on ids.subject_id = pt.subject_id
)

select  ids.subject_id, ids.hadm_id, icustay_id
        ,CASE WHEN ag.gender = 'M' then '1' else '0' END as male
        ,CASE WHEN ag.gender = 'F' then '1' else '0' END as female
        ,ag.age
        ,CASE WHEN ad.admission_type = 'ELECTIVE' then '1' else '0' END as adm_elective
        ,CASE WHEN ad.admission_type = 'EMERGENCY' then '1' else '0' END as adm_emergency
        ,CASE WHEN ad.admission_type = 'URGENT' then '1' else '0' END as adm_urgent
        ,CASE WHEN ad.marital_status = 'DIVORCED' then '1' else '0' END as status_divorced
        ,CASE WHEN ad.marital_status = 'MARRIED' then '1' else '0' END as status_married
        ,CASE WHEN ad.marital_status = 'SINGLE' then '1' else '0' END as status_single
        ,CASE WHEN ad.marital_status = 'WIDOWED' then '1' else '0' END as status_widow
from nstemi_ccu ids
inner join admissions ad
on ids.subject_id = ad.subject_id and ids.hadm_id = ad.hadm_id
inner join age_patient ag
on ad.subject_id = ag.subject_id and ad.hadm_id = ag.hadm_id
where ids.los >1.0 ----length ICU stay > 24 hours
order by ids.subject_id;

\copy (SELECT * FROM demografico_nstemi) to '/tmp/demografico_nstemi.csv' CSV HEADER;
