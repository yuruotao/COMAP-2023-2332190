# This script crawls the information of boats on https://www.sailboatlistings.com for further analysis
import time
import os
from selenium import webdriver
import numpy as np
import pandas as pd
import math



def info_crawl(start_page, stop_page, crawl_website):
    import pandas as pd
    return_df = pd.DataFrame()
    title = []
    content = []
    
    
    from selenium import webdriver
    from selenium.webdriver.chrome.service import Service as ChromeService
    from webdriver_manager.chrome import ChromeDriverManager
    from selenium.webdriver.support.ui import WebDriverWait
    from selenium.webdriver.common.by import By
    from selenium.webdriver.support import expected_conditions as EC
    
    if not os.path.exists('./COMAP_code/web_driver'):
        os.mkdir('./COMAP_code/web_driver')
        driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager(version="110.0.5481.77").install()))
    driver_path = './COMAP_code/web_driver/chromedriver.exe'
    
    options = webdriver.ChromeOptions()
    options.add_experimental_option('excludeSwitches', ['enable-logging'])
    options.add_experimental_option("prefs", {"profile.managed_default_content_settings.images": 2})
    options.use_chromium = True

    # start crawling
    for l in range(start_page-1, stop_page-1):
        driver = webdriver.Chrome(executable_path = driver_path, options=options)
        website = crawl_website[l]
    
        driver.get(website)
        row_num = len(driver.find_elements_by_xpath("/html/body/center/table[1]/tbody/tr/td[1]/table/tbody/tr"))
        
        time.sleep(4)
        for i in range(row_num):
            # get element 
            all_content = driver.find_element_by_xpath('/html/body/center/table[1]/tbody/tr/td[1]/table/tbody/tr['+ str(i+1) + ']')
            
            content.append(all_content.text)
        
        print(content)
        print("website " + str(l) + " finish")
        driver.close()
        
    return_df["content"] = content
    
    return return_df


main_website_base = "https://www.sailboatlistings.com/cgi-bin/saildata/db.cgi?db=default&uid=default&view_records=1&ID=*&sb=date&so=descend&nh="

# create directory
if not os.path.exists('./COMAP_code/output/data'):
    os.mkdir('./COMAP_code/output/data')    
data_dir = "./COMAP_code/output/data/"
raw_data_dir = "./COMAP_code/raw_data/"

# crawler website list create
website_list = []
item_num = 13694
item_per_page = 65
page_num = math.floor(item_num/item_per_page) + 1

for i in range(math.floor(item_num/item_per_page)):
    website_list.append(main_website_base + str(i+1))

#info_df = info_crawl(1,page_num,website_list)

#writer = pd.ExcelWriter(data_dir + "web_data2.xlsx", engine='xlsxwriter')
#info_df.to_excel(writer, index=False)
#writer.save()

website_data = pd.read_excel(data_dir + "web_data2.xlsx")
website_data_list = website_data.values.tolist()
sailboat_name = []
add_date = []
year = []
price = []
boat_df = pd.DataFrame()

for iter in range(len(website_data_list)):
    temp_string = website_data_list[iter][0]
    temp_list = temp_string.split("\n")

    sailboat_name.append(temp_list[0])
    add_date.append(temp_list[-1])
    temp_list = temp_list[1:-1]  

    flag_year = False
    flag_ask = False
    
    if len(temp_list) > 0:
        for m in range(len(temp_list)):
            if "Year" in temp_list[m]:
                flag_year = True
                year_num = m
            if "Asking" in temp_list[m]:
                flag_ask = True
                ask_num = m
    if flag_year == True:
        year.append(str(temp_list[year_num].lstrip("Year: ")))
    else:
        year.append("")
    
    if flag_ask == True:
        price.append(str(temp_list[ask_num].lstrip("Asking: $")))
    else:
        price.append("")
        


            
                
boat_df["Variant"] = sailboat_name
boat_df["Year"] = year
boat_df["Listing Price"] = price

writer = pd.ExcelWriter(data_dir + "boat_data2.xlsx", engine='xlsxwriter')
boat_df.to_excel(writer, index=False)
writer.save()