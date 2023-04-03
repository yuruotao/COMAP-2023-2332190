# This script merges the selected economic indicators with raw data
import pandas as pd
import numpy as np

def data_update(identifier, data_file, update_file):
    update_df = []
    temp_df = update_file[update_file["Series Name"] == identifier]
    row_num = len(data_file.index)

    for i in range(row_num):
        year = str(data_file.iloc[i]["Year"])
        temp_df['Country Name'] = temp_df['Country Name'].str.lower()
        if str(data_file.iloc[i]["geo region"]) == "USA":
            country = "United States"
        else:
            country = str(data_file.iloc[i]["region"])
            
        if (temp_df['Country Name'] == country.lower()).any():        
            list = temp_df.index[temp_df['Country Name'] == country.lower()].tolist()
            
            value = temp_df.loc[list[0], int(year)]
            update_df.append(value)
        else:
            update_df.append("NA")
        
    # update data file
    data_file[identifier] = update_df
    print(data_file)
    return data_file

def clean(data):
    flag = True
    if flag == True:
        if str(data)[-1] == " ":
            data = str(data).rstrip(" ")
        else:
            flag = False
    
    flag = True
    if flag == True:
        if str(data)[0] == " ":
            data = str(data).lstrip(" ")
        else:
            flag = False
    
    return data

def data_clean(datafile):
    datafile['Make'] = datafile['Make'].apply(clean)
    datafile['Variant'] = datafile['Variant'].apply(clean)
    datafile['region'] = datafile['region'].apply(clean)
    datafile['geo region'] = datafile['geo region'].apply(clean)
    
    return datafile


data_dir = "./COMAP_code/data/"
raw_data_dir = "./COMAP_code/raw_data/"
raw_data_file = "raw_data.xlsx"
update_data_file = "economic_data.xlsx"

mono = pd.read_excel(raw_data_dir + raw_data_file, sheet_name="mono")
cata = pd.read_excel(raw_data_dir + raw_data_file, sheet_name="cata")
update = pd.read_excel(raw_data_dir + update_data_file)

mono = data_clean(mono)
cata = data_clean(cata)

data_update("GNIPPP", mono, update)
data_update("GDPPPP", mono, update)
data_update("GNIgrowth", mono, update)
mono_pd = data_update("GDPgrowth", mono, update)

data_update("GNIPPP", cata, update)
data_update("GDPPPP", cata, update)
data_update("GNIgrowth", cata, update)
cata_pd = data_update("GDPgrowth", cata, update)

writer = pd.ExcelWriter("./COMAP_code/output/data/eco_data.xlsx", engine='xlsxwriter')
mono_pd.to_excel(writer,sheet_name = "mono", index=False)
cata_pd.to_excel(writer,sheet_name = "cata", index=False)
writer.save()