setwd("~/MA_2/data/new_bench_storefor/")
files <- list.files()

important_attributes <- list("time StoreFor:" = "[0-9]+$")

filter_data_from_file <- function(file_name){
  file_attributes <- sapply(1:length(important_attributes),function(x)list())
  names(file_attributes) <- names(important_attributes)
  file_data <- readLines(file_name)
  threadholdSearchForEs <- NA
  time_sum_js <- NA
  time_sum_wasm <- NA
  windowSize <- NA
  rounds <- NA
  
  #get attributes
  for(i in 1:length(file_data)){
    line <- file_data[i]
    
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
    
    if(grepl("rounds", line, fixed=TRUE)){
      rounds <- as.numeric(stringr::str_extract(line,"[0-9]+$"))
    }
    if(grepl("windowSize", line, fixed=TRUE)){
      windowSize <- as.numeric(stringr::str_extract(line,"[0-9]+$"))
    }
    if(grepl("threadholdSearchForEs", line, fixed=TRUE)){
      threadholdSearchForEs <- as.numeric(stringr::str_extract(line,"[0-9]+$"))
    }
    if(grepl("time sum js", line, fixed=TRUE)){
      time_sum_js <- as.numeric(stringr::str_extract(line,"0\\.[0-9]+$"))
    }
    if(grepl("time sum wasm", line, fixed=TRUE)){
      time_sum_wasm <- as.numeric(stringr::str_extract(line,"0\\.[0-9]+$"))
    }

  }
  df <- data.frame(matrix(unlist(file_attributes), nrow=20), stringsAsFactors = F)
  df[,"rounds"] <- rep(rounds)
  df[,"threadholdSearchForEs"] <- rep(threadholdSearchForEs)
  df[,"windowSize"] <- rep(windowSize)
  df[,"time_sum_js"] <- rep(time_sum_js)
  df[,"time_sum_wasm"] <- rep(time_sum_wasm)
  
  colnames(df)[1] <- "Time"
  return(df)
}

data_df <- NULL
#parse files
for(file in files){
  data_df <- rbind(data_df, filter_data_from_file(file))
}

cut_data_df <- data_df[data_df[,3]<20000,]
cut_data_df <- data_df
mean_data_df <- aggregate(cut_data_df[, -c(2:4)], 
                          list(cut_data_df$threadholdSearchForEs,cut_data_df$windowSize,cut_data_df$rounds), 
                          mean)
colnames(mean_data_df)[1:2] <- c("threadholdSearchForEs","windowSize")

median_data_df <- aggregate(cut_data_df[, -c(2:4)], 
                            list(cut_data_df$threadholdSearchForEs,cut_data_df$windowSize,cut_data_df$rounds), 
                            median)


ggplot2::ggplot(mean_data_df, ggplot2::aes(blocks, mean_es))+
  ggplot2::geom_point() +
  ggplot2::scale_y_continuous(name="Mittelere Anzahl an Eviction-Sets", 
                              limits=c(3584, 8192),
                              breaks=c(seq(3584,8192,512))) +
  ggplot2::scale_x_continuous(name="Anzahl an Adressen im Pool (x)", 
                              limits=c(3072, 5120), 
                              breaks=c(seq(2048,5120,512)))



#plot <- 
ggplot2::ggplot(mean_data_df, ggplot2::aes(blocks, mean_es))+
  ggplot2::geom_point() +
  ggplot2::scale_y_continuous(name="Mittelere Anzahl an Eviction-Sets", 
                              limits=c(3584, 8192),
                              breaks=c(seq(3584,8192,512))) +
  ggplot2::scale_x_continuous(name="Anzahl an Adressen im Pool (x)", 
                              limits=c(2048, 5120), 
                              breaks=c(seq(2048,5120,512)))
