## Identifing risk markers from prediction in-hospital mortality

This repository contains the codes developed for identifing risk markers in patiens with acute myocardial infarction, specifically for ST-segment elevation MI (STEMI) and non-ST-segment elevation MI (NSTEMI).

## Brief introduction
This repository is organized as follows:

* [SQL-extraction](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/SQL-extraction): this folder contains a set of scripts to extract the STEMI and NSTEMI patients from MIMIC III database. The folder describes the view creates to extract structure and clinical notes. Also, it is described step by step as the data were extracted for further processing.
* [Pre-processing](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/Pre-processing): contains the code for completing missing values.
* [Fine-tuning parameters](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/Fine_tuning_params): contains the code used to fine-tune parameters using several algorithms: Logistic Regression, Random Forest Classifier, AdaBoost Classifier, Gradient Boosting Classifier, XGBClassifier and LGBMClassifier. Also, it contains the bash file to evaluate all these algorithms.
* [Mortality_model](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/Mortality_model): once identified the best parameters and algorithms for STEMI and NSTEMI, a mortality model is build and evaluate on test set. In this code, we identified the risk markers too.
