"Scripts para obtener cada una de las variables del GRACE score"

---1) AGE: como este dado ya lo calculamos previamente solo vamos a obtenerlo
drop view age_grace_st;
create view age_grace_st as
  select
    ids.subject_id
    ,ids.hadm_id
    ,ids.icustay_id
    ,ids.age

from demografico_stemi_1539 ids
order by ids.subject_id;
\copy (SELECT * FROM age_grace_st) to '/tmp/age_grace_st.csv' CSV HEADER;

---2) Cálculo de las variables de laboratorio al momento de admisión: heart_rate
drop view hr_grace_st;
create view hr_grace_st as
  select
    ids.subject_id
    ,ids.hadm_id
    ,ids.icustay_id
    ,ids.HeartRate_avg
    ,ids.SysBP_avg
from stemi_hemo_sigvitals ids
order by ids.subject_id;
\copy (SELECT * FROM hr_grace_st) to '/tmp/hr_grace_st.csv' CSV HEADER;


---6) Cardiac arrest at admission: nos vamos apoyar de la tabla de admission
drop view car_grace_st;
create view car_grace_st as
  select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id
,CASE WHEN ad.diagnosis in ('CARDIAC ARREST','CARDIAC ARREST\CATH','CARDIAC ARREST;URINARY TRACT INFECTION',
                          'BRADE CARDIAC ARREST','CARDIAC ARREST\CARDIAC CATH','PULMONARY EDEMA,CARDIAC ARREST',
                          'CARDIAC ARREST;TELEMETRY','RESUCITATED CARDIAC ARREST','SHOCK,ACUTE RENAL FAILURE,CARDIAC ARREST',
                          'HEART FAILURE;CARDIAC ARREST\INTRA-AORTIC BALLOON PUMP PLACEMENT','CARDIAC ARREST;MYOCARDIAL INFARCTION',
                          'CARDIAC ARREST;COLON CA','CARDIAC ARREST;GI BLEED','CARDIAC ARREST\VT ABLATION','PERICARDIAL EFFUSION;CARDIAC ARREST',
                          'MI/CARDIAC ARREST\LEFT HEART CATHETERIZATION','CARDIAC ARREST\CATHETERIZATION','ANAPHALACTIC SHOCK;CARDIAC ARREST;TELEMETRY',
                          'STATUS POST CARDIAC ARREST','VFIB-CARDIAC ARREST','GROSS HEMATURIA,CARDIAC ARREST','RESPIRATORY FAILURE;CARDIAC ARREST',
                          'VFIB-CARDIAC ARREST','ABDOMINAL PAIN;CARDIAC ARREST','HYPERKALEMIA;CARDIAC ARREST','POST CARDIAC ARREST',
                          'CHEST PAIN;STATUS POST CARDIAC ARREST\CATH','BRADYCARDIA;CARDIAC ARREST','STROKE,CARDIAC ARREST',
                          'STATUS POST CARDIAC ARREST\CARDIAC CATHETERIZATION','CARDIOGENIC SHOCK;CARDIAC ARREST',
                          'CARDIAC ARREST','MENINGITIS, STATUS POST CARDIAC ARREST'
                          ) then '1' else '0' END as cardiac_arrest_atadmission
from stemi_ccu ids
inner join admissions ad
on ids.subject_id = ad.subject_id and ids.hadm_id = ad.hadm_id
group by ids.subject_id, ids.hadm_id, ids.icustay_id, ad.diagnosis
order by ids.subject_id;
\copy (SELECT * FROM car_grace_st) to '/tmp/car_grace_st.csv' CSV HEADER;

----7) Vamos por la pwpc
De la tabla que ya existe con pcwp, hay que crearla en sql y luego exportarla!
para poder unir con todos los registros
