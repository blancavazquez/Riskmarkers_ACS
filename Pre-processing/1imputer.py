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

This code is used for completing missing values.
A mean strategy is used. Then, we replace missing values using the mean along each column.
"""

import numpy as np
import pandas as pd
from sklearn.impute import SimpleImputer #imputando con la media

file_in = 'nstemi_data.csv'
file_out = 'nstemi_imputed.csv'

def read_data(raw_clinical_note):
    """ Read clinical data """
    data = pd.read_csv(raw_clinical_note, header=0,na_filter=True)
    x = data.drop('icustay_expire_flag', axis = 1) #features
    y = data.icustay_expire_flag #label
    num_cols = data.shape[0]
    return x,y,num_cols

print("===================== Loading data ================================================================")
x, y,num_cols = read_data(file_in)
data = x.replace(" ", np.NaN)
values = data.values
imp_mean = SimpleImputer(missing_values=np.nan, strategy='mean')
imp_mean.fit(values)
transformed_values = imp_mean.transform(values)
print(transformed_values.shape)

x = transformed_values
y = np.array(y)
y = y.reshape((num_cols,1))

datos = np.concatenate((x,y), axis = 1)
""" Saving file"""
np.savetxt(file_out,datos,fmt='%s',delimiter=",")
