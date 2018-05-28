plotchannel <- function(tbl){
  if(ncol(tbl) == 1){
    tbl[,"sample"] <- 1:nrow(tbl)
    max_value <- 500
    tbl[tbl$V1>max_value, "V1"] <- max_value
    plot <- ggplot2::ggplot(tbl, ggplot2::aes(x = sample, y = V1)) + ggplot2::geom_histogram(stat = "identity")
    print(plot)
  }
}
plotchannel(tmp_tbl[130:313])

split_in_sync_hotspots <- function(time_line){
  hotspots <- list()
  hotspots_binary <- list()
  metric <- NULL
  for(i in 2:12){
    hotspots[[i]] <- sapply(1:length(time_line), function(x) mean(sum(time_line[x:x+i]))) 
    #at least 9 zero samples (pause between 1 bits), exclude samples with value 0
    #scale with factor
    threshold <- mean(sort(time_line[time_line != 0])[1:9]) * 1.5
    hotspots_binary[[i]] <- hotspots[[i]] > threshold 
    
    dist_sync <- sapply(1:(length(hotspots[[i]])-1), function(x) hotspots[[i]][x+1]-hotspots[[i]][x])
    #distances should be equal, f.e. low score if equal otherwise high score
    metric[i] <- sum(sapply(dist_sync, function(x) abs(x-median(dist_sync))))
  }
}

analyse_bits_between_sync_hotspot <- fucntion(time_line){
  hotspots <- list()
  hotspots_binary <- list()
  metric <- NULL
  for(i in 0:5){
    hotspots[[i]] <- sapply(1:length(time_line), function(x) sum(time_line[x:x+i])) 
    #at least 9 zero samples (pause between 1 bits), exclude samples with value 0
    #scale with factor and overwatched range
    threshold <- mean(sort(time_line[time_line != 0])[1:9]) * i * 1.5
    hotspots_binary[[i]] <- hotspots[[i]] > threshold 
    
    distance <- sapply(1:(length(hotspots[[i]])-1), function(x) hotspots[[i]][x+1]-hotspots[[i]][x])
    #distances should be multiples of each other, f.e. high score if for multiples otherwise low score
  }
}