setwd("~/MA_2/data/new_benchs/")
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
  phaseCounter <- 0
  phaseCounterFailed <- 0
  between <- FALSE
  #get attributes
  for(i in 1:length(file_data)){
    line <- file_data[i]
    if(between){
      if(is.na(as.numeric(substr(line,nchar(line),nchar(line))))){
        phaseCounterFailed <- phaseCounterFailed + 1
      }
      phaseCounter <- phaseCounter + 1
    }
    
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
    
    if(grepl("INFO END", line, fixed=TRUE)){
      between <- TRUE
      phaseCounter <- 0
      phaseCounterFailed <- 0
    }
    if(grepl("es search canceled!", line, fixed=TRUE)){
      between <- FALSE
      file_attributes[["iteration_count"]][[length(file_attributes[["iteration_count"]])+1]] <- phaseCounter
      file_attributes[["iteration_count_failed"]][[length(file_attributes[["iteration_count_failed"]])+1]] <- phaseCounterFailed
    }
  }
  df <- data.frame(matrix(unlist(file_attributes), nrow=20), stringsAsFactors = F)
  df[,1] <- as.numeric(df[,1])
  df[,2] <- as.numeric(df[,2])
  df[,3] <- as.numeric(df[,3])
  df[,5] <- as.numeric(df[,5])
  df[,6] <- as.numeric(df[,6])
  colnames(df) <- c("memBlocks", "NumberEs", "Time", "TimePhases", "IterationCount", "IterationCountFailed")
  return(df)
}

getTime <- function(df){
  newdf <- data.frame("expand_sec"=numeric(), "contract_sec"=numeric(), 
                      "collect_sec"=numeric(), "datahandling_sec"=numeric(),
                      "expand"=numeric(), "contract"=numeric(), 
                      "collect"=numeric(), "datahandling"=numeric())
  timePhases <- df[,4]
  for(line in timePhases){
    splitLine <- strsplit(line, ",")
    values <- sapply(splitLine[[1]], function(x) tail(strsplit(x,"\\s")[[1]],1))
    values <- sapply(values, function(x) as.numeric(strsplit(x,"\\(")[[1]][1]))
    newdf[nrow(newdf)+1,] <- c(values* df[nrow(newdf)+1,"Time"], values)
  }
  return(cbind(df[,-4],newdf))
}

data_df <- NULL
#parse files
for(file in files){
  data_df <- rbind(data_df, filter_data_from_file(file))
}

data_df_time <- getTime(data_df)

cut_data_df <- data_df_time[data_df_time[,3]<20000,]
cut_data_df <- data_df_time
mean_data_df <- aggregate(cut_data_df[, 2:13], list(cut_data_df$memBlocks), mean)
colnames(mean_data_df) <- c("blocks","mean_es","mean_time", colnames(data_df_time)[4:13])

median_data_df <- aggregate(cut_data_df[, 2:13], list(cut_data_df$memBlocks), median)


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
