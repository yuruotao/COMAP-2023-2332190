# This script merges the selected economic indicators with raw data
import pandas as pd
import numpy as np

def data_update(data_file, update_file, sheet):
    LOA_df = []
    Beam_df = []
    HP_df = []
    SA_Disp_df = []
    Ball_Disp_df = []
    Disp_Len_df = []
    CR_df = []
    CSF_df = []
    MC_df = []
    row_num = len(data_file.index)
    
    if sheet == "mono":
        app_num = 1
    elif sheet == "cata":
        app_num = 0

    for i in range(row_num):
        variant = str(data_file.iloc[i]["Variant"])
            
        if (update_file['Variant'] == variant).any():        
            list = update_file.index[update_file['Variant'] == variant].tolist()
            
            LOA_df.append(str(update_file.iloc[list[0]]["LOA"]))
            Beam_df.append(str(update_file.iloc[list[0]]["Beam"]))
            HP_df.append(str(update_file.iloc[list[0]]["HP"]))
            SA_Disp_df.append(str(update_file.iloc[list[0]]["SA/Disp"]))
            Ball_Disp_df.append(str(update_file.iloc[list[0]]["Ball/Disp"]))
            Disp_Len_df.append(str(update_file.iloc[list[0]]["Disp/Len"]))
            CR_df.append(str(update_file.iloc[list[0]]["CR"]))
            CSF_df.append(str(update_file.iloc[list[0]]["CSF"]))
            MC_df.append(app_num)
        else:
            LOA_df.append("NA")
            Beam_df.append("NA")
            HP_df.append("NA")
            SA_Disp_df.append("NA")
            Ball_Disp_df.append("NA")
            Disp_Len_df.append("NA")
            CR_df.append("NA")
            CSF_df.append("NA")
            MC_df.append(app_num)
        
    # update data file
    data_file["LOA"] = LOA_df
    data_file["Beam"] = Beam_df
    data_file["HP"] = HP_df
    data_file["SA/Disp"] = SA_Disp_df
    data_file["Ball/Disp"] = Ball_Disp_df
    data_file["Disp/Len"] = Disp_Len_df
    data_file["CR"] = CR_df
    data_file["CSF"] = CSF_df
    data_file["MC"] = MC_df
    
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
    
    return str(data)

def data_clean(datafile):
    datafile['Variant'] = datafile['Variant'].apply(clean)
    
    return datafile

data_dir = "./COMAP_code/output/data/"
raw_data_dir = "./COMAP_code/raw_data/"
raw_data_file = "raw_data.xlsx"
update_data_file = "boat_data.xlsx"
eco_data = "eco_data.xlsx"

mono = pd.read_excel(data_dir + eco_data, sheet_name="mono")
cata = pd.read_excel(data_dir + eco_data, sheet_name="cata")
update_mono = data_clean(pd.read_excel(raw_data_dir + update_data_file, sheet_name="mono"))
update_cata = data_clean(pd.read_excel(raw_data_dir + update_data_file, sheet_name="cata"))

mono_pd = data_update(mono, update_mono, "mono")
cata_pd = data_update(cata, update_cata, "cata")
merged_pd = mono_pd.append(cata_pd, ignore_index = True)

writer = pd.ExcelWriter("./COMAP_code/output/data/boat_data.xlsx", engine='xlsxwriter')
mono_pd.to_excel(writer, sheet_name = "mono", index=False)
cata_pd.to_excel(writer, sheet_name = "cata", index=False)
merged_pd.to_excel(writer, sheet_name = "merged", index=False)
writer.save()
