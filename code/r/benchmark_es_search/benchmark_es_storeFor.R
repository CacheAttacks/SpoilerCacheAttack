setwd("~/MA_2/data/new_storefor_new_es_algo/half_inc/")

setwd("~/MA_2/data/new_storefor_new_es_algo/normal/")
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
  failed <- 0
  
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
    
    if(grepl("---------------FAILED----", line, fixed=TRUE)){
      failed <- failed +  1
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
  df <- data.frame(matrix(unlist(file_attributes), nrow=length(file_attributes[[1]])), stringsAsFactors = F)
  df[,"rounds"] <- rep(rounds)
  df[,"threadholdSearchForEs"] <- rep(threadholdSearchForEs)
  df[,"windowSize"] <- rep(windowSize)
  df[,"time_sum_js"] <- rep(time_sum_js)
  df[,"time_sum_wasm"] <- rep(time_sum_wasm)
  
  colnames(df)[1] <- "Time"
  print(paste0("failed:",failed))
  return(df)
}

data_df <- NULL
#parse files
for(file in files){
  data_df <- rbind(data_df, filter_data_from_file(file))
}

cut_data_df <- data_df

freq <- plyr::count(cut_data_df, c('threadholdSearchForEs','windowSize','rounds'))[,"freq"]/60

mean_data_df <- aggregate(cut_data_df[, -c(2:4)], 
                          list(cut_data_df$threadholdSearchForEs,cut_data_df$windowSize,cut_data_df$rounds), 
                          mean)
mean_data_df <- cbind(mean_data_df, freq)
colnames(mean_data_df)[1:3] <- c("threadholdSearchForEs","windowSize","Rounds")

median_data_df <- aggregate(cut_data_df[, -c(2:4)], 
                            list(cut_data_df$threadholdSearchForEs,cut_data_df$windowSize,cut_data_df$rounds), 
                            median)
median_data_df <- cbind(median_data_df, freq)


mean_data_df[,"time_sum_js"] <- sapply(mean_data_df[,"time_sum_js"], function(x) paste0(round(x*100), "\\%"))
mean_data_df[,"time_sum_wasm"] <- sapply(mean_data_df[,"time_sum_wasm"], function(x) paste0(round(x*100), "\\%"))
mean_data_df[,"freq"] <- sapply(mean_data_df[,"freq"], function(x) paste0(round(x*100), "\\%"))
mean_data_df[,"Time"] <- sapply(mean_data_df[,"Time"], function(x) paste0(round(x), "s"))

print_latex_table <- function(table){
  cat(Reduce(function(x,y){paste0(x, "\\\\", y)}, 
             apply(table, 1 , function(x) 
               Reduce(function(x,y){paste0(x, " & ", y)}, x[-1], init = x[1]))))
}

print_latex_table(mean_data_df)

















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
