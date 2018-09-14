setwd("~/MA_2/master-moritz_krebbel-drive_by_cache_attacks/code/r/store_forward_plot")

page_size <- 4096
start_add <- 174637056/page_size + 63
times <- as.vector(sapply((scan("times.txt", character(), quote = "")), function(x){
  if(grepl("?",x,fixed=TRUE)){
    as.integer(substr(x,1,nchar(x)-1))*-1
  } else as.integer(x)
  }))
real_times <- sapply(times, function(x){if(x <0) x*-1 else x})
all <- sort(as.integer(scan("all_blocks.txt", character(), quote = ""))/page_size-start_add)
diff <- unlist(sapply(1:length(all), function(i){if(i>0)all[i]-all[i-1] else all[i]}))

set1 <- as.integer(scan("set1.txt", character(), quote = ""))/page_size-start_add
set2 <- as.integer(scan("set2.txt", character(), quote = ""))/page_size-start_add
set3 <- as.integer(scan("set3.txt", character(), quote = ""))/page_size-start_add
set4 <- as.integer(scan("set4.txt", character(), quote = ""))/page_size-start_add

merged <- sort(c(set1,set2,set3,set4))

non_valid <- all[!(all %in% merged)]
#64,66
start <- all[6]-10
end <- all[8]+20

require( tikzDevice )
tikz( 'StoreForward_all_valid.tex' )
plot(start:end, real_times[start:end], pch=20,
     xlab="4KiB block index", ylab="SAB timer value")
colliding_add_pos <- which(times[start:end] < 0) + start - 1
colliding_add_pos_valid <- colliding_add_pos[colliding_add_pos %in% merged]
colliding_add_pos_non_valid <- colliding_add_pos[!(colliding_add_pos %in% merged)]
points(colliding_add_pos, real_times[colliding_add_pos], col = "blue")
#points(colliding_add_pos_non_valid, real_times[colliding_add_pos_non_valid], col = "red")
dev.off()

plot(c(-1, 26), 0:1, type = "n", axes = FALSE)
text(0:25, 0.6, 0:25, cex = 0.5)
points(0:25, rep(0.3, 26), pch = 0:25, bg = "grey", col = "blue")
