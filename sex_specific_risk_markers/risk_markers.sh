#!/bin/bash
"""
Blanca Vázquez <blancavazquez2013@gmail.com>
IIMAS, UNAM
2020
"""

echo "Detecting sex-specific risk markers in ACS sub-populations"
#STEMI
python3 2markers_stemi.py ../data/stemi/xtrain_combined.csv ../data/stemi/xtest_combined.csv \
                          ../data/stemi/ytrain_combined.csv ../data/stemi/ytest_combined.csv \
                          ../models/stemi/ XGB

python3 2markers_nstemi.py ../data/nstemi/xtrain_combined.csv ../data/nstemi/xtest_combined.csv \
                          ../data/nstemi/ytrain_combined.csv ../data/nstemi/ytest_combined.csv \
                          ../models/nstemi/ XGB
