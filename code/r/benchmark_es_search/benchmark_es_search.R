setwd("~/MA_2/data/benchmarks_es_build/")
files <- list.files()
block_count <- sapply(files, function(x) as.integer(substr(x, 1, 4)))

important_attributes <- list("lines aka memory-blocks" = "[0-9]+$",
                             "ngroups:" = "[0-9]+$",
                             "Eviction set total time:" = "\\s[0-9]+\\s",
                             "runtime expand:" = ".+")

filter_data_from_file <- function(file_name){
  file_attributes <- sapply(1:length(important_attributes),function(x)list())
  names(file_attributes) <- names(important_attributes)
  file_data <- readLines(file_name)
  #get attributes
  for(line in file_data){
    for(important_attribute in names(important_attributes)){
      if(grepl(important_attribute, line, fixed=TRUE)){
        #print(important_attribute)
        data <- stringr::str_extract(line,important_attributes[[important_attribute]])
        if(!is.na(as.integer(data))){
          data <- as.integer(data)
        }
        file_attributes[[important_attribute]][[length(file_attributes[[important_attribute]])+1]] <- data
      }
    }
  }
  df <- data.frame(matrix(unlist(file_attributes), nrow=20), stringsAsFactors = F)
  df[,1] <- as.numeric(df[,1])
  df[,2] <- as.numeric(df[,2])
  df[,3] <- as.numeric(df[,3])
  colnames(df) <- c("memBlocks", "NumberEs", "Time", "TimePhases")
  return(df)
}

data_df <- NULL
#parse files
for(file in files){
  data_df <- rbind(data_df, filter_data_from_file(file))
}

cut_data_df <- data_df[data_df[,3]<20000,]
cut_data_df <- data_df
mean_data_df <- aggregate(cut_data_df[, 2:3], list(cut_data_df$memBlocks), mean)
colnames(mean_data_df) <- c("blocks","mean_es","mean_time")

#plot <- 
  ggplot2::ggplot(mean_data_df, ggplot2::aes(blocks, mean_es))+
  ggplot2::geom_point() +
  ggplot2::scale_y_continuous(name="Mittelere Anzahl an Eviction-Sets", 
                              limits=c(3584, 8192),
                              breaks=c(seq(3584,8192,512))) +
  ggplot2::scale_x_continuous(name="Anzahl an Adressen im Pool (x)", 
                              limits=c(2048, 5120), 
                              breaks=c(seq(2048,5120,512)))
  
  
  ggplot2::theme(legend.position = c(0.788, 0.1), legend.title=ggplot2::element_blank())+
  ggplot2::scale_linetype(labels = my_labels) +
  #ggplot2::theme(legend.position="none")
  ggplot2::scale_color_manual(labels = my_labels, values = c("black", "black")) +
  ggplot2::guides(fill=ggplot2::guide_legend(
    keywidth=0.1,
    keyheight=1.1,
    default.unit="inch")
  )