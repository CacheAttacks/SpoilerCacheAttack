visualize_times <- function(file_name){
  #x-axis eviction sets, y-axis samples
  tbl <- read.table(paste0("/tmp/", file_name))
  tbl <- tbl[,1:256]
  tbl_melt <- reshape2::melt(tbl, )
  tbl_melt[["sample"]] <- rep(1:nrow(tbl), ncol(tbl))
  colnames(tbl_melt)[1] <- "es"
  #cap at 3500
  max_value <- 1000
  tbl_melt[tbl_melt$value>max_value,"value"] <- max_value
  
  ggplot2::ggplot(tbl_melt, ggplot2::aes(x=sample,y=es)) + 
    ggplot2::geom_tile(ggplot2::aes(fill = value)) +
    ggplot2::scale_fill_gradient(low = "white", high = "steelblue")
}

visualize_times("test.txt")
visualize_times("test2.txt")
visualize_times("test3.txt")
visualize_times("test4.txt")
visualize_times("test5.txt")
visualize_times("test6.txt")
visualize_times("test7.txt")


setwd("~/MA_2/master-moritz_krebbel-drive_by_cache_attacks//code/r/prime_probe/")
plumber::plumb("plumber.R")$run(port=8000)

sapply(strtoi(c("0x43c","0x617")), function(x) floor(x/64))



tbl_melt <- reshape2::melt(tbl)
tbl_melt[["sample"]] <- rep(1:nrow(tbl), ncol(tbl))
colnames(tbl_melt)[1] <- "es"
#cap at 3500
max_value <- 2000
tbl_melt[tbl_melt$value>max_value,"value"] <- max_value

plot <- ggplot2::ggplot(tbl_melt, ggplot2::aes(x=sample,y=es)) + 
  ggplot2::geom_tile(ggplot2::aes(fill = value)) +
  ggplot2::scale_fill_gradient(low = "white", high = "steelblue")



m <- t(sapply(0:1023,function(x){ as.integer(intToBits(x))}))
m2 <- apply(m, 1, function(x) Reduce(function(x,y) paste0(x,y), rev(as.character(x))[23:32]))
bitstr <- Reduce(function(x,y) paste0(x,y), m2)

set.seed(42)
bitstr2 <- Reduce(paste0, sample(c(0,1), 1000, replace = T))
write(bitstr2, file = "randbitstr.txt")
