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
import lightgbm as lgb
import xgboost as xgb
from xgboost import XGBClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import AdaBoostClassifier, RandomForestClassifier, GradientBoostingClassifier
from sklearn.model_selection import GridSearchCV, RepeatedKFold, KFold, cross_val_score, StratifiedKFold
from sklearn.metrics import roc_curve, auc, roc_auc_score, classification_report, confusion_matrix, accuracy_score, f1_score

##plotting libraries
import matplotlib.pyplot as plt
from xgboost import plot_tree
from sklearn import tree
import matplotlib.pylab as pl
import shap

#----------- Hyperparameter
cv = RepeatedKFold(n_splits=5, n_repeats=2, random_state=422) #for training
#--------------------------

def read_data(raw_clinical_note):
    """ Read clinical data """
    data = pd.read_csv(raw_clinical_note, header=0,na_filter=True)
    col = data.columns
    x = data.drop('icustay_expire_flag', axis = 1) #features
    y = data.icustay_expire_flag #label
    feature_list = list(x.columns)
    return x, y, feature_list

def generating_metrics(model_ehr, x, y):
    """Function to generate metrics: auc_score, sensitivity, specificity, f1, accuracy"""
    y_pred = model_ehr.predict(x)
    y_predicted = np.where(y_pred > 0.5, 1, 0) #Turn probability to 0-1 binary output
    acc = accuracy_score(y,y_predicted)
    tn, fp, fn, tp = confusion_matrix(y,y_predicted).ravel()
    false_positive_rate, true_positive_rate, thresholds = roc_curve(y, y_pred)
    sensitivity = tp / (tp+fn)
    specificity = tn / (tn+fp)
    auc_score = auc(false_positive_rate, true_positive_rate)
    f1 = f1_score(y, y_predicted)
    return auc_score, sensitivity, specificity, f1, acc

def saving_metrics(num_features,auc_train,auc_val, sens_val, spec_val, f1_val, acc_val,model_name, logs_file):
    """ Saving final metrics in csv file.
    Metrics generated during training and validation steps are saved"""
    name = pd.DataFrame({'model_name':model_name}, index=[0])
    num_features = pd.DataFrame({'num_features':num_features}, index=[0])
    auc_train = pd.DataFrame({'auc_train':auc_train},index = [0])
    auc_val = pd.DataFrame({'auc_val':auc_val},index = [0])
    sens_val = pd.DataFrame({'sens_val':sens_val},index = [0])
    spec_val = pd.DataFrame({'spec_val':spec_val},index = [0])
    f1_val = pd.DataFrame({'f1_val':f1_val},index = [0])
    acc_val = pd.DataFrame({'acc_val':acc_val},index = [0])
    frames = [name, num_features, auc_train, auc_val,sens_val,spec_val,f1_val,acc_val]
    resultado = pd.concat(frames, axis = 1)
    url_log = model_name +'_metrics.csv'
    url_log = os.path.join(logs_file,str(url_log))
    resultado.to_csv(url_log)

def create_folder(logs_file):
    try:
        if not os.path.exists(logs_file):
            os.makedirs(logs_file)
    except Exception as e:
        raise

def saving_parameters(num_features, best_params, auc_training, auc_validation, model_name,logs_file):
    """ Once that fine-tuning was done, the best parameters are saved"""
    name = pd.DataFrame({'model_name':model_name}, index=[0])
    num_features = pd.DataFrame({'num_features':num_features}, index=[0])
    auc_training = pd.DataFrame({'auc_training': auc_training}, index = [0])
    auc_validation = pd.DataFrame({'auc_validation': auc_validation}, index = [0])
    best_params = pd.DataFrame({'best_params': best_params})
    frames = [name, auc_training, auc_validation, best_params]
    resultado = pd.concat(frames, axis = 1)
    output_file = model_name +'_parameters.csv'
    output_file = os.path.join(logs_file,str(output_file))
    resultado.to_csv(output_file)

def imputer(set):
    imputer = SimpleImputer(missing_values=np.nan, strategy='mean')
    set = imputer.fit_transform(set)
    return set

def scaler(set):
    scaler = StandardScaler()
    set = scaler.fit_transform(set)
    return set

def features_selection(x_train, y_train,x_val, model,feature_list):
    """Feature ranking with recursive feature elimination using pipeline"""
    n_features = x_train.shape[1]
    print("n_features original: ",n_features)
    if model == 'LR':
        estimator = LogisticRegression(random_state = 442, penalty = 'elasticnet', solver= 'saga',l1_ratio=0.5)
    if model == 'ADA':
        estimator = AdaBoostClassifier(DecisionTreeClassifier(max_depth=5, class_weight = 'balanced'),random_state = 442)
    if model == 'RF':
        estimator = RandomForestClassifier(random_state=442, class_weight = 'balanced')
    if model == 'GBT':
        estimator = GradientBoostingClassifier(random_state = 442)
    if model == 'XGBT':
        ratio = float(np.sum(y_train == 0)) / np.sum(y_train==1)
        estimator = XGBClassifier(seed = 442,eval_metric = 'auc', scale_pos_weight = ratio)
    if model == 'LightGB':
        ratio = float(np.sum(y_train == 0)) / np.sum(y_train==1)
        estimator = lgb.LGBMClassifier(seed = 442, scale_pos_weight = ratio)

    print("Searching RFE")
    classifier = RFE(estimator=estimator, step=1)
    model = Pipeline([('classifier', classifier)])
    parameters = {'classifier__n_features_to_select': [int(n_features*0.25),int(n_features*0.5),int(n_features*0.75),n_features]}
    grid = GridSearchCV(model, parameters, cv=3)
    grid.fit(x_train, y_train)
    num_features = grid.best_params_
    num_features = re.sub(r'[^\d]','',str(num_features))
    print("Optimal number of features",num_features)

    print("SelectKBest")
    selector = SelectKBest(f_classif, k=int(num_features)) #we pass the "optimal number of features" discovered in the previous pass
    selector.fit(x_train, y_train)
    x_train = selector.transform(x_train).astype('float32')
    x_val = selector.transform(x_val).astype('float32')
    feature_list = [feature_list[i] for i in selector.get_support(indices=True)]
    return x_train, x_val,feature_list, num_features

def mortality_model(train, val, model, sel_RFE,logs_file, model_name):
    print("===================== Loading data ================================================================")
    create_folder(logs_file)
    x_train, y_train, feature_list = read_data(train)
    x_val, y_val, _ = read_data(val)
    """ Normalization data"""
    x_train = scaler(x_train)
    x_val = scaler(x_val)

    print("===================== Recursive Feature Elimination ===============================================")
    if sel_RFE == 1:
        x_train, x_val,feature_list, num_features = features_selection(x_train, y_train,x_val, model,feature_list)
    else:
        num_features = x_train.shape[1]
        print("num_features",num_features)
    """ Imbalanced classes """
    sample_weights = class_weight.compute_sample_weight('balanced', y_train)
    print("=====================  Fine-tuning  ==============================================================")
    if model == 'LR':
        x_train = (x_train-x_train.mean())/(x_train.max()-x_train.min())
        parameters={"C":np.logspace(-3,3,7), "penalty":["elasticnet"],"solver":['saga'], "l1_ratio":[0.5],
                    "class_weight": ['balanced'],"random_state": [422]}
        estimator = LogisticRegression()
    if model == 'RF':
        parameters={"n_estimators":[100,200, 50,10], "max_features": ['log2'],
                "max_depth" : [2, 4,6],"criterion":['gini'], "min_impurity_decrease":[1e-4, 1e-7],
                "class_weight":['balanced'],"random_state": [422]}
        estimator = RandomForestClassifier()
    if model == 'ADA':
        parameters={"n_estimators":[50, 100], "learning_rate": [1e-4, 1e-7],"random_state": [422]}
        estimator = AdaBoostClassifier(DecisionTreeClassifier(max_depth=5, class_weight = 'balanced'))
    if model == 'GBT':
        parameters={"n_estimators":[100,200], "learning_rate": [1.0, 0.1,0.9], "max_features": ['log2'],
                    "max_depth":[5, 2], "criterion": ["friedman_mse"], "loss": ['exponential'],
                    "min_impurity_split":[1e-4, 1e-7], "min_weight_fraction_leaf": [0], "random_state": [422]}
        estimator = GradientBoostingClassifier()
    if model == 'XGBT':
        ratio = float(np.sum(y_train == 0)) / np.sum(y_train==1)
        parameters={"n_estimators":[100,120], "learning_rate": [0.1,0.05],"colsample_bytree" : [0.4, 0.8],
                    "subsample" : [0.8, 0.4], "reg_alpha" : [0.5], "reg_lambda": [2],
                    "objective": ['binary:logistic'], "max_depth":[4, 2], "gamma":[10],"rate_drop": [0.5, 0.3],
                    "seed": [422], "eval_metric": ['auc'],
                    "scale_pos_weight": [ratio]}
        estimator = xgb.XGBClassifier()
    if model == 'LightGB':
        ratio = float(np.sum(y_train == 0)) / np.sum(y_train==1)
        parameters={"objective": ['binary'],"learning_rate":[0.1,0.9],
                    "metric":['auc'], "max_bin":[130], "feature_fraction":[0.8],"min_data_in_bin":[1],
                    "max_depth":[10],"min_data_in_leaf": [10],"min_sum_hessian_in_leaf":[1e-10],"drop_rate":[0.5],
                    "bagging_fraction":[0.5,1.0],"num_leaves":[31],"boost_from_average":['true'],"lambda_l2":[0.09, 0.9],
                    "min_gain_to_split":[10], "num_iterations":[200], "random_state": [422],"scale_pos_weight": [ratio]}
        estimator = lgb.LGBMClassifier()
    print("-----------GridSearchCV-----------------")
    grid = GridSearchCV(estimator=estimator, param_grid=parameters, cv = cv, scoring='roc_auc', iid="warn", refit = True)
    grid.fit(x_train,y_train,sample_weight = sample_weights)
    auc_train = grid.best_score_
    best_params = grid.best_params_

    print("===================== Training again with best parameters =========================================")
    if model == "LR":
        model_ehr = LogisticRegression(**best_params)
        model_ehr = model_ehr.fit(x_train,y_train)
    if model == "RF":
        model_ehr = RandomForestClassifier(**best_params)
        model_ehr = model_ehr.fit(x_train,y_train)
    if model == "ADA":
        model_ehr = AdaBoostClassifier(DecisionTreeClassifier(max_depth=5, class_weight = 'balanced'),**best_params)
        model_ehr = model_ehr.fit(x_train,y_train)
    if model == "GBT":
        model_ehr = GradientBoostingClassifier(**best_params)
        model_ehr = model_ehr.fit(x_train,y_train)
    if model == "XGBT":
        model_ehr = xgb.XGBClassifier(**best_params)
        model_ehr = model_ehr.fit(x_train,y_train)
    if model == "LightGB":
        model_ehr = lgb.LGBMClassifier(**best_params)
        model_ehr = model_ehr.set_params(random_state= 422, scale_pos_weight = ratio)
        model_ehr = model_ehr.fit(x_train,y_train)

    """ Saving metrics"""
    if model == "LR" or model == "RF" or model == "ADA" or model == "GBT" or model == "LightGB":
        auc_val, sens_val, spec_val, f1_val, acc_val = generating_metrics(model_ehr, x_val, y_val)
    print("auc_train:{},  auc_val: {}, sens_val: {}, spec_val: {}, f1_val {}, acc_val {}".format(auc_train, auc_val,
                                                                                                 sens_val, spec_val, f1_val, acc_val))
    saving_metrics(num_features,auc_train,auc_val, sens_val, spec_val, f1_val, acc_val,model_name, logs_file)
    saving_parameters(num_features,best_params, auc_train, auc_val, model_name,logs_file)
    print("Ready: ", model_name)

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def main():
    parser = argparse.ArgumentParser("Classification model with structure data")
    parser.add_argument("train",
                        help = "Directory from train data")
    parser.add_argument("val",
                        help = "Directory from validation data")
    parser.add_argument("model",
                        help = "Model for bow")
    parser.add_argument("-n", "--sel_RFE", type = int, default = [2],
                        help = "Recursive Feature")
    parser.add_argument("logs_file",
                        help = "Directory to save logs_file")
    parser.add_argument("model_name",
                        help = "Model name")

    args = parser.parse_args()
    mortality_model(args.train,
              args.val,
              args.model,
              args.sel_RFE,
              args.logs_file,
              args.model_name)
if __name__ == "__main__":
    main()
