setwd("~/MA_2/data/benchmarks_es_build/")
files <- list.files()
block_count <- sapply(files, function(x) as.integer(substr(x, 1, 4)))

file_name <- files[1]

important_attributes <- list("lines aka memory-blocks" = "[0-9]+$", 
                          "ngroups:" = "[0-9]+$", 
                          "Eviction set total time:" = "[0-9]+\\ssec", 
                          "runtime expand:" = "")

file_attributes <- NULL

filter_data_from_file <- function(file_name){
  file_attributes <- sapply(1:length(important_attributes),function(x)list())
  names(file_attributes) <- important_attributes
  file_data <- readLines(file_name)
  #get attributes
  for(line in file_data){
    for(important_attribute in names(important_attributes)){
      if(grepl(important_attribute, line, fixed=TRUE)){
        #print(important_attribute)
        file_attributes[[important_attribute]][[length(file_attributes[[important_attribute]])+1]] <- line
      }
    }
  }
}