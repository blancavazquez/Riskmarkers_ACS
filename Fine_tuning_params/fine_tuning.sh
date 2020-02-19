#!/bin/bash
echo "start: $(date -Iseconds)"
echo "###########################################################"

echo "STEMI"
#Lab clinical set
python3 Fine_tuning.py ../data/stemi/lab_train.csv ../data/stemi/lab_val.csv  ../data/stemi/lab_test.csv \
        LR -n 0 ../logs/stemi/LR/ LR_lab
python3 Fine_tuning.py ../data/stemi/lab_train.csv ../data/stemi/lab_val.csv  ../data/stemi/lab_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF_lab
python3 Fine_tuning.py ../data/stemi/lab_train.csv ../data/stemi/lab_val.csv  ../data/stemi/lab_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA_lab
python3 Fine_tuning.py ../data/stemi/lab_train.csv ../data/stemi/lab_val.csv  ../data/stemi/lab_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT_lab
python3 Fine_tuning.py ../data/stemi/lab_train.csv ../data/stemi/lab_val.csv  ../data/stemi/lab_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT_lab
python3 Fine_tuning.py ../data/stemi/lab_train.csv ../data/stemi/lab_val.csv  ../data/stemi/lab_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB_lab
python3 Fine_tuning.py ../data/stemi/lab_train.csv ../data/stemi/lab_val.csv  ../data/stemi/lab_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_lab
python3 Fine_tuning.py ../data/stemi/lab_train.csv ../data/stemi/lab_val.csv  ../data/stemi/lab_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_lab

#Blood gas set
python3 Fine_tuning.py ../data/stemi/blood_train.csv ../data/stemi/blood_val.csv  ../data/stemi/blood_test.csv \
        LR -n 0 ../logs/stemi/LR/ LR_blood
python3 Fine_tuning.py ../data/stemi/blood_train.csv ../data/stemi/blood_val.csv  ../data/stemi/blood_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF_blood
python3 Fine_tuning.py ../data/stemi/blood_train.csv ../data/stemi/blood_val.csv  ../data/stemi/blood_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA_blood
python3 Fine_tuning.py ../data/stemi/blood_train.csv ../data/stemi/blood_val.csv  ../data/stemi/blood_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT_blood
python3 Fine_tuning.py ../data/stemi/blood_train.csv ../data/stemi/blood_val.csv  ../data/stemi/blood_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT_blood
python3 Fine_tuning.py ../data/stemi/blood_train.csv ../data/stemi/blood_val.csv  ../data/stemi/blood_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB_blood
python3 Fine_tuning.py ../data/stemi/blood_train.csv ../data/stemi/blood_val.csv  ../data/stemi/blood_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_blood
python3 Fine_tuning.py ../data/stemi/blood_train.csv ../data/stemi/blood_val.csv  ../data/stemi/blood_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_blood

#Hemodynamic set
python3 Fine_tuning.py ../data/stemi/hemo_train.csv ../data/stemi/hemo_val.csv  ../data/stemi/hemo_test.csv \
        LR -n 0 ../logs/stemi/LR/ LR_hemo
python3 Fine_tuning.py ../data/stemi/hemo_train.csv ../data/stemi/hemo_val.csv  ../data/stemi/hemo_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF_hemo
python3 Fine_tuning.py ../data/stemi/hemo_train.csv ../data/stemi/hemo_val.csv  ../data/stemi/hemo_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA_hemo
python3 Fine_tuning.py ../data/stemi/hemo_train.csv ../data/stemi/hemo_val.csv  ../data/stemi/hemo_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT_hemo
python3 Fine_tuning.py ../data/stemi/hemo_train.csv ../data/stemi/hemo_val.csv  ../data/stemi/hemo_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT_hemo
python3 Fine_tuning.py ../data/stemi/hemo_train.csv ../data/stemi/hemo_val.csv  ../data/stemi/hemo_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB_hemo
python3 Fine_tuning.py ../data/stemi/hemo_train.csv ../data/stemi/hemo_val.csv  ../data/stemi/hemo_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_hemo
python3 Fine_tuning.py ../data/stemi/hemo_train.csv ../data/stemi/hemo_val.csv  ../data/stemi/hemo_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_hemo

#Vital signs set
python3 Fine_tuning.py ../data/stemi/vital_train.csv ../data/stemi/vital_val.csv  ../data/stemi/vital_test.csv \
        LR -n 0 ../logs/stemi/LR/ LR_vital
python3 Fine_tuning.py ../data/stemi/vital_train.csv ../data/stemi/vital_val.csv  ../data/stemi/vital_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF_vital
python3 Fine_tuning.py ../data/stemi/vital_train.csv ../data/stemi/vital_val.csv  ../data/stemi/vital_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA_vital
python3 Fine_tuning.py ../data/stemi/vital_train.csv ../data/stemi/vital_val.csv  ../data/stemi/vital_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT_vital
python3 Fine_tuning.py ../data/stemi/vital_train.csv ../data/stemi/vital_val.csv  ../data/stemi/vital_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT_vital
python3 Fine_tuning.py ../data/stemi/vital_train.csv ../data/stemi/vital_val.csv  ../data/stemi/vital_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB_vital
python3 Fine_tuning.py ../data/stemi/vital_train.csv ../data/stemi/vital_val.csv  ../data/stemi/vital_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_vital
python3 Fine_tuning.py ../data/stemi/vital_train.csv ../data/stemi/vital_val.csv  ../data/stemi/vital_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_vital

#Procedures set
python3 Fine_tuning.py ../data/stemi/procedures_train.csv ../data/stemi/procedures_val.csv  ../data/stemi/procedures_test.csv \
        LR -n 0 ../logs/stemi/LR/ LR_procedures
python3 Fine_tuning.py ../data/stemi/procedures_train.csv ../data/stemi/procedures_val.csv  ../data/stemi/procedures_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF_procedures
python3 Fine_tuning.py ../data/stemi/procedures_train.csv ../data/stemi/procedures_val.csv  ../data/stemi/procedures_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA_procedures
python3 Fine_tuning.py ../data/stemi/procedures_train.csv ../data/stemi/procedures_val.csv  ../data/stemi/procedures_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT_procedures
python3 Fine_tuning.py ../data/stemi/procedures_train.csv ../data/stemi/procedures_val.csv  ../data/stemi/procedures_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT_procedures
python3 Fine_tuning.py ../data/stemi/procedures_train.csv ../data/stemi/procedures_val.csv  ../data/stemi/procedures_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB_procedures
python3 Fine_tuning.py ../data/stemi/procedures_train.csv ../data/stemi/procedures_val.csv  ../data/stemi/procedures_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_procedures
python3 Fine_tuning.py ../data/stemi/procedures_train.csv ../data/stemi/procedures_val.csv  ../data/stemi/procedures_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_procedures

#Treatment set
python3 Fine_tuning.py ../data/stemi/treatments_train.csv ../data/stemi/treatments_val.csv  ../data/stemi/treatments_test.csv \
        LR -n 0 ../logs/stemi/LR/ LR_treatments
python3 Fine_tuning.py ../data/stemi/treatments_train.csv ../data/stemi/treatments_val.csv  ../data/stemi/treatments_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF_treatments
python3 Fine_tuning.py ../data/stemi/treatments_train.csv ../data/stemi/treatments_val.csv  ../data/stemi/treatments_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA_treatments
python3 Fine_tuning.py ../data/stemi/treatments_train.csv ../data/stemi/treatments_val.csv  ../data/stemi/treatments_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT_treatments
python3 Fine_tuning.py ../data/stemi/treatments_train.csv ../data/stemi/treatments_val.csv  ../data/stemi/treatments_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT_treatments
python3 Fine_tuning.py ../data/stemi/treatments_train.csv ../data/stemi/treatments_val.csv  ../data/stemi/treatments_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB_treatments
python3 Fine_tuning.py ../data/stemi/treatments_train.csv ../data/stemi/treatments_val.csv  ../data/stemi/treatments_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_treatments
python3 Fine_tuning.py ../data/stemi/treatments_train.csv ../data/stemi/treatments_val.csv  ../data/stemi/treatments_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_treatments

#Complication set
python3 Fine_tuning.py ../data/stemi/complications_train.csv ../data/stemi/complications_val.csv  ../data/stemi/complications_test.csv \
        LR -n 0 ../logs/stemi/LR/ LR_complications
python3 Fine_tuning.py ../data/stemi/complications_train.csv ../data/stemi/complications_val.csv  ../data/stemi/complications_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF_complications
python3 Fine_tuning.py ../data/stemi/complications_train.csv ../data/stemi/complications_val.csv  ../data/stemi/complications_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA_complications
python3 Fine_tuning.py ../data/stemi/complications_train.csv ../data/stemi/complications_val.csv  ../data/stemi/complications_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT_complications
python3 Fine_tuning.py ../data/stemi/complications_train.csv ../data/stemi/complications_val.csv  ../data/stemi/complications_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT_complications
python3 Fine_tuning.py ../data/stemi/complications_train.csv ../data/stemi/complications_val.csv  ../data/stemi/complications_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB_complications
python3 Fine_tuning.py ../data/stemi/complications_train.csv ../data/stemi/complications_val.csv  ../data/stemi/complications_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_complications
python3 Fine_tuning.py ../data/stemi/complications_train.csv ../data/stemi/complications_val.csv  ../data/stemi/complications_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_complications

#Demographic set
python3 Fine_tuning.py ../data/stemi/demo_train.csv ../data/stemi/demo_val.csv  ../data/stemi/demo_test.csv \
        LR -n 0 ../logs/stemi/LR/ LR_demo
python3 Fine_tuning.py ../data/stemi/demo_train.csv ../data/stemi/demo_val.csv  ../data/stemi/demo_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF_demo
python3 Fine_tuning.py ../data/stemi/demo_train.csv ../data/stemi/demo_val.csv  ../data/stemi/demo_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA_demo
python3 Fine_tuning.py ../data/stemi/demo_train.csv ../data/stemi/demo_val.csv  ../data/stemi/demo_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT_demo
python3 Fine_tuning.py ../data/stemi/demo_train.csv ../data/stemi/demo_val.csv  ../data/stemi/demo_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT_demo
python3 Fine_tuning.py ../data/stemi/demo_train.csv ../data/stemi/demo_val.csv  ../data/stemi/demo_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB_demo
python3 Fine_tuning.py ../data/stemi/demo_train.csv ../data/stemi/demo_val.csv  ../data/stemi/demo_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_demo
python3 Fine_tuning.py ../data/stemi/demo_train.csv ../data/stemi/demo_val.csv  ../data/stemi/demo_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_demo

#Combined set (All of the above)
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv ../data/stemi/stemi_test.csv \
        LR -n 0 ../logs/stemi//LR/ LR
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        RF -n 0 ../logs/stemi/RF/ RF
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        ADA -n 0 ../logs/stemi/ADA/ ADA
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        GBT -n 0 ../logs/stemi/GBT/ GBT
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv ../data/stemi/stemi_test.csv \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        SVM -n 0 ../logs/stemi/SVM/ SVM_stemi
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        SGD -n 0 ../logs/stemi/SGD/ SGD_stemi

#Recursive Feature Elimination
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        LR -n 1 ../logs/stemi/LR_RFE/ LR_RFE_comb
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        RF -n 1 ../logs/stemi/RF_RFE/ RF_RFE_comb
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        ADA -n 1 ../logs/stemi/ADA_RFE/ ADA_RFE_comb
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        GBT -n 1 ../logs/stemi/GBT_RFE/ GBT_RFE_comb
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        XGBT -n 1 ../logs/stemi/XGBT_RFE/ XGBT_RFE_comb
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        LightGB -n 1 ../logs/stemi/LightGB_RFE/ LightGB_RFE_comb
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        SVM -n 1 ../logs/stemi/SVM/ SVM_stemi
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  ../data/stemi/stemi_test.csv \
        SGD -n 1 ../logs/stemi/SGD/ SGD_stemi

echo "NSTEMI"
#Lab clinical set
python3 Fine_tuning.py ../data/nstemi/lab_train.csv ../data/nstemi/lab_val.csv  ../data/nstemi/lab_test.csv \
        LR -n 0 ../logs/nstemi/LR/ LR_lab
python3 Fine_tuning.py ../data/nstemi/lab_train.csv ../data/nstemi/lab_val.csv  ../data/nstemi/lab_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF_lab
python3 Fine_tuning.py ../data/nstemi/lab_train.csv ../data/nstemi/lab_val.csv  ../data/nstemi/lab_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA_lab
python3 Fine_tuning.py ../data/nstemi/lab_train.csv ../data/nstemi/lab_val.csv  ../data/nstemi/lab_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT_lab
python3 Fine_tuning.py ../data/nstemi/lab_train.csv ../data/nstemi/lab_val.csv  ../data/nstemi/lab_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT_lab
python3 Fine_tuning.py ../data/nstemi/lab_train.csv ../data/nstemi/lab_val.csv  ../data/nstemi/lab_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB_lab
python3 Fine_tuning.py ../data/nstemi/lab_train.csv ../data/nstemi/lab_val.csv  ../data/nstemi/lab_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_lab
python3 Fine_tuning.py ../data/nstemi/lab_train.csv ../data/nstemi/lab_val.csv  ../data/nstemi/lab_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_lab

#Blood gas set
python3 Fine_tuning.py ../data/nstemi/blood_train.csv ../data/nstemi/blood_val.csv  ../data/nstemi/blood_test.csv \
        LR -n 0 ../logs/nstemi/LR/ LR_blood
python3 Fine_tuning.py ../data/nstemi/blood_train.csv ../data/nstemi/blood_val.csv  ../data/nstemi/blood_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF_blood
python3 Fine_tuning.py ../data/nstemi/blood_train.csv ../data/nstemi/blood_val.csv  ../data/nstemi/blood_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA_blood
python3 Fine_tuning.py ../data/nstemi/blood_train.csv ../data/nstemi/blood_val.csv  ../data/nstemi/blood_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT_blood
python3 Fine_tuning.py ../data/nstemi/blood_train.csv ../data/nstemi/blood_val.csv  ../data/nstemi/blood_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT_blood
python3 Fine_tuning.py ../data/nstemi/blood_train.csv ../data/nstemi/blood_val.csv  ../data/nstemi/blood_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB_blood
python3 Fine_tuning.py ../data/nstemi/blood_train.csv ../data/nstemi/blood_val.csv  ../data/nstemi/blood_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_blood
python3 Fine_tuning.py ../data/nstemi/blood_train.csv ../data/nstemi/blood_val.csv  ../data/nstemi/blood_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_blood

#Hemodynamic set
python3 Fine_tuning.py ../data/nstemi/hemo_train.csv ../data/nstemi/hemo_val.csv  ../data/nstemi/hemo_test.csv \
        LR -n 0 ../logs/nstemi/LR/ LR_hemo
python3 Fine_tuning.py ../data/nstemi/hemo_train.csv ../data/nstemi/hemo_val.csv  ../data/nstemi/hemo_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF_hemo
python3 Fine_tuning.py ../data/nstemi/hemo_train.csv ../data/nstemi/hemo_val.csv  ../data/nstemi/hemo_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA_hemo
python3 Fine_tuning.py ../data/nstemi/hemo_train.csv ../data/nstemi/hemo_val.csv  ../data/nstemi/hemo_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT_hemo
python3 Fine_tuning.py ../data/nstemi/hemo_train.csv ../data/nstemi/hemo_val.csv  ../data/nstemi/hemo_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT_hemo
python3 Fine_tuning.py ../data/nstemi/hemo_train.csv ../data/nstemi/hemo_val.csv  ../data/nstemi/hemo_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB_hemo
python3 Fine_tuning.py ../data/nstemi/hemo_train.csv ../data/nstemi/hemo_val.csv  ../data/nstemi/hemo_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_hemo
python3 Fine_tuning.py ../data/nstemi/hemo_train.csv ../data/nstemi/hemo_val.csv  ../data/nstemi/hemo_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_hemo

#Vital signs set
python3 Fine_tuning.py ../data/nstemi/vital_train.csv ../data/nstemi/vital_val.csv  ../data/nstemi/vital_test.csv \
        LR -n 0 ../logs/nstemi/LR/ LR_vital
python3 Fine_tuning.py ../data/nstemi/vital_train.csv ../data/nstemi/vital_val.csv  ../data/nstemi/vital_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF_vital
python3 Fine_tuning.py ../data/nstemi/vital_train.csv ../data/nstemi/vital_val.csv  ../data/nstemi/vital_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA_vital
python3 Fine_tuning.py ../data/nstemi/vital_train.csv ../data/nstemi/vital_val.csv  ../data/nstemi/vital_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT_vital
python3 Fine_tuning.py ../data/nstemi/vital_train.csv ../data/nstemi/vital_val.csv  ../data/nstemi/vital_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT_vital
python3 Fine_tuning.py ../data/nstemi/vital_train.csv ../data/nstemi/vital_val.csv  ../data/nstemi/vital_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB_vital
python3 Fine_tuning.py ../data/nstemi/vital_train.csv ../data/nstemi/vital_val.csv  ../data/nstemi/vital_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_vital
python3 Fine_tuning.py ../data/nstemi/vital_train.csv ../data/nstemi/vital_val.csv  ../data/nstemi/vital_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_vital

#Procedures set
python3 Fine_tuning.py ../data/nstemi/procedures_train.csv ../data/nstemi/procedures_val.csv  ../data/nstemi/procedures_test.csv \
        LR -n 0 ../logs/nstemi/LR/ LR_procedures
python3 Fine_tuning.py ../data/nstemi/procedures_train.csv ../data/nstemi/procedures_val.csv  ../data/nstemi/procedures_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF_procedures
python3 Fine_tuning.py ../data/nstemi/procedures_train.csv ../data/nstemi/procedures_val.csv  ../data/nstemi/procedures_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA_procedures
python3 Fine_tuning.py ../data/nstemi/procedures_train.csv ../data/nstemi/procedures_val.csv  ../data/nstemi/procedures_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT_procedures
python3 Fine_tuning.py ../data/nstemi/procedures_train.csv ../data/nstemi/procedures_val.csv  ../data/nstemi/procedures_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT_procedures
python3 Fine_tuning.py ../data/nstemi/procedures_train.csv ../data/nstemi/procedures_val.csv  ../data/nstemi/procedures_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB_procedures
python3 Fine_tuning.py ../data/nstemi/procedures_train.csv ../data/nstemi/procedures_val.csv  ../data/nstemi/procedures_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_procedures
python3 Fine_tuning.py ../data/nstemi/procedures_train.csv ../data/nstemi/procedures_val.csv  ../data/nstemi/procedures_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_procedures

#Treatment set
python3 Fine_tuning.py ../data/nstemi/treatments_train.csv ../data/nstemi/treatments_val.csv  ../data/nstemi/treatments_test.csv \
        LR -n 0 ../logs/nstemi/LR/ LR_treatments
python3 Fine_tuning.py ../data/nstemi/treatments_train.csv ../data/nstemi/treatments_val.csv  ../data/nstemi/treatments_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF_treatments
python3 Fine_tuning.py ../data/nstemi/treatments_train.csv ../data/nstemi/treatments_val.csv  ../data/nstemi/treatments_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA_treatments
python3 Fine_tuning.py ../data/nstemi/treatments_train.csv ../data/nstemi/treatments_val.csv  ../data/nstemi/treatments_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT_treatments
python3 Fine_tuning.py ../data/nstemi/treatments_train.csv ../data/nstemi/treatments_val.csv  ../data/nstemi/treatments_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT_treatments
python3 Fine_tuning.py ../data/nstemi/treatments_train.csv ../data/nstemi/treatments_val.csv  ../data/nstemi/treatments_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB_treatments
python3 Fine_tuning.py ../data/nstemi/treatments_train.csv ../data/nstemi/treatments_val.csv  ../data/nstemi/treatments_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_treatments
python3 Fine_tuning.py ../data/nstemi/treatments_train.csv ../data/nstemi/treatments_val.csv  ../data/nstemi/treatments_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_treatments

#Complication set
python3 Fine_tuning.py ../data/nstemi/complications_train.csv ../data/nstemi/complications_val.csv  ../data/nstemi/complications_test.csv \
        LR -n 0 ../logs/nstemi/LR/ LR_complications
python3 Fine_tuning.py ../data/nstemi/complications_train.csv ../data/nstemi/complications_val.csv  ../data/nstemi/complications_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF_complications
python3 Fine_tuning.py ../data/nstemi/complications_train.csv ../data/nstemi/complications_val.csv  ../data/nstemi/complications_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA_complications
python3 Fine_tuning.py ../data/nstemi/complications_train.csv ../data/nstemi/complications_val.csv  ../data/nstemi/complications_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT_complications
python3 Fine_tuning.py ../data/nstemi/complications_train.csv ../data/nstemi/complications_val.csv  ../data/nstemi/complications_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT_complications
python3 Fine_tuning.py ../data/nstemi/complications_train.csv ../data/nstemi/complications_val.csv  ../data/nstemi/complications_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB_complications
python3 Fine_tuning.py ../data/nstemi/complications_train.csv ../data/nstemi/complications_val.csv  ../data/nstemi/complications_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_complications
python3 Fine_tuning.py ../data/nstemi/complications_train.csv ../data/nstemi/complications_val.csv  ../data/nstemi/complications_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_complications

#Demographic set
python3 Fine_tuning.py ../data/nstemi/demo_train.csv ../data/nstemi/demo_val.csv  ../data/nstemi/demo_test.csv \
        LR -n 0 ../logs/nstemi/LR/ LR_demo
python3 Fine_tuning.py ../data/nstemi/demo_train.csv ../data/nstemi/demo_val.csv  ../data/nstemi/demo_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF_demo
python3 Fine_tuning.py ../data/nstemi/demo_train.csv ../data/nstemi/demo_val.csv  ../data/nstemi/demo_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA_demo
python3 Fine_tuning.py ../data/nstemi/demo_train.csv ../data/nstemi/demo_val.csv  ../data/nstemi/demo_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT_demo
python3 Fine_tuning.py ../data/nstemi/demo_train.csv ../data/nstemi/demo_val.csv  ../data/nstemi/demo_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT_demo
python3 Fine_tuning.py ../data/nstemi/demo_train.csv ../data/nstemi/demo_val.csv  ../data/nstemi/demo_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB_demo
python3 Fine_tuning.py ../data/nstemi/demo_train.csv ../data/nstemi/demo_val.csv  ../data/nstemi/demo_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_demo
python3 Fine_tuning.py ../data/nstemi/demo_train.csv ../data/nstemi/demo_val.csv  ../data/nstemi/demo_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_demo

#Combined set (All of the above)
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv ../data/nstemi/nstemi_test.csv \
        LR -n 0 ../logs/nstemi//LR/ LR
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        RF -n 0 ../logs/nstemi/RF/ RF
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        ADA -n 0 ../logs/nstemi/ADA/ ADA
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        GBT -n 0 ../logs/nstemi/GBT/ GBT
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv ../data/nstemi/nstemi_test.csv \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        SVM -n 0 ../logs/nstemi/SVM/ SVM_nstemi
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        SGD -n 0 ../logs/nstemi/SGD/ SGD_nstemi
#Recursive Feature Elimination
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        LR -n 1 ../logs/nstemi/LR_RFE/ LR_RFE_comb
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        RF -n 1 ../logs/nstemi/RF_RFE/ RF_RFE_comb
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        ADA -n 1 ../logs/nstemi/ADA_RFE/ ADA_RFE_comb
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        GBT -n 1 ../logs/nstemi/GBT_RFE/ GBT_RFE_comb
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        XGBT -n 1 ../logs/nstemi/XGBT_RFE/ XGBT_RFE_comb
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        LightGB -n 1 ../logs/nstemi/LightGB_RFE/ LightGB_RFE_comb
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        SVM -n 1 ../logs/nstemi/SVM/ SVM_nstemi
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  ../data/nstemi/nstemi_test.csv \
        SGD -n 1 ../logs/nstemi/SGD/ SGD_nstemi
