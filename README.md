## Risk markers by sex for in-hospital mortality in patients with acute coronary syndrome based on machine learning

This repository identified in-hospital mortality markers for women and men in Acute Myocardial Infarction (ACS) sub-populations from a public database of EHR using machine learning methods.


## Brief introduction
This repository is organized as follows:

* [SQL_extraction](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/sql_extraction): this folder contains a set of scripts to extract the STEMI and NSTEMI patients from MIMIC III database based on SQL. The folder describes the view creates to extract structure and clinical notes. Also, it is described step by step as the data were extracted for further processing.
* [Notebooks](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/notebooks): contains the jupyter notebooks for exploring, pre-processing and splitting the EHR data.
* [Hyperparameter_optimization](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/hyperparameter_optimization): contains the code used to hyperparameter optimization with 10 repetitions of stratified 10-fold cross-validation. The models evaluated Logistic Regression, Random Forest Classifier,Support Vector Machine, and XGBoost.
* [Sex_specific_risk_markers](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/sex_specific_risk_markers): contains the codes used for obtaining the sex-specific markers for each ACS-subpopulation. 
* [Cox model](https://github.com/blancavazquez/Riskmarkers_AMI/tree/master/cox_model): contain the codes used for computing a multivariable Cox regression model.

## Requirements:
* Python 3.6
* Numpy
* Pandas
* Matplotlib
* xgboost
* statsmodels
* jupiter notebook

You can create a conda environment with all the dependencies using the environment.yml file in this repository.

```
conda env create --file markers_ACS.yml
```

## Citation:

```
@misc{vazquez2021risk,
      title={Risk markers by sex and age group for in-hospital mortality in patients with STEMI or NSTEMI: an approach based on machine learning}, 
      author={Blanca Vazquez and Gibran Fuentes and Fabian Garcia and Gabriela Borrayo and Juan Prohias},
      year={2021},
      eprint={2101.01835},
      archivePrefix={arXiv},
      primaryClass={cs.LG}
}
```

