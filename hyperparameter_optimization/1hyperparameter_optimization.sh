#!/bin/bash
echo "start: $(date -Iseconds)"
echo "###########################################################"

echo "STEMI"
#Lab clinical set
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_lab.csv ../data/stemi/ytrain_lab.csv \
		LR ../logs/stemi/scores_train/ LR_lab
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_lab.csv ../data/stemi/ytrain_lab.csv \
		RF ../logs/stemi/scores_train/ RF_lab
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_lab.csv ../data/stemi/ytrain_lab.csv \
		XGB ../logs/stemi/scores_train/ XGB_lab
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_lab.csv ../data/stemi/ytrain_lab.csv \
		SVM ../logs/stemi/scores_train/ SVM_lab

#Blood gas set
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_blood_gas.csv ../data/stemi/ytrain_blood_gas.csv \
		LR ../logs/stemi/scores_train/ LR_blood_gas
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_blood_gas.csv ../data/stemi/ytrain_blood_gas.csv \
		RF ../logs/stemi/scores_train/ RF_blood_gas
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_blood_gas.csv ../data/stemi/ytrain_blood_gas.csv \
		XGB ../logs/stemi/scores_train/ XGB_blood_gas
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_blood_gas.csv ../data/stemi/ytrain_blood_gas.csv \
		SVM ../logs/stemi/scores_train/ SVM_blood_gas

#Hemodynamic set
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_hemo.csv ../data/stemi/ytrain_hemo.csv \
		LR ../logs/stemi/scores_train/ LR_hemo
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_hemo.csv ../data/stemi/ytrain_hemo.csv \
		RF ../logs/stemi/scores_train/ RF_hemo
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_hemo.csv ../data/stemi/ytrain_hemo.csv \
		XGB ../logs/stemi/scores_train/ XGB_hemo
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_hemo.csv ../data/stemi/ytrain_hemo.csv \
		SVM ../logs/stemi/scores_train/ SVM_hemo

#Vital signs set
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_vital.csv ../data/stemi/ytrain_vital.csv \
		LR ../logs/stemi/scores_train/ LR_vital
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_vital.csv ../data/stemi/ytrain_vital.csv \
		RF ../logs/stemi/scores_train/ RF_vital
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_vital.csv ../data/stemi/ytrain_vital.csv \
		XGB ../logs/stemi/scores_train/ XGB_vital
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_vital.csv ../data/stemi/ytrain_vital.csv \
		SVM ../logs/stemi/scores_train/ SVM_vital

#Procedures set
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_proc.csv ../data/stemi/ytrain_proc.csv \
		LR ../logs/stemi/scores_train/ LR_proc
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_proc.csv ../data/stemi/ytrain_proc.csv \
		RF ../logs/stemi/scores_train/ RF_proc
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_proc.csv ../data/stemi/ytrain_proc.csv \
		XGB ../logs/stemi/scores_train/ XGB_proc
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_proc.csv ../data/stemi/ytrain_proc.csv \
		SVM ../logs/stemi/scores_train/ SVM_proc

#Treatment set
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_treats.csv ../data/stemi/ytrain_treats.csv \
		LR ../logs/stemi/scores_train/ LR_treats
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_treats.csv ../data/stemi/ytrain_treats.csv \
		RF ../logs/stemi/scores_train/ RF_treats
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_treats.csv ../data/stemi/ytrain_treats.csv \
		XGB ../logs/stemi/scores_train/ XGB_treats
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_treats.csv ../data/stemi/ytrain_treats.csv \
		SVM ../logs/stemi/scores_train/ SVM_treats

#Complication set
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_complications.csv ../data/stemi/ytrain_complications.csv \
		LR ../logs/stemi/scores_train/ LR_complications
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_complications.csv ../data/stemi/ytrain_complications.csv \
		RF ../logs/stemi/scores_train/ RF_complications
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_complications.csv ../data/stemi/ytrain_complications.csv \
		XGB ../logs/stemi/scores_train/ XGB_complications
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_complications.csv ../data/stemi/ytrain_complications.csv \
		SVM ../logs/stemi/scores_train/ SVM_complications

#Demographic set
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_demo.csv ../data/stemi/ytrain_demo.csv \
		LR ../logs/stemi/scores_train/ LR_demo
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_demo.csv ../data/stemi/ytrain_demo.csv \
		RF ../logs/stemi/scores_train/ RF_demo
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_demo.csv ../data/stemi/ytrain_demo.csv \
		XGB ../logs/stemi/scores_train/ XGB_demo
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_demo.csv ../data/stemi/ytrain_demo.csv \
		SVM ../logs/stemi/scores_train/ SVM_demo

#Combined set (All of the above)
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_combined.csv ../data/stemi/ytrain_combined.csv \
		LR ../logs/stemi/scores_train/ LR_combined
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_combined.csv ../data/stemi/ytrain_combined.csv \
		RF ../logs/stemi/scores_train/ RF_combined
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_combined.csv ../data/stemi/ytrain_combined.csv \
		SVM ../logs/stemi/scores_train/ SVM_combined

#"********************************************************************************************"
#"********************************************************************************************"
#"********************************************************************************************"

echo "NSTEMI"
#Combined set (All of the above)
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_combined.csv ../data/nstemi/ytrain_combined.csv \
		LR ../logs/nstemi/scores_train/ LR_combined
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_combined.csv ../data/nstemi/ytrain_combined.csv \
		RF ../logs/nstemi/scores_train/ RF_combined
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_combined.csv ../data/nstemi/ytrain_combined.csv \
		SVM ../logs/nstemi/scores_train/ SVM_combined


#Lab clinical set
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_lab.csv ../data/nstemi/ytrain_lab.csv \
		LR ../logs/nstemi/scores_train/ LR_lab
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_lab.csv ../data/nstemi/ytrain_lab.csv \
		RF ../logs/nstemi/scores_train/ RF_lab
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_lab.csv ../data/nstemi/ytrain_lab.csv \
		XGB ../logs/nstemi/scores_train/ XGB_lab
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_lab.csv ../data/nstemi/ytrain_lab.csv \
		SVM ../logs/nstemi/scores_train/ SVM_lab

#Blood gas set
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_blood_gas.csv ../data/nstemi/ytrain_blood_gas.csv \
		LR ../logs/nstemi/scores_train/ LR_blood_gas
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_blood_gas.csv ../data/nstemi/ytrain_blood_gas.csv \
		RF ../logs/nstemi/scores_train/ RF_blood_gas
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_blood_gas.csv ../data/nstemi/ytrain_blood_gas.csv \
		XGB ../logs/nstemi/scores_train/ XGB_blood_gas
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_blood_gas.csv ../data/nstemi/ytrain_blood_gas.csv \
		SVM ../logs/nstemi/scores_train/ SVM_blood_gas

#Hemodynamic set
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_hemo.csv ../data/nstemi/ytrain_hemo.csv \
		LR ../logs/nstemi/scores_train/ LR_hemo
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_hemo.csv ../data/nstemi/ytrain_hemo.csv \
		RF ../logs/nstemi/scores_train/ RF_hemo
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_hemo.csv ../data/nstemi/ytrain_hemo.csv \
		XGB ../logs/nstemi/scores_train/ XGB_hemo
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_hemo.csv ../data/nstemi/ytrain_hemo.csv \
		SVM ../logs/nstemi/scores_train/ SVM_hemo

#Vital signs set
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_vital.csv ../data/nstemi/ytrain_vital.csv \
		LR ../logs/nstemi/scores_train/ LR_vital
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_vital.csv ../data/nstemi/ytrain_vital.csv \
		RF ../logs/nstemi/scores_train/ RF_vital
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_vital.csv ../data/nstemi/ytrain_vital.csv \
		XGB ../logs/nstemi/scores_train/ XGB_vital
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_vital.csv ../data/nstemi/ytrain_vital.csv \
		SVM ../logs/nstemi/scores_train/ SVM_vital

#Procedures set
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_proc.csv ../data/nstemi/ytrain_proc.csv \
		LR ../logs/nstemi/scores_train/ LR_proc
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_proc.csv ../data/nstemi/ytrain_proc.csv \
		RF ../logs/nstemi/scores_train/ RF_proc
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_proc.csv ../data/nstemi/ytrain_proc.csv \
		XGB ../logs/nstemi/scores_train/ XGB_proc
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_proc.csv ../data/nstemi/ytrain_proc.csv \
		SVM ../logs/nstemi/scores_train/ SVM_proc

#Treatment set
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_treats.csv ../data/nstemi/ytrain_treats.csv \
		LR ../logs/nstemi/scores_train/ LR_treats
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_treats.csv ../data/nstemi/ytrain_treats.csv \
		RF ../logs/nstemi/scores_train/ RF_treats
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_treats.csv ../data/nstemi/ytrain_treats.csv \
		XGB ../logs/nstemi/scores_train/ XGB_treats
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_treats.csv ../data/nstemi/ytrain_treats.csv \
		SVM ../logs/nstemi/scores_train/ SVM_treats

#Complication set
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_complications.csv ../data/nstemi/ytrain_complications.csv \
		LR ../logs/nstemi/scores_train/ LR_complications
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_complications.csv ../data/nstemi/ytrain_complications.csv \
		RF ../logs/nstemi/scores_train/ RF_complications
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_complications.csv ../data/nstemi/ytrain_complications.csv \
		XGB ../logs/nstemi/scores_train/ XGB_complications
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_complications.csv ../data/nstemi/ytrain_complications.csv \
		SVM ../logs/nstemi/scores_train/ SVM_complications

#Demographic set
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_demo.csv ../data/nstemi/ytrain_demo.csv \
		LR ../logs/nstemi/scores_train/ LR_demo
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_demo.csv ../data/nstemi/ytrain_demo.csv \
		RF ../logs/nstemi/scores_train/ RF_demo
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_demo.csv ../data/nstemi/ytrain_demo.csv \
		XGB ../logs/nstemi/scores_train/ XGB_demo
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_demo.csv ../data/nstemi/ytrain_demo.csv \
		SVM ../logs/nstemi/scores_train/ SVM_demo

#Combined: XGB
python3 1hyperparameter_optimization.py ../data/stemi/xtrain_combined.csv ../data/stemi/ytrain_combined.csv \
		XGB ../logs/stemi/scores_train/ XGB_combined
#se está ejecutando en ventanas apartes (for saving model)
python3 1hyperparameter_optimization.py ../data/nstemi/xtrain_combined.csv ../data/nstemi/ytrain_combined.csv \
		XGB ../logs/nstemi/scores_train/ XGB_combined