"""
Blanca Vázquez <blancavazquez2013@gmail.com>
IIMAS, UNAM
2020

-------------------------------------------------------------------------
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------

Code for computing a Cox model
"""

from lifelines import CoxPHFitter
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.impute import SimpleImputer
import numpy as np


def read_data(database):
    """ Read clinical data """
    #Concatenar: train & test
    xtest = pd.read_csv('../data/'+str(database)+'/xtest_combined.csv', header=0,na_filter=True)
    ytest = pd.read_csv('../data/'+str(database)+'/ytest_combined.csv', header=0,na_filter=True)
    xtrain = pd.read_csv('../data/'+str(database)+'/xtrain_combined.csv', header=0,na_filter=True)
    ytrain = pd.read_csv('../data/'+str(database)+'/ytrain_combined.csv', header=0,na_filter=True)


    columns = ['subject_id','hadm_id','icustay_id','Unnamed: 0']

    xtest = xtest.drop(columns,axis = 1)
    xtrain = xtrain.drop(columns,axis = 1)

    xtest["icustay_expire_flag"] = ytest["icustay_expire_flag"]
    xtrain["icustay_expire_flag"] = ytrain["icustay_expire_flag"]
    
    #Concat both sets
    data = pd.concat([xtrain,xtest])

    #Selecction by sex
    data_women = data[data.Sex==0]
    data_men = data[data.Sex==1]

    data_women = data_women.drop(["Sex"],axis = 1)
    data_men = data_men.drop(["Sex"],axis = 1)

    return data_women, data_men

patients="nstemi" #indicate the population: "stemi" or "nstemi"
print("Loading data::::", patients)

data_women, data_men = read_data(patients)
feature_list= data_women.columns

print("data_women::",data_women.shape, "data_men:",data_men.shape)

print("Computing CoxPHFitter") #breslow
model = CoxPHFitter(penalizer=0.03, baseline_estimation_method= "breslow")
model_women = model.fit(data_women, 'Length of stay', 'icustay_expire_flag', 
                        robust = True, show_progress=True, step_size=0.50)
model_women.print_summary()

