# Initialization with Python

# Create the basic file structure
import os
if not os.path.exists('./data'):
    os.mkdir('./data')
if not os.path.exists('./output'):
    os.mkdir('./output')
    os.mkdir('./output/figure')
    os.mkdir('./output/data')

# The import of csv or xlsx file is usually done with the module named pandas, the parameter 'sheet_name' specifies the sheet to read
# To read csv, use command pd.read_csv()
import pandas as pd
data_file = pd.read_excel("./data/input_data.xlsx", sheet_name="Sheet1")

# Save the data frame file to excel
data_file.to_excel("./output/data/output_data.xlsx", sheet_name="Sheet1")

########################################################################################
# Data preprocessing with Python

# Raw data property analysis with Python
raw_data_summary = data_file.describe()

# Calculate the kurtosis and skewness
raw_data_summary.loc['kurtosis'] = data_file.kurt()
raw_data_summary.loc['skewness'] = data_file.skew()
raw_data_summary.to_excel("./output/data/raw_data_summary.xlsx", sheet_name="Sheet1")

# Delete columns containing NA value
data_file_col = data_file.copy().dropna(axis='columns', inplace=True)
# Delete rows containing NA value
data_file_row = data_file.copy().dropna()

# Data smoothing
# First delete all NA files
data_file = data_file.dropna(how='all')

import impyute as im




# Data normalization
def normalize(df):
    result = df.copy()
    for feature_name in df.columns:
        mean_value = df[feature_name].mean()
        sigma_value = df[feature_name].std()
        result[feature_name] = (df[feature_name] - mean_value)/sigma_value
    return result

def winsorize(df):
    from scipy.stats.mstats import winsorize
    result = df.copy()
    
    def using_mstats(s):
        return winsorize(s, limits=[0.01, 0.01])
    
    result = df.apply(using_mstats, axis=0)
    return result

def center(df):
    result = df.copy()
    for feature_name in df.columns:
        mean_value = df[feature_name].mean()
        result[feature_name] = (df[feature_name] - mean_value)
    return result

normalized_data_file = normalize(data_file)
normalized_data_file1 = winsorize(data_file)
normalized_data_file2 = center(data_file)
normalized_data_file3 = data_file.copy().rank()


########################################################################################
# Correlation analysis







########################################################################################
# Clustering analysis









########################################################################################
# Weight calculation








########################################################################################
# Tendency estimation







