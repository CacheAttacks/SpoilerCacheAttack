setwd("~/MA_2/gpg_test")
tbl_ana <- read.table("/home/619501/MA_2/gpg_test/codelines.txt")
names(tbl_ana) <- c("codeline","cycles")
tbl_ana[,"cyclediff"] <- sapply(1:nrow(tbl_ana), 
                               function(i){
                                 if(i-1 > 0) tbl_ana[i,"cycles"]-tbl_ana[i-1,"cycles"] else 0
                                 })
tbl_ana[,"slot"] <- 0
tbl_ana[,"codeline"] <- factor(tbl_ana[,"codeline"], levels = c("mult85","sq272","mod356"))
tbl_ana[,"entry"] <- 1:nrow(tbl_ana)

#simulate 2500 cycle traces
lowestcount <- tbl_ana[1,"cycles"][[1]]
highestcount <- tbl_ana[nrow(tbl_ana),"cycles"][[1]]
slotsize <- 2500 #slot size in cycles
slots <- seq(from=lowestcount, to=highestcount+slotsize, by=slotsize)
for(i in 1:(length(slots)-1)){
  tbl_ana[tbl_ana[,"cycles"] >= slots[i] & tbl_ana[,"cycles"] < slots[i+1], "slot"] <- i
}
range<-1000
ggplot2::ggplot(tbl_ana[1:range,], ggplot2::aes(x=slot, y=codeline)) + 
  ggplot2::geom_point(ggplot2::aes(colour=factor(codeline))) +
  ggplot2::scale_x_continuous(breaks=1:tbl_ana[range,"slot"][[1]])


ggplot2::ggplot(tbl_ana[1:range,], ggplot2::aes(x=entry, y=1)) + 
  ggplot2::geom_point(ggplot2::aes(colour=factor(codeline))) +
  ggplot2::scale_x_continuous(breaks=1:range)
