##############################################################################################
library("ggplot2")
library("see")
library("ggraph")
library("correlation")
library("reshape2")
library("ggdendro")
library("tidyr")
library('vcd')
library("qqplotr")
library("report")
library("poorman")
library("ggraph")
library("correlation")
library("dplyr")
library("datawizard")
library("lindia")
library("ggrepel")
library("patchwork")
library("hrbrthemes")
library("svglite")
library("sjPlot")
library("viridis")
library("ggmosaic")
library("ggfortify")
library("lfda")
##############################################################################################
# Initialization with R

# get the current working directory named working_directory, if not, then set the current directory as the working directory
working_directory <- getwd()
if (!is.null(working_directory)) setwd(working_directory)

# Create the file structure
data_dir = "/data"
output_dir = "/output"
output_data_dir = "/output/data"
output_figure_dir = "/output/figure"
output_report_dir = "/output/report"


dir.create(file.path(working_directory, data_dir), showWarnings = FALSE)
dir.create(file.path(working_directory, output_dir), showWarnings = FALSE)
dir.create(file.path(working_directory, output_data_dir), showWarnings = FALSE)
dir.create(file.path(working_directory, output_figure_dir), showWarnings = FALSE)
dir.create(file.path(working_directory, output_report_dir), showWarnings = FALSE)

# Load readxl package for later import of excel files
library("readxl")
# The parameter "sheet_name" specifies the sheet to read
data_file = read_excel(paste(working_directory, "/data/boat_data.xlsx", sep=""), sheet = "merged")

##############################################################################################
# Raw data analysis

# Designate the columns that are character type
num_cols <- list("Year", "Listing_Price","MC")

# Create data frames that contain different types of data and loop through the raw data file
data_file_num = data.frame()

row_number <- nrow(data_file)
for (i in 1:row_number) {
  data_file_char[i, ] <- data_file[i, ]
  data_file_num[i, ] <- data_file[i, ]
  data_file_rank[i, ] <- data_file[i, ]
  data_fil_aov[i, ] <- data_file[i, ]
}

for (col_name in colnames(data_file)) {
  in_list <- FALSE
  append_df <- data_file[, col_name, drop = FALSE]
  if (col_name %in% num_cols){
    append_df <- sapply(append_df, as.numeric)
    data_file_num <- cbind(data_file_num, append_df)
    in_list <- TRUE
  }
}

# Data preprocessing imputation
data_file_num = remove_empty(data_file_num)


library("imputeTS")

if (any(is.na(data_file_num))){
  # Perform interpolation and compare the result
  data_file_time_filled <- list()
  interpolate_result_all <- list()
  
  # Numerical data interpolation
  counter = 1
  interpolate_counter = 1
  for (col_name in colnames(data_file_num)){
    
    if (any(is.na(data_file_num[col_name]))){
      data_file_time_filled[[counter]] <- na_kalman(data_file_num[col_name], model = "auto.arima")
      # Visualization
      interpolate_result_all[[interpolate_counter]] = ggplot_na_imputations(data_file_num[col_name], data_file_time_filled[[counter]])
      interpolate_counter = interpolate_counter + 1
    }
    else {
      data_file_time_filled[[counter]] <- data.frame(data_file_num[col_name])
      #interpolate_result_all[[counter]] = 0
    }
    counter <- counter + 1
  }
  data_file_num = data.frame(data_file_time_filled)
}
print("missing value done")

# Correlation analysis

library("correlation")
library("Hmisc")
library("writexl")

if (ncol(data_file_num) > 1){
  correlation_result_num_num = correlation(data = data_file_num, method ="blomqvist", redundant = TRUE)
  write_xlsx(correlation_result_num_num, paste(working_directory, "/output/data/correlation_num_num.xlsx", sep=""))
}

correlation_dir = paste(working_directory, "/output/figure/correlation", sep="")
dir.create(file.path(correlation_dir), showWarnings = FALSE)

cor_num_num_data <- correlation_result_num_num[c(1,2,3)]
cor_num_num_fig = ggplot(data = cor_num_num_data,aes(x=Parameter1, y=Parameter2, fill=r)) + 
  geom_tile(aes(fill = r), colour = "white")+ 
  geom_text(aes(Parameter1, Parameter2, label = round(r, digits = 3)),
            color = "black", size = 4)+
  scale_fill_gradient2(low = "#5aaed7",high = "#ff7a53", mid = "#FFFFFF", midpoint = 0)+ 
  theme(
    panel.background = element_rect(fill='transparent'), #transparent panel bg
    plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
    panel.grid.major = element_blank(), #remove major gridlines
    panel.grid.minor = element_blank(), #remove minor gridlines
    legend.background = element_rect(fill='transparent'), #transparent legend bg
    legend.box.background = element_rect(fill='transparent'), #transparent legend panel
    #axis.text.x=element_blank(), #remove x axis labels
    axis.ticks.x=element_blank(), #remove x axis ticks
    #axis.text.y=element_blank(),  #remove y axis labels
    axis.ticks.y=element_blank(),  #remove y axis ticks
    axis.title.x=element_blank(),
    axis.title.y=element_blank(),
  )
ggsave(paste(correlation_dir,"/not_hk_cor_num_num",".png",sep = ""), plot = cor_num_num_fig)
plot(cor_num_num_fig)