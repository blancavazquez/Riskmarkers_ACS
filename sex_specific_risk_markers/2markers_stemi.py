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

Code for identifing sex-specific risk markers in patiens with STEMI
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
from sklearn import utils
from sklearn.utils import class_weight
from sklearn.utils.class_weight import compute_sample_weight
from sklearn.feature_selection import RFE, SelectKBest, f_classif,chi2
from sklearn.preprocessing import StandardScaler

#Models
import xgboost as xgb
from xgboost import XGBClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import precision_score, auc, roc_auc_score, recall_score, \
                            confusion_matrix, accuracy_score, f1_score, \
                            average_precision_score, roc_curve

##plotting libraries
import shap
from sklearn import tree
from xgboost import plot_tree
import matplotlib.pyplot as plt
from sklearn.tree import export_graphviz

def create_folder(logs_file):
    try:
        if not os.path.exists(logs_file):
            os.makedirs(logs_file)
    except Exception as e:
        raise

def saving_features(feature_list,model_name,logs_file):
    f_list = pd.DataFrame(feature_list)
    file_out = os.path.join(logs_file,str(model_name +'_features_list.csv'))
    f_list.to_csv(file_out)

def read_data(raw_clinical_note):
    """ Read clinical data """
    data = pd.read_csv(raw_clinical_note, header=0,na_filter=True)
    columns = ['subject_id','hadm_id','icustay_id','Unnamed: 0'] ##'los','endotrachflag','insertion_of_endotracheal_tube','vent'
    x = data.drop(columns,axis = 1)
    return x

def read_ydata(data):
    """ Read ydata """
    data=pd.read_csv(data, header=0,na_filter=True)
    data=data.icustay_expire_flag
    data=data.to_numpy().reshape(-1,1)
    return data

def saving_metrics(model_name, logs_file, num_features,
                   auc_test, sens_test, spec_test, f1_test, acc_test,fpr, tpr):
    """ Saving final metrics in csv file.
    Metrics generated during training, validation, testing steps are saved"""
    name = pd.DataFrame({'model_name':model_name}, index=[0])
    num_features = pd.DataFrame({'num_features':num_features}, index=[0])
    auc_test = pd.DataFrame({'auc_test':auc_test},index = [0])
    sens_test = pd.DataFrame({'sens_test':sens_test},index = [0])
    spec_test = pd.DataFrame({'spec_test':spec_test},index = [0])
    f1_test = pd.DataFrame({'f1_test':f1_test},index = [0])
    acc_test = pd.DataFrame({'acc_test':acc_test},index = [0])

    fpr = str(fpr)
    tpr = str(tpr)
    fpr = pd.DataFrame({'false_positive_rate':fpr},index = [0])
    tpr = pd.DataFrame({'true_positive_rate':tpr},index = [0])

    frames = [name, num_features, auc_test,sens_test,spec_test,f1_test,acc_test, fpr, tpr]
    resultado = pd.concat(frames, axis = 1)
    url_log = model_name +'_metrics_testing.csv'
    url_log = os.path.join(logs_file,str(url_log))
    resultado.to_csv(url_log)

def plot_roc_curve(fpr, tpr,group,auc):
    plt.plot(fpr, tpr, color='red',lw=2, label='XGB AUC=%0.2f'  % auc)
    plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--')
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.legend(loc="lower right")
    plt.show()

def data_scaler(data,path_model):
    """inverse_transform scaler"""
    print("path_scaler:",path_model)
    scaler = pickle.load(open(path_model+"scaler_stemi",'rb')) #load scaler
    data = scaler.inverse_transform(data)
    return data

def generating_metrics(model_loaded, x, y,path_model):
    from sklearn.metrics import classification_report
    """Function to generate metrics: auc_score, sensitivity, specificity, f1, accuracy"""
    y_predicted = model_loaded.predict_proba(x)
    false_positive_rate, true_positive_rate, thresholds = roc_curve(y, y_predicted[:,1])
    auc_score= auc(false_positive_rate, true_positive_rate)

    y_pred = model_loaded.predict(x)
    acc = accuracy_score(y,y_pred)
    tn, fp, fn, tp = confusion_matrix(y,y_pred).ravel()
    sensitivity = tp / (tp+fn)
    specificity = tn / (tn+fp)
    f1 = f1_score(y, y_pred)

    y_predicted=pd.DataFrame(y_predicted[:,1],columns=["model_predict_proba"])
    y_predicted.to_csv(path_model+"model_y_predicted_combined.csv")
    return auc_score, sensitivity, specificity, f1, acc, false_positive_rate, true_positive_rate

def opening_model(path_model):
    print("============= Opening model ================")
    file_in = os.path.join(path_model+"modelXGB")
    print("Opening model: ",file_in)
    with open(file_in, 'rb') as final_model:
        model = pickle.load(final_model)
    return model

def saving_model(model_ehr,path_model):
    print("============= Saving model ================")
    file_out = os.path.join(path_model+"modelXGB")
    with open(file_out, 'wb') as modelfile:
        pickle.dump(model_ehr,modelfile)

def specific_interactions_age(xgb_model, data,path_model):
    xtrain_men = data[(data.Sex==0)]
    xtrain_men_scaled=data_scaler(xtrain_men,path_model)
    feature_list=xtrain_men.columns.tolist()
    shap_interaction_values = shap.TreeExplainer(xgb_model).shap_interaction_values(xtrain_men_scaled)
    shap.dependence_plot((feature_list.index('age'), feature_list.index('age')),
                          shap_interaction_values, xtrain_men)
    plt.show()

def specific_interactions_stemi_men(xgb_model, data,path_model):
    explainer = shap.TreeExplainer(xgb_model)
    data = data.rename(columns={'Avg. urea':'Avg. urea mg/dL',
                                'Max. creatinine':'Max. creatinine umol/L',
                                'Avg. creatinine':'Avg. creatinine umol/L',
                                'Avg. troponin T':'Avg. troponin T ng/L',
                                'Avg. systolic blood pressure':'Avg. systolic blood pressure mmHg',
                                'Avg. heart rate':'Avg. heart rate bpm',
                                'Min. white blood cells':'Min. white blood cells K/uL',
                                'Avg. creatine kinase mb':'Avg. creatine kinase mb units/L'
                                })

    xtrain_men = data[(data.Sex==1)]
    xtrain_men_scaled=data_scaler(xtrain_men,path_model)
    shap_values = explainer.shap_values(xtrain_men_scaled)
    
    feature_list=xtrain_men.columns.tolist()

    shap.dependence_plot(feature_list.index('Avg. partial thromboplastin time'), 
                          shap_values, xtrain_men, 
                          interaction_index=feature_list.index('Age'),
                          feature_names=feature_list)

    shap.dependence_plot(feature_list.index('Age'), 
                         shap_values, xtrain_men, 
                         interaction_index=feature_list.index('Avg. urea mg/dL'),
                         feature_names=feature_list)

    shap.dependence_plot(feature_list.index('Min. white blood cells K/uL'), shap_values, xtrain_men, 
                        interaction_index=feature_list.index('Age'),
                        feature_names=xtrain_men.columns)

    shap.dependence_plot(feature_list.index('Age'), 
                         shap_values, xtrain_men, 
                         interaction_index=feature_list.index('Avg. creatine kinase mb units/L'),
                         feature_names=feature_list)

    shap.dependence_plot(feature_list.index('Avg. systolic blood pressure mmHg'), 
                         shap_values, xtrain_men, 
                         interaction_index=feature_list.index('Avg. heart rate bpm'),
                         feature_names=feature_list)

    shap.dependence_plot(feature_list.index('Avg. creatinine umol/L'), shap_values, xtrain_men, 
                        interaction_index=feature_list.index('Avg. troponin T ng/L'),
                        feature_names=xtrain_men.columns)

    shap.dependence_plot(feature_list.index('Avg. urea mg/dL'), 
                         shap_values, xtrain_men, 
                         interaction_index=feature_list.index('Avg. creatinine umol/L'),
                         feature_names=feature_list)
    plt.show()

def specific_interactions_stemi_women(xgb_model, data,path_model):
    explainer = shap.TreeExplainer(xgb_model)
    data = data.rename(columns={'Avg. urea':'Avg. urea mg/dL',
                                'Max. creatinine':'Max. creatinine umol/L',
                                'Avg. creatinine':'Avg. creatinine umol/L',
                                'Avg. troponin T':'Avg. troponin T ng/L',
                                'Avg. systolic blood pressure':'Avg. systolic blood pressure mmHg',
                                'Avg. heart rate':'Avg. heart rate bpm',
                                'Min. white blood cells':'Min. white blood cells K/uL',
                                'Avg. creatine kinase mb':'Avg. creatine kinase mb units/L'
                                })

    xtrain_women = data[(data.Sex==0)]
    xtrain_women_scaled=data_scaler(xtrain_women,path_model)
    shap_values = explainer.shap_values(xtrain_women_scaled)
    
    feature_list=xtrain_women.columns.tolist()

    shap.dependence_plot(feature_list.index('Avg. partial thromboplastin time'), 
                          shap_values, xtrain_women, 
                          interaction_index=feature_list.index('Age'),
                          feature_names=feature_list)

    shap.dependence_plot(feature_list.index('Age'), 
                         shap_values, xtrain_women, 
                         interaction_index=feature_list.index('Avg. urea mg/dL'),
                         feature_names=feature_list)

    shap.dependence_plot(feature_list.index('Min. white blood cells K/uL'), shap_values, xtrain_women, 
                        interaction_index=feature_list.index('Age'),
                        feature_names=xtrain_women.columns)

    shap.dependence_plot(feature_list.index('Age'), 
                         shap_values, xtrain_women, 
                         interaction_index=feature_list.index('Avg. creatine kinase mb units/L'),
                         feature_names=feature_list)

    shap.dependence_plot(feature_list.index('Avg. systolic blood pressure mmHg'), 
                         shap_values, xtrain_women, 
                         interaction_index=feature_list.index('Avg. heart rate bpm'),
                         feature_names=feature_list)

    shap.dependence_plot(feature_list.index('Avg. creatinine umol/L'), shap_values, xtrain_women, 
                        interaction_index=feature_list.index('Avg. troponin T ng/L'),
                        feature_names=xtrain_women.columns)

    shap.dependence_plot(feature_list.index('Avg. urea mg/dL'), 
                         shap_values, xtrain_women, 
                         interaction_index=feature_list.index('Avg. creatinine umol/L'),
                         feature_names=feature_list)
    plt.show()

def summary_plot_women(xgb_model, data, feature_list,path_model):
    explainer = shap.TreeExplainer(xgb_model)
    xtrain_women = data[(data.Sex==0)]
    xtrain_women_scaled=data_scaler(xtrain_women,path_model)
    shap_values = explainer.shap_values(xtrain_women_scaled)
    shap.summary_plot(shap_values, xtrain_women_scaled,
                    feature_names=feature_list,
                    plot_type="dot",
                    max_display=20)
    plt.show()

def summary_plot_men(xgb_model, data, feature_list,path_model):
    explainer = shap.TreeExplainer(xgb_model)
    xtrain_men = data[(data.Sex==1)]
    xtrain_men_scaled=data_scaler(xtrain_men,path_model)
    shap_values = explainer.shap_values(xtrain_men_scaled)
    shap.summary_plot(shap_values, xtrain_men_scaled,
                    feature_names=feature_list,
                    plot_type="dot",
                    max_display=20)
    plt.show()

def summary_plot(xgb_model, data,feature_list):
    explainer = shap.TreeExplainer(xgb_model)
    shap_values = explainer.shap_values(data)
    shap.summary_plot(shap_values, data,
                    feature_names=feature_list,
                    plot_type="dot",
                    max_display=20)
    plt.show()

def summary_plot_bar(xgb_model, data,feature_list):
    explainer = shap.TreeExplainer(xgb_model)
    shap_values = explainer.shap_values(data)
    shap.summary_plot(shap_values, data,
                    feature_names=feature_list,
                    plot_type="bar",
                    max_display=20)
    plt.show()

def mortality_model(xtrain,xtest,ytrain,ytest, 
                    path_model, model_name):
    print("===================== Loading data =========================================================")
    xtrain=read_data(xtrain)
    xtest=read_data(xtest)
    ytrain=read_ydata(ytrain)
    ytest=read_ydata(ytest)

    join_sets= pd.concat([xtrain,xtest])
    feature_list=join_sets.columns

    print("xtrain:",xtrain.shape,"xtest:",xtest.shape,
          "ytrain:",ytrain.shape,"ytest:",ytest.shape,
          "join_sets::",join_sets.shape)

    "Rescaling data"
    xtrain_scaled=data_scaler(xtrain,path_model)
    xtest_scaled=data_scaler(xtest,path_model)
    join_sets_scaled=data_scaler(join_sets,path_model)
    print("===================== Loading model & final performance =======================================")
    model_loaded = opening_model(path_model)

    auc_test, sens_test, spec_test, f1_test, acc_test,fpr, tpr = generating_metrics(model_loaded, xtest_scaled, 
                                                                                    ytest,path_model)
    print("auc_test: {}, sens_test {}, spec_test: {}, f1_test {}, acc_test {}".format(auc_test, sens_test, 
                                                                                      spec_test, f1_test, 
                                                                                      acc_test))

    saving_metrics("XGB",path_model, xtrain.shape[1], 
                  auc_test, sens_test, spec_test, f1_test, acc_test,fpr, tpr)
    plot_roc_curve(fpr, tpr,"STEMI",auc_test)

    summary_plot(model_loaded, join_sets_scaled,feature_list)
    summary_plot_bar(model_loaded, join_sets_scaled,feature_list)
    summary_plot_men(model_loaded, join_sets, feature_list,path_model)
    summary_plot_women(model_loaded, join_sets, feature_list,path_model)
    specific_interactions_stemi_men(model_loaded, join_sets,path_model)
    specific_interactions_stemi_women(model_loaded, join_sets,path_model)
    specific_interactions_age(xgb_model, join_sets,path_model)

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def main():
    parser = argparse.ArgumentParser("Classification model with structure data")
    parser.add_argument("xtrain",
                        help = "Directory from xtrain data")
    parser.add_argument("xtest",
                        help = "Directory from xtest data")
    parser.add_argument("ytrain",
                        help = "Directory from ytrain data")
    parser.add_argument("ytest",
                        help = "Directory from ytest data")
    parser.add_argument("path_model",
                        help = "Directory to load model")
    parser.add_argument("model_name",
                        help = "Model name")

    args = parser.parse_args()
    mortality_model(args.xtrain,args.xtest,
                    args.ytrain,args.ytest,
                    args.path_model,args.model_name)
if __name__ == "__main__":
    main()