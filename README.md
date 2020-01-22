## Identifing risk markers from prediction in-hospital mortality

This repository contains the codes developed for identifing risk markers in patiens with acute myocardial infarction, specifically for ST-segment elevation MI (STEMI) and non-ST-segment elevation MI (NSTEMI).

## Brief introduction
This repository is organized as follows:

* [SQL-extraction](https://www.google.com): this folder contains a set of scripts to extract the STEMI and NSTEMI patients from MIMIC III database. The folder describes the view creates to extract structure and clinical notes. Also, it is described step by step as the data were extracted for further processing.
* [Pre-processing](https://www.google.com): contains the code for completing missing values.
* [Fine-tunning parameters](https://www.google.com): contains the code used to fine-tune parameters using several algorithms: Logistic Regression, Random Forest Classifier, AdaBoost Classifier, Gradient Boosting Classifier, XGBClassifier and LGBMClassifier. Also, it contains the bash file to evaluate all these algorithms.
* [Mortality_model](https://www.google.com): once identified the best parameters and algorithms for STEMI and NSTEMI, a mortality model is build and evaluate on test set. In this code, we identified the risk markers too.
