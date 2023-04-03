import pandas as pd
import numpy

data_path = "./COMAP_code/output/data/web_data.xlsx"
price_data = pd.read_excel(data_path)
price_data_list = price_data[0].values.tolist()

type_list = []
price = []
year = []
length = []
place = []

for i in price_data_list:
    source = i.split("\n")
    leng = len(source)
    for j in range(leng):
        source[j] = str(source[j])
    
    if leng == 0:
        continue
    elif leng == 1:
        type_list.append(source[0])
        price.append("NA")
        year.append("NA")
        length.append("NA")
        place.append("NA")
    elif leng == 2:
        type_list.append(source[0])
        price.append(str(source[1].lstrip("HKD $ ")))
        year.append("NA")
        length.append("NA")
        place.append("NA")
    elif leng == 3:
        type_list.append(source[0])
        price.append(str(source[1].lstrip("HKD $ ")))
        year.append(str(source[2].lstrip("Year : ")))
        length.append("NA")
        place.append("NA")
    elif leng == 4:
        type_list.append(source[0])
        price.append(str(source[1].lstrip("HKD $ ")))
        year.append(str(source[2].lstrip("Year : ")))
        length.append(str(source[3].lstrip("Length : ").rstrip("m")))
        place.append("NA")
    elif leng == 5:
        type_list.append(source[0])
        price.append(source[1].lstrip("HKD $ "))
        year.append(str(source[2].lstrip("Year : ")))
        length.append(str(source[3].lstrip("Length : ").rstrip("m")))
        place.append(str(source[4]))
df = pd.DataFrame()

df["type_num"] = type_list
df["price"] = price
df["year"] = year
df["length"] = length
df["place"] = place

writer = pd.ExcelWriter("./COMAP_code/output/data/web_output.xlsx", engine='xlsxwriter')
df.to_excel(writer, index=False)
writer.save()