# Interaction network visualization
network_dir = paste(working_directory, "/output/figure/network", sep="")
dir.create(file.path(network_dir), showWarnings = FALSE)

png(paste(network_dir,"/num_num",".png",sep = ""), units='mm', res = 300)
plot(correlation_result_num_num)


png(paste(network_dir,"/rank_rank",".png",sep = ""), units='mm', res = 300)
plot(correlation_result_rank_rank)


png(paste(network_dir,"/cat_cat",".png",sep = ""), units='mm', res = 300)
plot(correlation_result_cat_cat)


png(paste(network_dir,"/num_rank",".png",sep = ""), units='mm', res = 300)
plot(correlation_result_num_rank)


png(paste(network_dir,"/num_cat",".png",sep = ""), units='mm', res = 300)
plot(correlation_result_num_cat)


png(paste(network_dir,"/rank_cat",".png",sep = ""), units='mm', res = 300)
plot(correlation_result_rank_cat)
