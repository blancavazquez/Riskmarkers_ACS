#!/bin/bash
"""
Blanca Vázquez <blancavazquez2013@gmail.com>
IIMAS, UNAM
2020
"""

echo "Building mortality model for STEMI and NSTEMI diagnosis based on XGBT models"

echo "STEMI"
python3 model.py ../data/stemi/stemi_train.csv ../data/stemi/stemi_val.csv ../data/stemi/stemi_test.csv \
        XGBT ../logs/stemi/model/ -rfe 0 -num 192 stemi_model

echo "NSTEMI"
python3 model.py ../data/nstemi/nstemi_train.csv ../data/nstemi/nstemi_val.csv ../data/nstemi/nstemi_test.csv \
        XGBT ../logs/nstemi/model/ -rfe 1 -num 101 nstemi_model
