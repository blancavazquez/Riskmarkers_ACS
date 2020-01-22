#!/bin/bash
echo "start: $(date -Iseconds)"
echo "###########################################################"

echo "STEMI"
echo "All variables (without RFE)"
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        LR -n0 ../logs/stemi/c/LR/ LR
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        RF -n 0 ../logs/stemi/RF/ RF
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        ADA -n 0 ../logs/stemi/ADA/ ADA
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        GBT -n 0 ../logs/stemi/GBT/ GBT
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        XGBT -n 0 ../logs/stemi/XGBT/ XGBT
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        LightGB -n 0 ../logs/stemi/LightGB/ LightGB
echo "Recursive Feature Elimination"
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        LR -n 1 ../logs/stemi/LR_RFE/ LR_RFE
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        RF -n 1 ../logs/stemi/RF_RFE/ RF_RFE
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        ADA -n 1 ../logs/stemi/ADA_RFE/ ADA_RFE
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        GBT -n 1 ../logs/stemi/GBT_RFE/ GBT_RFE
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        XGBT -n 1 ../logs/stemi/XGBT_RFE/ XGBT_RFE
python3 Fine_tuning.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv  \
        LightGB -n 1 ../logs/stemi/LightGB_RFE/ LightGB_RFE

echo "NSTEMI"
echo "All variables (without RFE)"
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        LR -n0 ../logs/nstemi/LR/ LR
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        RF -n 0 ../logs/nstemi/RF/ RF
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        ADA -n 0 ../logs/nstemi/ADA/ ADA
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        GBT -n 0 ../logs/nstemi/GBT/ GBT
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        XGBT -n 0 ../logs/nstemi/XGBT/ XGBT
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        LightGB -n 0 ../logs/nstemi/LightGB/ LightGB
echo "Recursive Feature Elimination"
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        LR -n 1 ../logs/nstemi/LR_RFE/ LR_RFE
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        RF -n 1 ../logs/nstemi/RF_RFE/ RF_RFE
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        ADA -n 1 ../logs/nstemi/ADA_RFE/ ADA_RFE
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        GBT -n 1 ../logs/nstemi/GBT_RFE/ GBT_RFE
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        XGBT -n 1 ../logs/nstemi/XGBT_RFE/ XGBT_RFE
python3 Fine_tuning.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv  \
        LightGB -n 1 ../logs/nstemi/LightGB_RFE/ LightGB_RFE
