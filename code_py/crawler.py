# This script crawls the information of boats on https://sailboatdata.com for further analysis
import time
import os
from selenium import webdriver
import numpy as np
import pandas as pd

# debug done
def excel_read_to_list(file_path, sheet_name, column_name):
    import pandas as pd
    df = pd.read_excel(file_path, sheet_name=sheet_name)
    mylist = df[column_name].tolist()
    output_list = []
    
    # Delete the blank spaces
    for i in range(1, len(mylist)):
        mylist[i] = str(mylist[i])
    
    
    for i in mylist:
        flag = True
        if flag == True:
            if str(i)[-1] == " ":
                i = str(i).rstrip(" ")
            else:
                flag = False

    for i in mylist:
        if i in output_list:
            continue
        else:
            output_list.append(i)
    return output_list

def scroll_down(self):
    """A method for scrolling the page."""

    # Get scroll height.
    last_height = self.execute_script("return document.body.scrollHeight")

    while True:

        # Scroll down to the bottom.
        self.execute_script("window.scrollTo(0, document.body.scrollHeight);")

        # Wait to load the page.
        time.sleep(2)

        # Calculate new scroll height and compare with last scroll height.
        new_height = self.execute_script("return document.body.scrollHeight")

        if new_height == last_height:

            break

        last_height = new_height

def info_crawl(crawl_website):
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
    
    driver = webdriver.Chrome(executable_path = driver_path, options=options)

    # start crawling
    for i in crawl_website:
        website = str(i)
        temp = []
        driver.get(website)
        scroll_down(driver)

        # get element
        elements = WebDriverWait(driver, 5).until(
            EC.presence_of_all_elements_located((By.CLASS_NAME, 'info'))
        )
        
        
        for item in elements:
            temp.append(item.text)

        driver.close()
    
    return temp

main_website_base = "https://sailboatdata.com/sailboat/"
    
# create directory
if not os.path.exists('./COMAP_code/output/data'):
    os.mkdir('./COMAP_code/output/data')
    
data_dir = "./COMAP_code/output/data/"
raw_data_dir = "./COMAP_code/raw_data/"

# create a list of boats
boat_list_mono = excel_read_to_list(raw_data_dir + "raw_data.xlsx", "mono","Variant")
boat_list_cata = excel_read_to_list(raw_data_dir + "raw_data.xlsx", "cata","Variant")

# output the list
boat_list_mono_df = pd.DataFrame(boat_list_mono)
boat_list_cata_df = pd.DataFrame(boat_list_cata)

boat_list_mono_df.to_excel(data_dir + "boat_name1.xlsx", sheet_name="mono")
boat_list_cata_df.to_excel(data_dir + "boat_name.xlsx", sheet_name="cata")

# crawler website list create
website_list_mono = []
website_list_cata = []

for i in boat_list_mono:
    if " " in str(i) == True:
        replaced = str(i).split(" ").join('-')
    else:
        replaced = str(i)
    website_list_mono.append(main_website_base + replaced)
    
for i in boat_list_cata:
    if " " in str(i) == True:
        replaced = str(i).split(" ").join('-')
    else:
        replaced = str(i)
    website_list_cata.append(main_website_base + replaced)


info_list = info_crawl(["https://hongkongboats.hk/boats-for-sale/"])

info_df = pd.DataFrame(info_list)

writer = pd.ExcelWriter("./COMAP_code/output/data/web_data.xlsx", engine='xlsxwriter')
info_df.to_excel(writer, index=False)
writer.save()