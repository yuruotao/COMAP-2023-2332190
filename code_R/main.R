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
data_file = read_excel(paste(working_directory, "/data/boat_data.xlsx", sep=""), sheet="merged")
predictor_data_file = read_excel(paste(working_directory, "/data/predictor.xlsx", sep=""), sheet="mono")

##############################################################################################
# Raw data analysis

# Designate the columns that are character type
num_cols <- list("Year","Listing_Price", "GNIPPP", "GDPPPP", "GNIgrowth", "GDPgrowth", "LOA", "Beam", "HP", "SA/Disp", "Ball/Disp", "Disp/Len", "CSF", "MC")
rank_cols <- list("")



# Create data frames that contain different types of data and loop through the raw data file
data_file_char = data.frame()
data_file_num = data.frame()
data_file_rank = data.frame()
data_fil_aov = data.frame()

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
  if (col_name %in% char_cols){
    data_file_char <- cbind(data_file_char, append_df)
    in_list <- TRUE
  }
  if (col_name %in% rank_cols){
    append_df <- sapply(append_df, as.numeric)
    data_file_rank <- cbind(data_file_rank, append_df)
    in_list <- TRUE
  }
  if (col_name %in% num_cols){
    append_df <- sapply(append_df, as.numeric)
    data_file_num <- cbind(data_file_num, append_df)
    in_list <- TRUE
  }
}

data_file_char_d <- data_file_char

# Raw data analysis
library("datawizard")
raw_data_summary = describe_distribution(data_file_num)
# Save to excel(raw data analysis)
library("writexl")
write_xlsx(raw_data_summary, paste(working_directory, "/output/data/raw_data_analysis.xlsx", sep=""))
##############################################################################################
# Data preprocessing

# Data preprocessing deletion, column
data_file_num_col <- data_file_num[, colSums(is.na(data_file_num)) == 0]
# Data preprocessing deletion, row
data_file_num_row <- na.omit(data_file_num)


# Data preprocessing imputation
data_file_num = remove_empty(data_file_num)
data_file_char = remove_empty(data_file_char)

# Delete columns with same value for cat data
is_same_column <- function(col) {
  length(unique(col)) == 1
}
remove_cols <- apply(data_file_char, 2, is_same_column)
data_file_char <- data_file_char[, !remove_cols]
data_file_char_dup = data_file_char

# Dummy variable for categorical data
library("caret")

formula <- as.formula("~ Make")
my_dummy_vars <- dummyVars(formula, data = data_file_char)
dummy_df_1 <- predict(my_dummy_vars, newdata = data_file_char)
dummy_df_1 <- replace(dummy_df_1, is.na(dummy_df_1), 0)
data_file_char <- subset(data_file_char, select = -c(`Make`))
data_file_char <- cbind(data_file_char, dummy_df_1)
dummy_df_1 <- data.frame(dummy_df_1)


formula <- as.formula("~ geo_region")
my_dummy_vars <- dummyVars(formula, data = data_file_char)
dummy_df_2 <- predict(my_dummy_vars, newdata = data_file_char)
dummy_df_2 <- replace(dummy_df_2, is.na(dummy_df_2), 0)
data_file_char <- subset(data_file_char, select = -c(`geo_region`))
data_file_char <- cbind(data_file_char, dummy_df_2)
dummy_df_2 <- data.frame(dummy_df_2)

# Time series imputation
library("imputeTS")

# Plot the missing data information
missing_value_plot_time_all = list()
missing_value_plot_time_1_all = list()
# Plot the information on missing data itself
missing_value_plot_time_2_all = list()

counter = 1
for (col_name in colnames(data_file_num)){
  if (any(is.na(data_file_num[col_name]))){
  #missing_value_plot_time_all[[counter]] = ggplot_na_distribution(x = data_file_num[col_name], theme =  theme_ipsum_ps())
  #missing_value_plot_time_1_all[[counter]] = ggplot_na_distribution2(data_file_num[col_name], theme =  theme_ipsum_ps())
  #missing_value_plot_time_2_all[[counter]] = ggplot_na_gapsize(data_file_num[col_name], theme =  theme_ipsum_ps())
  counter <- counter + 1
  }
}


if (any(is.na(data_file_num))){
# Perform interpolation and compare the result
#data_file_time_filled <- list()
#interpolate_result_all <- list()

# Numerical data interpolation
counter = 1
interpolate_counter = 1
for (col_name in colnames(data_file_num)){
  
  if (any(is.na(data_file_num[col_name]))){
    #data_file_time_filled[[counter]] <- na_kalman(data_file_num[col_name], model = "auto.arima")
    # Visualization
    #interpolate_result_all[[interpolate_counter]] = ggplot_na_imputations(data_file_num[col_name], data_file_time_filled[[counter]])
    interpolate_counter = interpolate_counter + 1
  }
  else {
    #data_file_time_filled[[counter]] <- data.frame(data_file_num[col_name])
    #interpolate_result_all[[counter]] = 0
  }
  counter <- counter + 1
}
data_file_num = data.frame(data_file_time_filled)
}
print("missing value done")


##############################################################################################
# Data normalization(numerical)

library("datawizard")
#normalized_data_file = standardize(data_file_num)
#normalized_data_file1 = winsorize(data_file_num)
#normalized_data_file2 = center(data_file_num)
#normalized_data_file3 = ranktransform(data_file_num[, c(3)])

##############################################################################################
# Aov analysis
library("report")
library("dplyr")

data_file_aov <- cbind(data_file_num, data_file_char_d)

aov_report = aov(MC ~ Variant, data = data_file) %>% report()
aov_report_1 = aov(MC ~ Listing_Price, data = data_file_aov) %>% report()
aov_report_2 = aov(Listing_Price ~ geo_region, data = data_file_aov) %>% report()
#aov_report_3 = aov(Variant ~ geo_region, data = data_file_aov) %>% report()
writeLines(aov_report, paste(working_directory, "/output/report/aov.txt",sep = ""))
writeLines(aov_report_1, paste(working_directory, "/output/report/aov1.txt",sep = ""))
writeLines(aov_report_2, paste(working_directory, "/output/report/aov2.txt",sep = ""))
#writeLines(aov_report_3, paste(working_directory, "/output/report/aov3.txt",sep = ""))
print("aov done")
##############################################################################################
# Correlation analysis

library("correlation")
library("Hmisc")
library("writexl")

if (ncol(data_file_num) > 1){
  #correlation_result_num_num = correlation(data = data_file_num, method ="blomqvist", redundant = TRUE)
  #write_xlsx(correlation_result_num_num, paste(working_directory, "/output/data/correlation_num_num.xlsx", sep=""))
}

print("num num done")

if (ncol(data_file_rank) > 1){
  #correlation_result_rank_rank = correlation(data = data_file_rank, method = "gaussian", ranktransform =  TRUE, redundant = TRUE)
  #write_xlsx(correlation_result_rank_rank, paste(working_directory, "/output/data/correlation_rank_rank.xlsx", sep=""))
}

print("rank rank done")

if (ncol(data_file_char) > 1){
  #correlation_result_cat_cat = correlation(data = dummy_df_1, data2 = dummy_df_2,method = "gamma", redundant = TRUE)
  #write_xlsx(correlation_result_cat_cat, paste(working_directory, "/output/data/correlation_cat_cat.xlsx", sep=""))
}

print("cat cat done")

if (ncol(data_file_rank) > 1 && ncol(data_file_num) > 1){
  #correlation_result_num_rank = correlation(data = data_file_num, data2 = data_file_rank, method = "spearman", redundant = TRUE)
  #write_xlsx(correlation_result_num_rank, paste(working_directory, "/output/data/correlation_num_rank.xlsx", sep=""))
}

if (ncol(data_file_char) > 1 && ncol(data_file_num) > 1){
  #correlation_result_num_cat = correlation(data = data_file_num, data2 = data_file_char, method = "gamma", redundant = TRUE)
  #write_xlsx(correlation_result_num_cat, paste(working_directory, "/output/data/correlation_num_cat.xlsx", sep=""))
}

print("num cat done")

if (ncol(data_file_rank) > 1 && ncol(data_file_char) > 1){
  #correlation_result_rank_cat = correlation(data = data_file_char, data2 = data_file_rank, method = "gamma", redundant = TRUE)
  #write_xlsx(correlation_result_rank_cat, paste(working_directory, "/output/data/correlation_rank_cat.xlsx", sep=""))
}

print("correlation done")
##############################################################################################
# Clustering analysis
# Distance selection, convert data frame to matrix

library("factoextra")
library("ggplot2")
#data_file_num_mat = dist(as.matrix(data_file_num), method = "euclidean")

# Hierarchical clustering with optimization goal selection
# Elbow method for h clustering
#elbow_h_cluster = fviz_nbclust(data_file_num, 
#             FUNcluster = hcut,
#             method = "wss",
#             k.max = 12
#) + labs(title="Elbow Method for Hierarchical Clustering") +
#  theme_ipsum_ps() +
#  geom_vline(xintercept = 5,
#             linetype = 2)
#plot(elbow_h_cluster)

#hierarchical_cluster_result <- hclust(data_file_num_mat, method="single")
#h_cluster_cut <- cutree(hierarchical_cluster_result, k=5)
#cluster_data_h = table(h_cluster_cut, data_file$`geo_region`)
#plot(h_cluster_cut)

# Partitional Clustering with optimization goal selection
# Elbow method for kmeans
#elbow_kmeans_cluster = fviz_nbclust(data_file_num,
#             FUNcluster = kmeans,
#             method = "wss",
#             k.max = 12
#) +
#  theme_ipsum_ps() +
#  labs(title="Elbow Method for K-Means") +
#  geom_vline(xintercept = 5,
#             linetype = 2)
#plot(elbow_kmeans_cluster)


#kmeans_cluster_result <- kmeans(data_file_num, centers=5)
#cluster_data_kmeans = table(kmeans_cluster_result[["cluster"]], data_file$`geo_region`)

#cluster_fig_kmeans = fviz_cluster(kmeans_cluster_result,
#             data = data_file_num_mat)


# Elbow method for kmedoid
library("cluster")
#elbow_kmed_cluster = fviz_nbclust(data_file_num, 
#             FUNcluster = cluster::pam,
#             method = "wss",
#             k.max = 12
#) +
#  theme_ipsum_ps() +
#  labs(title="Elbow Method for K-Medoid") +
#  geom_vline(xintercept = 5,
#             linetype = 2)

#kmed_cluster_result <- pam(data_file_num, k=5)
#cluster_data_kmed = table(kmed_cluster_result$cluster, data_file$`geo_region`)
#cluster_fig_kmed = fviz_cluster(kmed_cluster_result,
#                                  data = data_file_num_mat)

#cluster_data_kmd = t(cluster_data_kmed)

print("kmedoid done")



# Spectral clustering
library('sClust')
# Calculate the gram matrix
cluster_num <- 5
gram_matrix_gaussian <- compute.similarity.ZP(t(scale(data_file_num)))
spectral_cluster_result <- VonLuxburgSC(gram_matrix_gaussian, K=cluster_num, flagDiagZero=TRUE, verbose=FALSE)

# Divide the indicators into clusters
cluster_name = spectral_cluster_result$cluster
cluster_total_num = max(cluster_name)
df_list <- list()

for (i in 1:cluster_total_num){
  temp_df <- data.frame()
  for (k in 1:nrow(data_file_num)) {
    temp_df[k, ] <- data_file_num[k, ]
  }
  
  for(j in 1:length(cluster_name)){
    if(i == cluster_name[j]){
      append_df <- data_file_num[, j, drop = FALSE]
      temp_df <- cbind(temp_df, append_df)
    }
  }
  df_list[[i]] <- temp_df
}
each_cluster_length_num <- list()
cluster_list <- list()
for (i in 1:cluster_total_num){
  cluster_list[[i]] <- df_list[[i]]
  assign(paste("cluster_", toString(i),sep = ""), df_list[[i]])
  each_cluster_length_num[i] <- length(df_list[[i]])
}
print("cluster done")
##############################################################################################
# Weight analysis
entropy_w_result <- list()
CRITIC_w_result <- list()
coe_of_var <- list()

# The variable data_file_num_weighted is a data frame containing the weighted indicators
row_number <- nrow(data_file_num)
data_file_num_weighted <- data.frame()

for (i in 1:row_number) {
  data_file_num_weighted[i, ] <- data_file_num[i, ]
  temp_df[i, ] <- data_file_num[i, ]
}

for (i in 1:cluster_total_num){
  if (each_cluster_length_num[i] > 1){
    temp_list <- list()
    temp_df <- data.frame()
    for (m in 1:row_number) {
      temp_df[m, ] <- data_file_num[m, ]
    }
    
    # Entropy weight method
    library("creditmodel")
    temp_list <- entropy_weight(cluster_list[[i]])
    for (j in 1: length(temp_list)/2){
      temp_list[[2]][j] <- temp_list[[2]][j] + temp_list[[2]][2*j]
    }
    entropy_w_result[[i]] <- temp_list
    
    # Formulate the weighted data frame
    for (k in 1:length(temp_list)/2){
      temp_df <- cbind(temp_df, entropy_w_result[[i]][[2]][k] * cluster_list[[i]][k])
    }
    data_file_num_weighted[i] <- rowSums(temp_df)
  } else {
    data_file_num_weighted[i] <- cluster_list[[i]]
  }
}
write_xlsx(data_file_num_weighted, paste(working_directory, "/output/data/data_file_weighted.xlsx", sep=""))

print("weight done")
##############################################################################################
# Tendency estimation
library("performance")
library("qqplotr")
library("report")
predictor_data_file <- as.data.frame(predictor_data_file)
merged_data <- merge(data_file_num_weighted, predictor_data_file)

# Linear regression
#linear_model <- lm(Listing_Price ~ V1 + V2 + V3 + V4 + V5, data = merged_data)
#predict(linear_model, predict_data)
#linear_model_summary = summary(linear_model)
#linear_model_check = check_model(linear_model)

# Create model report
#linear_reg_report = report(linear_model)
#writeLines(linear_reg_report, paste(working_directory, "/output/report/linear_regression.txt",sep = ""))
#write_xlsx(model_performance(linear_model), paste(working_directory, "/output/data/linear_regression.xlsx", sep=""))

print("linear done")

# Logistic regression
#log_reg_model <- glm(Listing_Price ~ V1 + V2 + V3 + V4 + V5, data = merged_data, family = binomial(link = "logit"))
#predict(log_reg_model, newdata = test_df, type = "response")
#logistic_model_sum = summary(log_reg_model)
#logistic_reg_report = report(log_reg_model)
#writeLines(logistic_reg_report, paste(working_directory, "/output/report/logistic_regression.txt",sep = ""))
#write_xlsx(model_performance(log_reg_model), paste(working_directory, "/output/data/logistic_regression.xlsx", sep=""))

print("log done")

# Poisson regression
poi_reg_model <- glm(Listing_Price ~ V1 + V2 + V3 + V4 + V5, data = merged_data, family = "poisson")
#predict(poi_reg_model, newdata = test_df, type = "response")
poisson_model_sum = summary(poi_reg_model)
poisson_reg_report = report(poi_reg_model)
writeLines(poisson_reg_report, paste(working_directory, "/output/report/poisson_regression.txt",sep = ""))
write_xlsx(model_performance(poi_reg_model), paste(working_directory, "/output/data/poisson_regression.xlsx", sep=""))

print("pois done")

# GLM regression
GLM_reg_model <- glm(Listing_Price ~ V1 + V2 + V3 + V4 + V5, data = merged_data, family = "gaussian")
#predict(poi_reg_model, newdata = test_df, type = "response")
GLM_model_sum = summary(GLM_reg_model)
GLM_reg_report = report(GLM_reg_model)
writeLines(GLM_reg_report, paste(working_directory, "/output/report/GLM_regression.txt",sep = ""))
write_xlsx(model_performance(GLM_reg_model), paste(working_directory, "/output/data/GLM_regression.xlsx", sep=""))

print("glm done")

library("see")
performance_compare = compare_performance(linear_model,log_reg_model, poi_reg_model ,GLM_reg_model, rank = TRUE)
write_xlsx(performance_compare, paste(working_directory, "/output/data/model_performance_compare.xlsx", sep=""))
print("regression done")
##############################################################################################
# Dependencies report
session_info = report(sessionInfo())
writeLines(session_info, paste(working_directory, "/output/report/session_info.txt",sep = ""))

