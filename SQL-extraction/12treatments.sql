-- ------------------------------------------------------------------
-- Title: Extraction of treatments
-- Notes: This query extracts information about treatments that patients received during their ICU stay.
--      We can observed that treatments with the same name or same function were grouped.
--      For instance: 'Clopidogrel Bisulfate', 'Clopidogrel' -->> Clopidogrel_Bisulfate
-- ------------------------------------------------------------------

--- Step 1: extract treatments for each patient
drop view nstemi_treatments cascade;
create view nstemi_treatments as
select
  ids.subject_id
  ,ids.hadm_id
  ,ids.icustay_id

,CASE WHEN pre.drug in ('Aspirin EC', 'Aspirin', 'Aspirin (Buffered)', 'Aspirin Desensitization (Angioedema)',
                    'aspirin', 'Aspirin (Rectal)') then '1' else '0'  END as Aspirin
,CASE WHEN pre.drug in ('Clopidogrel Bisulfate', 'Clopidogrel') then '1' else '0' END as Clopidogrel_Bisulfate
,CASE WHEN pre.drug in ('Enoxaparin Sodium') then '1' else '0'  END as Enoxaparin
,CASE WHEN pre.drug in ('Heparin_Sodium', 'Heparin', 'Heparin Flush CVL  (100 units/ml)', 'Heparin Flush (10 units/ml)',
                    'Heparin (IABP)', 'Heparin Flush PICC (100 units/ml)', 'Heparin Flush (5000 Units/mL)',
                    'Heparin Flush (1000 units/mL)', 'Heparin Flush CRRT (5000 Units/mL)', 'Heparin Dwell (1000 Units/mL)',
                    'Heparin Flush (100 units/ml)', 'Heparin CRRT', 'Heparin Flush', 'HEPARIN', 'Heparin (CRRT Machine Priming)',
                    'Heparin Lock Flush', 'Heparin Flush Port (10units/ml)' ) then '1' else '0'  END as Heparin
,CASE WHEN pre.drug in ('Nitroglycerin', 'Nitroglycerin SL', 'Nitroglycerin Ointment  2%',
                   'Nitroglycerin Oint. 2%', 'Nitroglycerin Patch', 'Isosorbide Dinitrate',
                  'Isosorbide Mononitrate', 'Isosorbide Mononitrate (Extended Release)') then '1' else '0'  END as Oral_nitrates
,CASE WHEN pre.drug in ('Atorvastatin', 'Fluvastatin Sodium', 'Lescol',
                    'Pravastatin', 'Rosuvastatin Calcium' ) then '1' else '0'  END as Statins
,CASE WHEN pre.drug in ('Tricor', 'Gemfibrozil') then '1' else '0'  END as Fibrates
,CASE WHEN pre.drug in ('Acebutolol HCl', 'Atenolol', 'Metoprolol XL (Toprol XL)', 'Metoprolol Tartrate'
                    'Nadolol', 'Propranolol') then '1' else '0'  END as Beta_blockers
,CASE WHEN pre.drug in ('Captopril', 'Enalapril Maleate', 'Lisinopril', 'Moexipril HCl',
                    'Quinapril', 'Ramipril', 'Trandolapril', 'Enalaprilat') then '1' else '0'  END as ACE_inhibitors
,CASE WHEN pre.drug in ('irbesartan', 'Valsartan', 'Losartan Potassium') then '1' else '0'  END as ARB
,CASE WHEN pre.drug in ('Chlorothiazide Sodium', 'Hydrochlorothiazide', 'Metolazone',
                    'Bumetanide', 'Furosemide', 'Torsemide', 'Amiloride HCl',
                    'Eplerenone', 'Spironolactone') then '1' else '0'  END as diuretics
,CASE WHEN pre.drug in ('Amlodipine Besylate', 'Amlodipine', 'Diltiazem Extended-Release', 'Diltiazem'
                    'Felodipine', 'NiCARdipine IV', 'Nicardipine HCl IV', 'NIFEdipine CR'
                    'NIFEdipine', 'Verapamil', 'Verapamil HCl', 'Verapamil SR') then '1' else '0'  END as calcium_antagonist
,CASE WHEN pre.drug in ('Amiodarone HCl', 'Amiodarone') then '1' else '0'  END as Amiodarone
,CASE WHEN pre.drug in ('Digoxin') then '1' else '0'  END as Digoxin
,CASE WHEN pre.drug in ('Dobutamine Hcl', 'DOBUTamine', 'Dobutamine', 'Dobutamine HCl') then '1' else '0'  END as dobutamine
,CASE WHEN pre.drug in ('Dopamine HCl', 'DopAmine', 'DOPamine', 'Dopamine', 'Dopamine Hcl') then '1' else '0'  END as dopamine
,CASE WHEN pre.drug in ('Metformin', 'MetFORMIN (Glucophage)', 'MetFORMIN XR (Glucophage XR)') then '1' else '0'  END as oral_glucose_low_drugs
,CASE WHEN pre.drug in ('Insulin Glargine', 'Insulin Pump', 'Humulin-R Insulin', 'Insulin'
                    'Insulin Human Regular') then '1' else '0'  END as Insulin
,CASE WHEN pre.drug in ('Potassium Chloride') then '1' else '0'  END as Potassium_Chloride
,CASE WHEN pre.drug in ('Warfarin') then '1' else '0'  END as Warfarin
,CASE WHEN pre.drug in ('Vancomycin HCl', 'Vancomycin', 'Vancomycin Enema', 'Vancomycin Oral Liquid') then '1' else '0'  END as Vancomycin

from nstemi_ccu ids --- for stemi to use stemi_ccu
left join prescriptions pre
on ids.subject_id = pre.subject_id and ids.hadm_id = pre.hadm_id and ids.icustay_id = pre.icustay_id
where pre.startdate between ids.intime and ids.intime + interval '1' day ---- This is important: we only extracted treatments prescribed during the first 24 hours
and ids.los >1.0 ----length ICU stay > 24 hours
order by ids.subject_id;


--- Step 2: In order to have the same number of register for each clinical set (ej., demographic, complications, labs, etc); we crossed the table created
--- previously with the table nstemi_ccu. In this manner, we preserved the same number of record for all the clinical sets.

drop view treatments;
create view treatments as
select ids.subject_id
,ids.hadm_id
,ids.icustay_id
,pre.Aspirin
,pre.Clopidogrel_Bisulfate
,pre.Enoxaparin
,pre.Heparin
,pre.Oral_nitrates
,pre.Statins
,pre.Fibrates
,pre.Beta_blockers
,pre.ACE_inhibitors
,pre.ARB
,pre.diuretics
,pre.calcium_antagonist
,pre.Amiodarone
,pre.Digoxin
,pre.dobutamine
,pre.dopamine
,pre.oral_glucose_low_drugs
,pre.Insulin
,pre.Potassium_Chloride
,pre.Warfarin
,pre.Vancomycin

from nstemi_ccu ids --- for stemi to use stemi_ccu
left join nstemi_treatments pre
on ids.subject_id = pre.subject_id and ids.hadm_id = pre.hadm_id and ids.icustay_id = pre.icustay_id
where ids.los > 1.0
order by ids.subject_id;
\copy (SELECT * FROM treatments) to '/tmp/treatments.csv' CSV HEADER;
