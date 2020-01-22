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

Code for identifing risk markers in patiens with acute myocardial infarction,
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
from sklearn.feature_selection import RFE, SelectKBest, f_classif
from sklearn.preprocessing import StandardScaler

#Models
import xgboost as xgb
from xgboost import XGBClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import roc_curve, auc, roc_auc_score, confusion_matrix, accuracy_score, f1_score

##plotting libraries
import shap
from sklearn import tree
from xgboost import plot_tree
import matplotlib.pyplot as plt
from sklearn.tree import export_graphviz

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
    return auc_score, sensitivity, specificity, f1, acc, false_positive_rate, true_positive_rate

def saving_metrics(model_name, logs_file, num_features, auc_train
                   ,auc_val, sens_val, spec_val, f1_val, acc_val
                   ,auc_test, sens_test, spec_test, f1_test, acc_test,fpr, tpr):
    """ Saving final metrics in csv file.
    Metrics generated during training, validation, testing steps are saved"""
    name = pd.DataFrame({'model_name':model_name}, index=[0])
    num_features = pd.DataFrame({'num_features':num_features}, index=[0])
    auc_train = pd.DataFrame({'auc_train':auc_train},index = [0])
    auc_val = pd.DataFrame({'auc_val':auc_val},index = [0])
    sens_val = pd.DataFrame({'sens_val':sens_val},index = [0])
    spec_val = pd.DataFrame({'spec_val':spec_val},index = [0])
    f1_val = pd.DataFrame({'f1_val':f1_val},index = [0])
    acc_val = pd.DataFrame({'acc_val':acc_val},index = [0])
    auc_test = pd.DataFrame({'auc_test':auc_test},index = [0])
    sens_test = pd.DataFrame({'sens_test':sens_test},index = [0])
    spec_test = pd.DataFrame({'spec_test':spec_test},index = [0])
    f1_test = pd.DataFrame({'f1_test':f1_test},index = [0])
    acc_test = pd.DataFrame({'acc_test':acc_test},index = [0])

    fpr = str(fpr)
    tpr = str(tpr)
    fpr = pd.DataFrame({'false_positive_rate':fpr},index = [0])
    tpr = pd.DataFrame({'true_positive_rate':tpr},index = [0])

    frames = [name, num_features, auc_train, auc_val,sens_val,spec_val,f1_val,acc_val,
              auc_test,sens_test,spec_test,f1_test,acc_test, fpr, tpr]
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

def scaler(set):
    scaler = StandardScaler()
    set = scaler.fit_transform(set)
    return set

def features_selection(x_train, y_train,x_val,x_test,num_features,model,feature_list):
    selector = SelectKBest(f_classif, k=int(num_features))
    selector.fit(x_train, y_train)
    x_train = selector.transform(x_train).astype('float32')
    x_val = selector.transform(x_val).astype('float32')
    x_test = selector.transform(x_test).astype('float32')
    feature_list = [feature_list[i] for i in selector.get_support(indices=True)]
    return x_train, x_val, x_test,feature_list

def risk_markers(model_ehr, x_test,feature_list,logs_file):
    """  We used the SHAP library (SHapley Additive exPlanations) to identify the risk markers"""
    explainer = shap.TreeExplainer(model_ehr)
    shap_values = explainer.shap_values(x_test)
    shap.summary_plot(shap_values, x_test,feature_names=feature_list, plot_type='violin')
    shap.summary_plot(shap_values, x_test, feature_names=feature_list, plot_type='bar')
    plt.show()

    """ Visualize the interaction between risk markers """
    for name in feature_list:
        shap.dependence_plot(name, shap_values, x_test, feature_names=feature_list, show = False)
        features_url = os.path.join(logs_file,str(name  +'.svg'))
        plt.savefig(features_url)
        plt.close()

    """ Correlations by specific variables """
    ##TROPONIN_I_max
    inds = shap.approximate_interactions(115, shap_values, x_test)
    for i in range(3):
         shap.dependence_plot(115, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
         features_url = os.path.join(logs_file,str('troponin_i_max_'+ str(i) +'.svg'))
         plt.savefig(features_url)
    # #troponin_i_min
    inds = shap.approximate_interactions(114, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(114, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('troponin_i_min_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # #GLUCOSE_max
    inds = shap.approximate_interactions(119, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(119, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('GLUCOSE_max_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # #anion_gap
    inds = shap.approximate_interactions(86, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(86, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('anion_gap_avg_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #lactate
    inds = shap.approximate_interactions(78, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(78, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('lactate_avg_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # #pap_systolic_max
    inds = shap.approximate_interactions(131, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(131, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('pap_systolic_max_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #pap_diastolic_max
    inds = shap.approximate_interactions(133, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(133, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('pap_diastolic_max_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # #cvp_max
    inds = shap.approximate_interactions(137, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(137, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('cvp_max_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #pcwp_max
    inds = shap.approximate_interactions(145, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(145, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('pcwp_max_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #pap_mean_max
    inds = shap.approximate_interactions(135, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(135, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('pap_mean_max_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #urea
    inds = shap.approximate_interactions(110, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(110, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('urea_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #creatinine
    inds = shap.approximate_interactions(89, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(89, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('creatinine_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #partial_thromboplastin_time
    inds = shap.approximate_interactions(106, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(106, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('partial_thromboplastin_time_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #age
    inds = shap.approximate_interactions(2, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(2, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('cholesterol_hdl_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #diasbp_min
    inds = shap.approximate_interactions(160, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(160, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('diasbp_min_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #heartrate_max
    inds = shap.approximate_interactions(155, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(155, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('heartrate_max_'+ str(i) +'.svg'))
        plt.savefig(features_url)
    # # # #protein_creatinine_ratio
    inds = shap.approximate_interactions(90, shap_values, x_test)
    for i in range(3):
        shap.dependence_plot(90, shap_values, x_test, feature_names=feature_list,interaction_index=inds[i],show = False)
        features_url = os.path.join(logs_file,str('protein_creatinine_ratio_'+ str(i) +'.svg'))
        plt.savefig(features_url)

def saving_features(feature_list,model_name,logs_file):
    f_list = pd.DataFrame(feature_list)
    file_out = os.path.join(logs_file,str(model_name +'_features_list.csv'))
    f_list.to_csv(file_out)

def saving_trees(model_ehr,logs_file):
    """ Function to visualize XGB trees. The ranges generated are compared with RENASCA """
    from matplotlib.pylab import rcParams
    rcParams['figure.figsize'] = 60,50
    xgb.plot_tree(model_ehr, ax=plt.gca())
    features_url = os.path.join(logs_file,str('plot_tree_' +'.svg'))
    plt.savefig(features_url)

def saving_model(model_ehr,model_name,logs_file):
    print("============= Saving model ================")
    file_out = os.path.join(logs_file,str(model_name))
    with open(file_out, 'wb') as modelfile:
        pickle.dump(model_ehr,modelfile)

def opening_model(model_name,logs_file):
    print("============= Opening model ================")
    file_in = os.path.join(logs_file,str(model_name))
    with open(file_in, 'rb') as final_model:
        model = pickle.load(final_model)
    return model

def mortality_model(train, val, test, model, sel_RFE, num_features,logs_file, model_name):
    print("===================== Loading data =========================================================")
    x_train, y_train, feature_list = read_data(train)
    x_val, y_val, _ = read_data(val)
    x_test, y_test, _ = read_data(test)
    create_folder(logs_file)
    x_train = scaler(x_train)
    x_val = scaler(x_val)
    x_test = scaler(x_test)

    print("===================== Recursive Feature Elimination =========================================================")
    if sel_RFE == 1:
        x_train, x_val, x_test,feature_list = features_selection(x_train, y_train,x_val,x_test,num_features,model,feature_list)
    else:
        num_features = x_train.shape[1]
    print("===================== Training again with best parameters ===================================================")
    sample_weights = class_weight.compute_sample_weight('balanced', y_train) ##Imbalanced classes
    ratio = float(np.sum(y_train == 0)) / np.sum(y_train==1)
    model_ehr = xgb.XGBClassifier(n_estimators = 100, learning_rate=0.5,
                                 colsample_bytree = 0.9, subsample = 0.9,
                                 reg_alpha = 0.9,reg_lambda = 6,
                                 objective = 'binary:logistic', max_depth = 2,
                                 gamma = 10, rate_drop = 0.5, scale_pos_weight= ratio,
                                 seed = 442, eval_metric = 'auc')
    val_set  = [(x_val,y_val)]
    model_ehr = model_ehr.fit(x_train,y_train, sample_weight = sample_weights,
                              eval_set=val_set, eval_metric="auc", early_stopping_rounds=20)
    print("==================== Generating metrics =====================================================================")
    y_predicted = model_ehr.predict(x_train)
    false_positive_rate, true_positive_rate, thresholds = roc_curve(y_train, y_predicted)
    auc_train = auc(false_positive_rate, true_positive_rate)
    auc_val, sens_val, spec_val, f1_val, acc_val,_,_ = generating_metrics(model_ehr, x_val, y_val) #validation set
    print("auc_train:{},  auc_val: {}, sens_val: {}, spec_val: {}, f1_val {}, acc_val {}".format(auc_train, auc_val, sens_val, spec_val, f1_val, acc_val))

    saving_model(model_ehr,model_name,logs_file)
    model = opening_model(model_name,logs_file)
    auc_test, sens_test, spec_test, f1_test, acc_test,fpr, tpr = generating_metrics(model, x_test, y_test) #test_set
    print("auc_train:{},  auc_val:{}, auc_test: {}, sens_test {}, spec_test: {}, f1_test {}, acc_test {}".format(auc_train, auc_val, auc_test, sens_test, spec_test, f1_test, acc_test))

    print("====================Identifying risk markers for early mortality ==============================================")
    risk_markers(model_ehr, x_test,feature_list,logs_file)
    """ Saving features, metrics, trees"""
    saving_features(feature_list,model_name,logs_file)
    saving_metrics(model_name, logs_file, num_features, auc_train
                  ,auc_val, sens_val, spec_val, f1_val, acc_val
                  ,auc_test, sens_test, spec_test, f1_test, acc_test,fpr, tpr)
    print("====================Identifying clinical ranges for each risk marker ==========================================")
    saving_trees(model_ehr,logs_file) #This function is applied to compare ranges with RENASCA

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
def main():
    parser = argparse.ArgumentParser("Classification model with structure data")
    parser.add_argument("train",
                        help = "Directory from train data")
    parser.add_argument("val",
                        help = "Directory from validation data")
    parser.add_argument("test",
                        help = "Directory from testing data")
    parser.add_argument("model",
                        help = "Model for bow")
    parser.add_argument("-rfe", "--sel_RFE", type = int, default = [2],
                        help = "Recursive Feature")
    parser.add_argument("-num", "--num_features", type = int,
                        help = "Optimal features number")
    parser.add_argument("logs_file",
                        help = "Directory to save logs_file")
    parser.add_argument("model_name",
                        help = "Model name")

    args = parser.parse_args()
    mortality_model(args.train,
              args.val,
              args.test,
              args.model,
              args.sel_RFE,
              args.num_features,
              args.logs_file,
              args.model_name)
if __name__ == "__main__":
    main()
