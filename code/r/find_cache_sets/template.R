setwd("~/MA_2/NSS/bin")
probprime1024 <- data.table::fread("global_op_1.txt", sep = " ")
colnames(probprime1024) <- c("timestamp","diff","op")
#dfprobprime1024 <- data.table::data.table("timestamp"=integer(), "op"=numeric())
probprime1024[[1]] <- probprime1024[[1]]-probprime1024[[1]][1]

plot(probprime1024[[1]], probprime1024[[3]])
plot(probprime1024[[1]][1:100], probprime1024[[3]][1:100])

timestamps <- Filter(Negate(is.null), sapply(1:ncol(probprime1024),
                                    function(x) 
                                      if(x %% 2 == 1) 
                                        probprime1024[[x]]))

timestamps_diff <- sapply(1:length(timestamps), function(x){
  if(x>1) timestamps[[x]]-timestamps[[x-1]] 
  else timestamps[[x]]})

op <- Filter(Negate(is.null), sapply(1:ncol(probprime1024),
                                             function(x) 
                                               if(x %% 2 == 0) 
                                                 probprime1024[[x]]))


dfprobprime1024 <- data.table::data.table("timestamps"=timestamps, "op"=op)
