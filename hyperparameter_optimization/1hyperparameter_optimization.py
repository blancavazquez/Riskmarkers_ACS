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

Code for fine tuning parameters to predict in-hospital mortality
"""

import os
import re
import string
import pickle
import warnings
import argparse
import numpy as np
from numpy import std
import pandas as pd
from pandas import read_csv
warnings.filterwarnings('ignore')

#Preprocessing
from sklearn import utils
from sklearn import model_selection
from sklearn import preprocessing
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler
from sklearn.utils import class_weight
from sklearn.utils.class_weight import compute_sample_weight
from sklearn.feature_selection import RFE, SelectKBest, f_classif
from sklearn.pipeline import Pipeline

#Models
import xgboost
from sklearn import svm
import xgboost as xgb
from xgboost import XGBClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV, train_test_split, cross_val_score, RepeatedStratifiedKFold
from sklearn.metrics import roc_curve, auc, roc_auc_score, classification_report, confusion_matrix, accuracy_score, f1_score

##plotting libraries
import matplotlib.pyplot as plt
from xgboost import plot_tree
from sklearn import tree
import matplotlib.pylab as pl

def generating_metrics(model, model_ehr, x, y):
    """Function to generate metrics: auc_score, sensitivity, specificity, f1, accuracy"""
    if model == "LR" or model =="RF" or model =="ADA" or model =="GBT" or model =="XGBT" or model =="LightGB":
        y_pred_proba = model_ehr.predict_proba(x)[:, 1]
        y_pred = model_ehr.predict(x)
        y_predicted = np.where(y_pred > 0.5, 1, 0) #Turn probability to 0-1 binary output
        acc = accuracy_score(y,y_predicted)
        tn, fp, fn, tp = confusion_matrix(y,y_predicted).ravel()
        false_positive_rate, true_positive_rate, thresholds = roc_curve(y, y_pred_proba)
    else:
        y_pred = model_ehr.predict(x)
        y_predicted = np.where(y_pred > 0.5, 1, 0) #Turn probability to 0-1 binary output
        acc = accuracy_score(y,y_predicted)
        tn, fp, fn, tp = confusion_matrix(y,y_predicted).ravel()
        false_positive_rate, true_positive_rate, thresholds = roc_curve(y, y_predicted)

    sensitivity = tp / (tp+fn)
    specificity = tn / (tn+fp)
    auc_score = auc(false_positive_rate, true_positive_rate)
    f1 = f1_score(y, y_predicted)
    return auc_score, sensitivity, specificity, f1, acc, false_positive_rate, true_positive_rate


def create_folder(logs_file):
    try:
        if not os.path.exists(logs_file):
            os.makedirs(logs_file)
    except Exception as e:
        raise

def saving_parameters(num_features, best_params, auc_training, model_name,logs_file):
    """ Once that fine-tuning was done, the best parameters are saved"""
    name = pd.DataFrame({'model_name':model_name}, index=[0])
    num_features = pd.DataFrame({'num_features':num_features}, index=[0])
    auc_training = pd.DataFrame({'auc_training': auc_training}, index = [0])
    best_params = pd.DataFrame({'best_params': best_params})
    frames = [name, auc_training, best_params]
    resultado = pd.concat(frames, axis = 1)
    output_file = model_name +'_parameters.csv'
    output_file = os.path.join(logs_file+'/parameters',str(output_file))
    resultado.to_csv(output_file)

def imputer(x_train,x_val,x_test):
    imputer = SimpleImputer(missing_values=np.nan, strategy='mean').fit(x_train)
    x_train = imputer.transform(x_train)
    x_val = imputer.transform(x_val)
    x_test = imputer.transform(x_test)
    return x_train,x_val,x_test

def scaler(x_train,logs_file):
    scaler = StandardScaler().fit(x_train)
    x_train = scaler.transform(x_train)

    pickle.dump(scaler, open(logs_file+'scaler', 'wb'))
    return x_train

def saving_model(model_ehr,model_name,logs_file):
    print("============= Saving model ================")
    file_out = os.path.join(logs_file,str(model_name))
    with open(file_out, 'wb') as modelfile:
        pickle.dump(model_ehr,modelfile)

def read_data(raw_clinical_note):
    """ Read clinical data """
    data = pd.read_csv(raw_clinical_note, header=0,na_filter=True)
    col = data.columns
    columns = ['subject_id','hadm_id','icustay_id','Unnamed: 0']
    x = data.drop(columns,axis = 1)
    feature_list = list(x.columns)
    return x,feature_list

def saving_metrics(model_name, logs_file, num_features, auc_train,std_train):
    """ Saving final metrics in csv file.
    Metrics generated during training, validation, testing steps are saved"""
    name = pd.DataFrame({'model_name':model_name}, index=[0])
    num_features = pd.DataFrame({'num_features':num_features}, index=[0])
    mean_cross_validated_score = pd.DataFrame({'mean_cross_validated_score':auc_train},index = [0])
    std_train = pd.DataFrame({'std_val_score':std_train},index = [0])

    frames = [name, num_features, mean_cross_validated_score,std_train]
    resultado = pd.concat(frames, axis = 1)
    url_log = model_name +'_metrics.csv'
    url_log = os.path.join(logs_file,str(url_log))
    resultado.to_csv(url_log)

def saving_data(xtrain, xval, ytrain, yval,xtest,ytest,feature_list,logs_file,model_name):
    xtrain = pd.DataFrame(xtrain,columns=feature_list)
    xval = pd.DataFrame(xval,columns=feature_list)
    xtest = pd.DataFrame(xtest,columns=feature_list)

    ytrain = pd.DataFrame(ytrain)
    yval = pd.DataFrame(yval)
    ytest = pd.DataFrame(ytest)

    save_csvfiles(xtrain,logs_file,"xtrain",model_name)
    save_csvfiles(xval,logs_file,"xval",model_name)
    save_csvfiles(ytrain,logs_file,"ytrain",model_name)
    save_csvfiles(yval,logs_file,"yval",model_name)
    save_csvfiles(xtest,logs_file,"xtest",model_name)
    save_csvfiles(ytest,logs_file,"ytest",model_name)

def save_csvfiles(data,logs_file,filename,model_name):
    output_file = model_name +'_'+str(filename)+'.csv'
    output_file = os.path.join(logs_file,str(output_file))
    data.to_csv(output_file)

def mortality_model(xtrain, ytrain, model,logs_file, model_name):
    """===================== Loading data ================================================================"""
    create_folder(logs_file)
    xtrain,feature_list = read_data(xtrain) 
    xtrain = scaler(xtrain,logs_file)
    num_features = len(feature_list)

    ytrain=pd.read_csv(ytrain, header=0,na_filter=True)
    ytrain=ytrain.icustay_expire_flag.to_numpy()
    ytrain=ytrain.reshape(-1,1)

    print("xtrain:",xtrain.shape)
    print("ytrain",ytrain.shape)
    print("feature_list:",len(feature_list))

    print("=====================  Fine-tuning  ==============================================================")
    cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=10, random_state=422) #for training
    sample_weights = class_weight.compute_sample_weight('balanced', ytrain)

    if model == 'LR':
        x_train = (xtrain-xtrain.mean())/(xtrain.max()-xtrain.min())
        parameters={"C":np.logspace(-3,3,7), "penalty":["elasticnet"],"solver":['saga'], "l1_ratio":[0.5],
                    "class_weight": ['balanced'],}
        estimator = LogisticRegression()
    if model == 'SVM':
        parameters={"C":np.logspace(-3,3,7), "class_weight": ['balanced'],"random_state": [422]}
        estimator = svm.LinearSVC()
    if model == 'RF':
        parameters={"n_estimators":[100,200, 50,10], "max_features": ['log2'],
                "max_depth" : [2, 4,6],"criterion":['gini'], "min_impurity_decrease":[1e-4, 1e-7],
                "class_weight":['balanced'],"random_state": [422]}
        estimator = RandomForestClassifier()
    if model == 'XGB':
        ratio = float(np.sum(ytrain == 0)) / np.sum(ytrain==1)
        parameters={"n_estimators":[100,250], "learning_rate": [0.1,0.003],"colsample_bytree" : [0.3,0.4],
                    "subsample" : [0.3,0.9], "reg_alpha" : [0.5,0.9], "reg_lambda": [2,6],
                    "objective": ['binary:logistic'], "max_depth":[4,6], "gamma":[10,50],"rate_drop": [0.5],
                    "seed": [422], "eval_metric": ['auc'],
                    "scale_pos_weight": [ratio]}
        estimator = xgb.XGBClassifier()
    grid = GridSearchCV(estimator=estimator, param_grid=parameters, cv = cv, scoring='roc_auc', refit = True)
    grid.fit(xtrain,ytrain,sample_weight = sample_weights)
    auc_train = grid.best_score_
    std_train = grid.cv_results_['std_test_score'][grid.best_index_]
    best_params = grid.best_params_
    print("auc_validation:",auc_train,"std_validation:",std_train)

    print("===================== Training again with best parameters =========================================")
    if model == "LR":
        model_ehr = LogisticRegression(**best_params)
        model_ehr = model_ehr.fit(xtrain,ytrain)
    if model == "SVM":
        model_ehr = svm.LinearSVC(**best_params)
        model_ehr = model_ehr.fit(xtrain,ytrain)
    if model == "RF":
        model_ehr = RandomForestClassifier(**best_params)
        model_ehr = model_ehr.fit(xtrain,ytrain)
    if model == "XGB":
        model_ehr = xgb.XGBClassifier(**best_params)
        model_ehr = model_ehr.fit(xtrain,ytrain)

    # """ Saving metrics"""
    saving_metrics(model_name, logs_file, num_features, auc_train,std_train)
    saving_parameters(num_features,best_params, auc_train, model_name,logs_file)
    saving_model(model_ehr,model_name,logs_file)
    print("Ready: ", model_name)
    

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def main():
    parser = argparse.ArgumentParser("Classification model with structure data")
    parser.add_argument("xtrain",
                        help = "Directory from xtrain data")
    parser.add_argument("ytrain",
                        help = "Directory from ytrain data")
    parser.add_argument("model",
                        help = "Model for bow")
    parser.add_argument("logs_file",
                        help = "Directory to save logs_file")
    parser.add_argument("model_name",
                        help = "Model name")

    args = parser.parse_args()
    mortality_model(args.xtrain,args.ytrain,
                    args.model,args.logs_file,
                    args.model_name)
if __name__ == "__main__":
    main()