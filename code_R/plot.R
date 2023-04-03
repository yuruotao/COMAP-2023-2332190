##############################################################################################
# Initialization
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

# Import main for data
#source(file="main.R")
##############################################################################################
# Raw data visualization
raw_figure_dir = paste(working_directory, "/output/figure/raw", sep="")
dir.create(file.path(raw_figure_dir), showWarnings = FALSE)

# Raw data visualization, numerical and numerical
raw_data_num_num_fig <- list()
total_counter = 1
for (counter in 1:ncol(data_file_num)){
  counter_1 = counter + 1
  if (counter_1 < ncol(data_file_num)){
    for (j in counter_1:ncol(data_file_num)){
      temp_data_frame = data.frame(data_file_num[counter],data_file_num[j])
      raw_data_num_num_fig[[total_counter]] <-
        ggplot(temp_data_frame, aes(x = temp_data_frame[,1], y = temp_data_frame[,2])) +
        theme_ipsum_ps() +
        geom_point(color = "#03254c",size=2, shape=20, alpha=1/2) +
        labs(
          #title = "Fuel economy declines",
          #subtitle = "",
          #caption = "",
          #tag = "Figure 1",
          x = colnames(data_file_num)[counter],
          y = colnames(data_file_num)[j],
        )
      #ggsave(paste(raw_figure_dir,"/figure_num_",toString(total_counter),".png",sep = ""), plot = raw_data_num_num_fig[[total_counter]])
      total_counter <- total_counter + 1
    }
  }
}

print("1 done")

# Visualization, categorical and categorical
raw_data_cat_cat_fig <- list()
total_counter = 1
for (counter in 1:ncol(data_file_char_dup)){
  counter_1 = counter + 1
  if (counter_1 <= ncol(data_file_char_dup)){
    for (j in counter_1:ncol(data_file_char_dup)){
      temp_data_frame = data.frame(data_file_char_dup[counter],data_file_char_dup[j])
      raw_data_cat_cat_fig[[total_counter]] <-
        ggplot(temp_data_frame, aes(x = temp_data_frame[,1], y = temp_data_frame[,2])) +
        theme_ipsum_ps() +
        geom_point() +
        geom_count(color = "#1167b1") +
        labs(
          #title = "Fuel economy declines",
          #subtitle = "",
          #caption = "",
          #tag = "Figure 1",
          x = colnames(data_file_char_dup)[counter],
          y = colnames(data_file_char_dup)[j],
        ) + 
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
      #ggsave(paste(raw_figure_dir,"/figure_cat_",toString(total_counter),".png",sep = ""), plot = raw_data_cat_cat_fig[[total_counter]])
      total_counter <- total_counter + 1
    }
  }
}

print("2 done")

# Visualization, numerical and categorical
raw_data_num_cat_fig <- list()
total_counter = 1
for (counter in 1:ncol(data_file_char_dup)){
  if (counter == 1){
  for (j in 1:ncol(data_file_num)){
    temp_data_frame = data.frame(data_file_char_dup[counter],data_file_num[j])
    
    raw_data_num_cat_fig[[total_counter]] <-
      ggplot(temp_data_frame, aes(x = temp_data_frame[,1], y = temp_data_frame[,2])) +
      geom_violin() +
      scale_fill_material_d() +
      theme_ipsum_ps() +
      labs(
        #title = "Fuel economy declines",
        #subtitle = "",
        #caption = "",
        #tag = "Figure 1",
        x = colnames(data_file_char_dup)[counter],
        y = colnames(data_file_num)[j],
      )+ theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
    
    #ggsave(paste(raw_figure_dir,"/figure_num_cat_",toString(total_counter),".png",sep = ""), plot = raw_data_num_cat_fig[[total_counter]])
    total_counter <- total_counter + 1
  }
  }
  
  if (counter == 2){
    for (j in 1:ncol(data_file_num)){
      temp_data_frame = data.frame(data_file_char_dup[counter],data_file_num[j])
      
      raw_data_num_cat_fig[[total_counter]] <-
        ggplot(temp_data_frame, aes(x = temp_data_frame[,1], y = temp_data_frame[,2], fill = geo_region)) +
        geom_violin() +
        scale_fill_material_d() +
        theme_ipsum_ps() +
        labs(
          #title = "Fuel economy declines",
          #subtitle = "",
          #caption = "",
          #tag = "Figure 1",
          x = colnames(data_file_char_dup)[counter],
          y = colnames(data_file_num)[j],
        ) +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
      
      #ggsave(paste(raw_figure_dir,"/figure_num_cat_",toString(total_counter),".png",sep = ""), plot = raw_data_num_cat_fig[[total_counter]])
      total_counter <- total_counter + 1
    }
  }
  
  
}

print("raw done")
##############################################################################################
# Missing data visualization
missing_value_dir = paste(working_directory, "/output/figure/na_value", sep="")
dir.create(file.path(missing_value_dir), showWarnings = FALSE)

for (i in 1:length(missing_value_plot_time_all)){
  #ggsave(paste(missing_value_dir,"/figure_missing_value_",toString(i),".png",sep = ""), plot = missing_value_plot_time_all[[i]])
}

for (i in 1:length(missing_value_plot_time_1_all)){
  #ggsave(paste(missing_value_dir,"/figure_missing_value_1_",toString(i),".png",sep = ""), plot = missing_value_plot_time_1_all[[i]])
}

for (i in 1:length(interpolate_result_all)){
  #ggsave(paste(missing_value_dir,"/figure_missing_interpolate_1_",toString(i),".png",sep = ""), plot = interpolate_result_all[[i]])
}


##############################################################################################
# Correlation visualization
correlation_dir = paste(working_directory, "/output/figure/correlation", sep="")
dir.create(file.path(correlation_dir), showWarnings = FALSE)

cor_num_num_data <- correlation_result_num_num[c(1,2,3)]
cor_num_num_fig = ggplot(data = cor_num_num_data,aes(x=Parameter1, y=Parameter2, fill=r)) + 
  geom_tile(aes(fill = r), colour = "white")+ 
  geom_text(aes(Parameter1, Parameter2, label = round(r, digits = 3)),
            color = "black", size = 2)+
  scale_fill_gradient2(low = "#5aaed7",high = "#ff7a53", mid = "#FFFFFF", midpoint = 0)+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) +
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
#ggsave(paste(correlation_dir,"/cor_num_num",".png",sep = ""), plot = cor_num_num_fig)

cor_cat_cat_data <- correlation_result_cat_cat[c(1,2,3)]
cor_cat_cat_fig = ggplot(data = cor_cat_cat_data ,aes(x=Parameter1, y=Parameter2, fill=r)) +
  
  geom_tile(aes(fill = r), colour = "white")+ 
  scale_fill_gradient2(low = "#5aaed7",high = "#ff7a53", mid = "#FFFFFF", midpoint = 0)+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) +
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
#ggsave(paste(correlation_dir,"/cor_cat_cat",".png",sep = ""), plot = cor_cat_cat_fig)


cor_num_cat_data <- correlation_result_num_cat[c(1,2,3)]
cor_num_cat_fig = ggplot(data = cor_num_cat_data ,aes(x=Parameter1, y=Parameter2, fill=r)) +
  geom_tile(aes(fill = r), colour = "white")+ 
  scale_fill_gradient2(low = "#5aaed7",high = "#ff7a53", mid = "#FFFFFF", midpoint = 0)+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1)) +
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
#ggsave(paste(correlation_dir,"/cor_num_cat",".png",sep = ""), plot = cor_num_cat_fig)

print("cor done")


##############################################################################################
# Interaction network visualization
network_dir = paste(working_directory, "/output/figure/network", sep="")
dir.create(file.path(network_dir), showWarnings = FALSE)

#png(file = paste(network_dir,"/num_num",".png",sep = ""), units='mm', res = 300)
#print(plot(correlation_result_num_num))
#dev.off()

#png(paste(network_dir,"/rank_rank",".png",sep = ""), units='mm', res = 300)
#print(plot(correlation_result_rank_rank))
#dev.off()

#png(paste(network_dir,"/cat_cat",".png",sep = ""), units='mm', res = 300)
#print(plot(correlation_result_cat_cat))
#dev.off()

# This somehow cannot work
#png(paste(network_dir,"/num_rank",".png",sep = ""), units='mm', res = 300)
#print(plot(correlation_result_num_rank))
#dev.off()


#png(paste(network_dir,"/num_cat",".png",sep = ""), units='mm', res = 300)
#print(plot(correlation_result_num_cat))
#dev.off()

#png(paste(network_dir,"/rank_cat",".png",sep = ""), units='mm', res = 300)
#print(plot(correlation_result_rank_cat))
#dev.off()


##############################################################################################
# Cluster visualization
cluster_dir = paste(working_directory, "/output/figure/cluster", sep="")
dir.create(file.path(cluster_dir), showWarnings = FALSE)

# H cluster
#ggsave(paste(cluster_dir,"/HC_elbow",".png",sep = ""), plot = elbow_h_cluster)

#hierarchical_cluster_result <- cut(3, hierarchical_cluster_result)
#hierarchical_cluster_d = as.dendrogram(hierarchical_cluster_result)

#d_data <- dendro_data(hierarchical_cluster_d, type = "rectangle")


#hierarchical_cluster_plot = ggplot(segment(d_data), horiz = TRUE) + 
#  geom_segment(aes(x = x, y = y, xend = xend, yend = yend))+
#  theme_ipsum_ps()
#plot(hierarchical_cluster_plot)
#ggsave(paste(cluster_dir,"/HC_dendrogram",".png",sep = ""), plot = hierarchical_cluster_plot)

#hc_clust_data <- as_tibble(cbind(cluster = as.data.frame(h_cluster_cut), class = data_file$geo_region))
#hc_clust_data[,c(1)] <- sapply(hc_clust_data[,c(1)], as.factor)


#hc_mosaic <- ggplot(data = hc_clust_data) +
#  geom_mosaic(aes(x = product(class, h_cluster_cut), fill = h_cluster_cut)) +
#  theme(panel.background = element_rect(fill='transparent'), #transparent panel bg
#       plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
#        panel.grid.major = element_blank(), #remove major gridlines
#        panel.grid.minor = element_blank(), #remove minor gridlines
#        legend.background = element_rect(fill='transparent'), #transparent legend bg
#        legend.box.background = element_rect(fill='transparent'), #transparent legend panel
#        axis.text.x = element_blank(),
#        axis.ticks.x = element_blank(),
#        axis.title.x = element_blank())
#ggsave(paste(cluster_dir,"/HC_result",".png",sep = ""), plot = hc_mosaic)

#cluster_data_hier = t(cluster_data_h)
#names(attributes(cluster_data_hier)$dimnames) <- c("gep_region","cluster")
#png(paste(cluster_dir,"/HC_result",".png",sep = ""), width = 465, height = 225, units='mm', res = 300)
#mosaic(cluster_data_hier, shade=TRUE, gp = shading_hcl, gp_args = list(interpolate = c(1, 1.8)))
#dev.off()



# Kmed plot
ggsave(paste(cluster_dir,"/kmed_elbow",".png",sep = ""), plot = elbow_kmed_cluster)

kmed_cluster_cut <- kmed_cluster_result["clustering"]
kmed_clust_data <- as_tibble(cbind(cluster = as.data.frame(kmed_cluster_cut), class = data_file$geo_region))
kmed_clust_data[,c(1)] <- sapply(kmed_clust_data[,c(1)], as.factor)

kmed_mosaic <- ggplot(data = kmed_clust_data) +
  geom_mosaic(aes(x = product(geo_region, clustering), fill=clustering)) +
  theme(panel.background = element_rect(fill='transparent'), #transparent panel bg
        plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
        panel.grid.major = element_blank(), #remove major gridlines
        panel.grid.minor = element_blank(), #remove minor gridlines
        legend.background = element_rect(fill='transparent'), #transparent legend bg
        legend.box.background = element_rect(fill='transparent'), #transparent legend panel
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank())
#ggsave(paste(cluster_dir,"/kmed_result_1",".png",sep = ""), plot = kmed_mosaic)


cluster_data_kmd = t(cluster_data_kmed)
names(attributes(cluster_data_kmd)$dimnames) <- c("geo_region","cluster")
#png(paste(cluster_dir,"/kmed_result",".png",sep = ""), width = 465, height = 225, units='mm', res = 300)
#plot(mosaic(cluster_data_kmd, shade=TRUE, gp = shading_hcl, gp_args = list(interpolate = c(1, 1.8))))
#dev.off()

kmed_cluster <- autoplot(kmed_cluster_result, data = data_file_num,  loadings = TRUE, frame = TRUE)
kmed_cluster <- kmed_cluster + theme_ipsum_ps()
ggsave(paste(cluster_dir,"/kmed_plot1",".png",sep = ""), plot = kmed_cluster)

ggsave(paste(cluster_dir,"/kmed_plot2",".png",sep = ""), plot = cluster_fig_kmed)

# Kmeans plot
#ggsave(paste(cluster_dir,"/kmeans_elbow",".png",sep = ""), plot = elbow_kmeans_cluster)

kmeans_cluster_cut <- kmeans_cluster_result["cluster"]
kmeans_clust_data <- as_tibble(cbind(cluster = as.data.frame(kmeans_cluster_cut), class = data_file$class))
kmeans_clust_data[,c(1)] <- sapply(kmeans_clust_data[,c(1)], as.factor)

kmeans_mosaic <- ggplot(data = kmeans_clust_data) +
  geom_mosaic(aes(x = product(class, cluster), fill=cluster)) +
  theme(panel.background = element_rect(fill='transparent'), #transparent panel bg
        plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
        panel.grid.major = element_blank(), #remove major gridlines
        panel.grid.minor = element_blank(), #remove minor gridlines
        legend.background = element_rect(fill='transparent'), #transparent legend bg
        legend.box.background = element_rect(fill='transparent'), #transparent legend panel
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank())
ggsave(paste(cluster_dir,"/kmeans_result_1",".png",sep = ""), plot = kmeans_mosaic)

cluster_data_kms = t(cluster_data_kmeans)
names(attributes(cluster_data_kms)$dimnames) <- c("geo_region","cluster")
png(paste(cluster_dir,"/kmeans_result",".png",sep = ""), width = 465, height = 225, units='mm', res = 300)
mosaic(cluster_data_kms, shade=TRUE, gp = shading_hcl, gp_args = list(interpolate = c(1, 1.8)))
dev.off()

km_cluster <- autoplot(kmeans_cluster_result, data = data_file_num,  loadings = TRUE, frame = TRUE)
km_cluster <- km_cluster + theme_ipsum_ps()
ggsave(paste(cluster_dir,"/kmeans_plot",".png",sep = ""), plot = km_cluster)


# Spectral plot
png(paste(cluster_dir,"/spectral_result",".png",sep = ""), units='mm', res = 300)
plot(data_file_num, col = spectral_cluster_result$cluster)
dev.off()

png(paste(cluster_dir,"/spectral_space",".png",sep = ""), units='mm', res = 300)
plot(spectral_cluster_result$eigenVect[,1:2], col = spectral_cluster_result$cluster, main="spectral space",
     xlim=c(-1,1),ylim=c(-1,1)); points(0,0,pch='+')
dev.off()

png(paste(cluster_dir,"/spectral_eigen_val",".png",sep = ""), units='mm', res = 300)
plot(spectral_cluster_result$eigenVal, main="Laplacian eigenvalues",pch='+')
dev.off()

##############################################################################################
# Weight visualization
weight_dir = paste(working_directory, "/output/figure/weight", sep="")
dir.create(file.path(weight_dir), showWarnings = FALSE)



##############################################################################################
# Model visualization
model_dir = paste(working_directory, "/output/figure/model", sep="")
dir.create(file.path(model_dir), showWarnings = FALSE)

#linear_diagnosis <- gg_diagnose(linear_model)
ggsave(paste(model_dir, "/linear_diagnosis.png",sep = ""), plot = linear_diagnosis)

#logistic_diagnosis <- gg_diagnose(log_reg_model)

poisson_diagnosis <- gg_diagnose(poi_reg_model)
ggsave(paste(model_dir, "/linear_diagnosis.png",sep = ""), plot = poisson_diagnosis)

#GLM_diagnosis <- gg_diagnose(GLM_reg_model)

##############################################################################################
# Refine plot
refine_figure_dir = paste(working_directory, "/output/figure/refine", sep="")
dir.create(file.path(refine_figure_dir), showWarnings = FALSE)

# Radar plot
data_file_num_with_class <- cbind(data_file_num, class = data_file$geo_region)
data_file_num_with_class_standardized <- cbind(standardize(data_file_num), class = data_file$geo_region)
radar_data <- data_file_num_with_class_standardized %>%
  dplyr::group_by(class) %>%
  dplyr::summarise(across(everything(), mean)) %>%
  reshape_longer(c("Length", "LOA", "Beam", "HP", "Year"))

radar_plot <- radar_data %>%
  ggplot(aes(
    x = name,
    y = value,
    color = class,
    group = class,
    fill = class
  )) +
  geom_polygon(linewidth = 1, alpha = 0.1) +
  coord_radar() +
  theme_radar()

ggsave(paste(refine_figure_dir,"/radar1",".png",sep = ""), plot = radar_plot)

# Radar plot 2
data_file_num_with_class_1 <- cbind(data_file_num, class = data_file$MC)
data_file_num_with_class_standardized_1 <- cbind(standardize(data_file_num), class = data_file$MC)
radar_data <- data_file_num_with_class_standardized_1 %>%
  dplyr::group_by(class) %>%
  dplyr::summarise(across(everything(), mean)) %>%
  reshape_longer(c("Length", "LOA", "Beam", "HP", "Year"))

radar_plot <- radar_data %>%
  ggplot(aes(
    x = name,
    y = value,
    color = class,
    group = class,
    fill = class
  )) +
  geom_polygon(linewidth = 1, alpha = 0.1) +
  coord_radar() +
  theme_radar()

ggsave(paste(refine_figure_dir,"/radar2",".png",sep = ""), plot = radar_plot)

# Violin distribution
violin <- ggplot(data_file_num_with_class_1, aes(x = MC, y =Beam , fill =MC )) +
  geom_violindot(fill_dots = "black") +
  #theme_modern(axis.text.angle = 45) +
  theme_ipsum_ps() +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))+
  scale_fill_material_d()

ggsave(paste(refine_figure_dir,"/violin",".png",sep = ""), plot = violin)

# Multiple num-num plot, by class
#mul_plot <- ggplot(data_file_num_with_class, aes(fail_num, xuefen_avg)) +
#  geom_jitter(aes(color=class, fill=class), size=2, shape=21, alpha=1/3) +
  #scale_x_continuous(expand=c(0,0), limits=c(1, 8), breaks=1:8) +
  #scale_y_continuous(expand=c(0,0), limits=c(10, 50)) +
#  scale_y_continuous(guide = guide_axis(n.dodge=2))+
#  scale_color_ipsum() +
#  scale_fill_ipsum() +
#  facet_wrap(~class, scales="free") +
#  theme_ipsum_ps(grid="XY", axis="xy") +
#  theme(legend.position="none")

#ggsave(paste(refine_figure_dir,"/multiple",".png",sep = ""), plot = mul_plot)

##############################################################################################
# Dependencies report
session_info = report(sessionInfo())
writeLines(session_info, paste(working_directory, "/output/report/figure_dependency_info.txt",sep = ""))
