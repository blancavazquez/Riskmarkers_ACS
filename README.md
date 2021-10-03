## Risk markers by sex for in-hospital mortality in patients with acute coronary syndrome based on machine learning

This repository identified in-hospital mortality markers for women and men in Acute Myocardial Infarction (ACS) sub-populations from a public database of EHR using machine learning methods.


## Brief introduction
This repository is organized as follows:

* [SQL-extraction](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/SQL-extraction): this folder contains a set of scripts to extract the STEMI and NSTEMI patients from MIMIC III database based on SQL. The folder describes the view creates to extract structure and clinical notes. Also, it is described step by step as the data were extracted for further processing.
* [Notebooks]:contains the jupyter notebooks for exploring, pre-processing and splitting the EHR data.
* [Parameter_opimization](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/Fine_tuning_params): contains the code used to fine-tune parameters using several algorithms: Logistic Regression, Random Forest Classifier,Support Vector Machine, and XGBoost. Also, it contains the bash file to evaluate all these algorithms.
* [Risk_marker_identification](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/Mortality_model): contains the codes used for obtaining the sex-specific markers for each ACS-subpopulation. 
* [Cox model]: contain the codes used for computing a multivariable Cox regression model.

## Requirements:
* Python 3.6
* Numpy
* Pandas
* Matplotlib
* xgboost
* statsmodels
* jupiter notebook

You can create a conda environment with all the dependencies using the environment.yml file in this repository.

conda env create --file markers_ACS.yml
