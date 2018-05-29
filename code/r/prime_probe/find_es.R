find_noise_es <- function(tbl) {
  mean_vec <- apply(tbl, 2, mean)
  mean_vec_64_groups <- unlist(lapply(split(mean_vec, ceiling(seq_along(mean_vec)/64)), mean))
  noise_es_index <- match(max(mean_vec_64_groups), mean_vec_64_groups)
  print(paste0("es ", noise_es_index, " from ", (noise_es_index-1)*64, " to ", noise_es_index*64-1))
}

split_in_sync <- function(bit_on_vec, sync_repeat_threshold, bit_off_repeat_threshold){
  over_threshold_count <- 0
  under_threshold_count <- 0
  sync_bit_on <- F
  slot_counter <- 0
  pos_snyc_bit_begin <- 0
  list_pos_sync_block_begin <- list()
  
  for(i in seq_along(bit_on_vec)){
    slot_counter <- slot_counter + 1
    if(bit_on_vec[i]){
      over_threshold_count <- over_threshold_count + 1
      under_threshold_count <- 0
    } else if(!bit_on_vec[i]){
      under_threshold_count <- under_threshold_count + 1
    }
    #sync on detected
    if(over_threshold_count > sync_repeat_threshold){
      sync_bit_on <- T
      #save beginn of sync block
      pos_snyc_bit_begin <- i - over_threshold_count - 1
    }
    #bit off detected
    if(under_threshold_count > bit_off_repeat_threshold){
      if(sync_bit_on){
        if(length(list_pos_sync_block_begin) > 0){
          #we want pos before beginning
          list_pos_sync_block_begin[[length(list_pos_sync_block_begin)+1]] <- 
            c(pos_snyc_bit_begin - 1, over_threshold_count)
        } 
        list_pos_sync_block_begin[[length(list_pos_sync_block_begin)+1]] <-
          c(i - bit_off_repeat_threshold, over_threshold_count)
      }
      sync_bit_on <- F
      over_threshold_count <- 0
    }
  }
  return(list_pos_sync_block_begin)
}

print_median_approach <- function(tbl, bit_on_vec){
  max_value <- 700
  tbl[tbl$V1>max_value, "V1"] <- max_value
  par(mfrow = c(2,1),oma = c(2,2,0,0) + 0.1,mar = c(0,0,2,1) + 0.2)
  plot(1:length(tbl[[1]]),tbl[[1]],type="l",ylab="",xlab="") 
  plot(bit_on_vec,type="S",col="red",ylab="",xlab="",ylim=c(-1.5,1.5),lwd=2)
  recordPlot()
}

#assume each col has same bits
identify_bits <- function(tbl){
  tmp <<- tbl
  #use median cause there are more untouched samples
  median_vec <- apply(tbl, 2, median)
  print(median_vec)
  #threshold
  threshold <- 1.5 * median_vec
  bit_on_vec <<- data.frame(apply(tbl, 2, function(vec) vec > threshold))
  
  print_median_approach(tmp, bit_on_vec)
  #par(mfrow = c(2,1),oma = c(2,2,0,0) + 0.1,mar = c(0,0,2,1) + 0.2)
  #plot(1:length(tmp[[1]]),tmp[[1]],type="l",ylab="",xlab="") 
  #plot(bit_on_vec,type="S",col="red",ylab="",xlab="",ylim=c(-1.5,1.5),lwd=2)
  
  #number of continues values > threshold => sync pattern
  sync_repeat_threshold <- 18
  #number of continues values > threshold => bit on
  bit_on_repeat_threshold <- 3
  #number of continues values <= threshold => bit off
  bit_off_repeat_threshold <- 1
  
  bits_between_sync <- 10
  
  block_sample_size <- 1500
  
  #discard_first_measurements <- 1
  
  result <<- calc_smoothed_z_score(tbl[[1]])
  
  length_dist <- get_concusive_ones_dist(result$signals)
  
  approx_syncs <- round(length(result$signals)/block_sample_size)
  
  bit_on_repeat_threshold <- 
    mean(Reduce(c, apply(length_dist[2:(nrow(length_dist)-approx_syncs),], 1, function(x) rep(as.numeric(x[1]),x[2]))))
  
  sync_repeat_threshold <- 0.7 * 
    median(Reduce(c, apply(length_dist[(nrow(length_dist)-approx_syncs+1):nrow(length_dist),], 1, function(x) rep(as.numeric(x[1]),x[2]))))
  print(paste0("sync_repeat_threshold:", sync_repeat_threshold))
  
  #smooth result
  for(i in 1:(length(result$signals)-2)){
    if(result$signals[i] == 1 && result$signals[i+1] == 0 && result$signals[i+2] == 1)
      result$signals[i+1] <- 1
  }
  
  list_sync_blocks <<- split_in_sync(result$signals, sync_repeat_threshold, bit_off_repeat_threshold)
  #print(list_sync_blocks)
  
  str_list <- list()
  if(length(list_sync_blocks) > 1){
    for(i in 1:(floor(length(list_sync_blocks)/2))*2-1){
      start <- list_sync_blocks[[i]][1]
      end <- list_sync_blocks[[i+1]][1]
      str_list[[length(str_list)+1]] <- analyse_bits_between_sync(result$signals[start:end], bit_on_repeat_threshold, bit_off_repeat_threshold, 
                     sync_repeat_threshold, bits_between_sync)
      #print(str_list[[length(str_list)]])
    }
  }
  return(str_list)
}

analyse_bits_between_sync <- function(time_line, bit_on_repeat_threshold, bit_off_repeat_threshold, 
                             sync_repeat_threshold, bits_between_sync){
  over_threshold_count <- 0
  under_threshold_count <- 0
  bit_on <- F
  bit_on_counter <- 0
  slot_counter <- 0
  bit_off_counter_between_sync <- 0
  bitstr_between_sync <- ""
  list_bit_off_counter <- NULL
  for(i in seq_along(time_line)){
    slot_counter <- slot_counter + 1
    if(time_line[i]){
      over_threshold_count <- over_threshold_count + 1
      under_threshold_count <- 0
    } else if(!time_line[i]){
      under_threshold_count <- under_threshold_count + 1
    }
    #bit on detected
    if(over_threshold_count > bit_on_repeat_threshold){
      bit_on <- T
    }
    #bit off detected
    if(under_threshold_count > bit_off_repeat_threshold){
      if(bit_on){
        bit_off_counter <- slot_counter - over_threshold_count
        bit_on_counter <- bit_on_counter + 1
        bitstr_between_sync <- paste0(bitstr_between_sync, "(", bit_off_counter, ")1")
        list_bit_off_counter[length(list_bit_off_counter)+1] <- bit_off_counter

        slot_counter <- 0
        bit_off_counter_between_sync <- bit_off_counter_between_sync + bit_off_counter
      }
      
      under_threshold_count <- 0
      over_threshold_count <- 0
      bit_on <- F
    }
  }        
  bit_off_counter <- slot_counter - over_threshold_count
  bitstr_between_sync <- paste0(bitstr_between_sync, "(", bit_off_counter, ")")
  list_bit_off_counter[length(list_bit_off_counter)+1] <- bit_off_counter
  average_pause_length <- bit_off_counter_between_sync / (bits_between_sync + 1)
  #bitstr <- edit_sync_str(bitstr_between_sync, average_pause_length, bit_on_counter)
  bitstr2 <- get_zeros(list_bit_off_counter, average_pause_length, bits_between_sync-bit_on_counter)
  
  return(bitstr2)
}
#1000111001

gregexpr("\\([0-9]+\\)","1(29)s(29)1(127)1(29)1(27)1(94)1(31)s(23)1")

get_zeros <- function(list_bit_off_counter, average_pause_length, zeros_to_fill){
  pos_zeros <- rep(0, length(list_bit_off_counter))
  for(i in 1:zeros_to_fill){
    pos <- match(max(list_bit_off_counter), list_bit_off_counter)
    pos_zeros[pos] <- pos_zeros[pos] + 1
    list_bit_off_counter[pos] <- list_bit_off_counter[pos] - average_pause_length
  }
  bitstr <- Reduce(paste0, sapply(pos_zeros, function(x){
    paste0("1", Reduce(paste0, rep(0,x)))
  }))
  bitstr <- substring(bitstr, 2, nchar(bitstr))
  #print(bitstr)
  return(bitstr)
}

edit_sync_str <- function(sync_str, average_pause_length, bit_on_counter){
  print(sync_str)
  final_str <- ""
  pos_to_replace <- gregexpr("\\([0-9]+\\)", sync_str)
  last_pos <- 0
  for(i in seq_along(pos_to_replace[[1]])){
    pos <- pos_to_replace[[1]][i]
    final_str <- paste0(final_str, substr(sync_str, last_pos, pos-1))
    end_pos <- pos + attr(pos_to_replace[[1]],"match.length")[i]
    to_replace <- as.numeric(substr(sync_str, pos + 1, end_pos - 2))
    zeros <- round(to_replace / average_pause_length) - 1
    if(zeros > 0){
      final_str <- paste0(final_str, Reduce(paste0, rep(0, zeros)))
    }
    #after )
    last_pos <- end_pos
  }
  return(final_str)
}


compare_bitstr_list <- function(bitstr_list, default_bitstr){
  #print(default_bitstr)
  errors <<- sapply(bitstr_list, function(str) {
    sum(sapply(1:nchar(str), function(pos) substr(default_bitstr, pos, pos) != substr(str, pos, pos)))
  })
  #print(sum(errors))
  info_str <- paste0("error sum:", sum(errors), ", error-rate: ", (sum(errors)/(nchar(default_bitstr)*length(bitstr_list))))
  return(info_str)
}

get_concusive_ones_dist <- function(bit_vec){
  counter_one <- 0
  bit_on <- 0
  length_ones <- list()
  for(i in 1:length(bit_vec)){
    if(bit_vec[i] == 1){
      bit_on <- 1
      counter_one <- counter_one + 1
    } else if(bit_on == 1){
      length_ones[[length(length_ones) + 1]] <- c(counter_one, i)
      bit_on <- 0
      counter_one <- 0
    }
  }
  #print(length_ones)
  length_dist <- data.table::data.table(table(sapply(length_ones, function(x) x[1])))
  #print(length_dist)
  return(length_dist)
}

smooth <- function(bit_vec, factor, neighbors=1){
  for(i in (neighbors+1):(length(bit_vec)-neighbors)){
    bit_vec[i] <- bit_vec[i] * (1-(2*factor)) + bit_vec[i-1] * factor + bit_vec[i+1] * factor
  }
  return(bit_vec)
}

lag       <- 30
threshold <- 4
influence <- 0.01

plot_smoothed_z_score <- function(y){
  result <- calc_smoothed_z_score(y)
  
  par(mfrow = c(2,1),oma = c(2,2,0,0) + 0.1,mar = c(0,0,2,1) + 0.2)
  plot(1:length(y),y,type="l",ylab="",xlab="") 
  lines(1:length(y),result$avgFilter,type="l",col="cyan",lwd=2)
  lines(1:length(y),result$avgFilter+threshold*result$stdFilter,type="l",col="green",lwd=2)
  lines(1:length(y),result$avgFilter-threshold*result$stdFilter,type="l",col="green",lwd=2)
  plot(result$signals,type="S",col="red",ylab="",xlab="",ylim=c(-1.5,1.5),lwd=2)
  p <- recordPlot()
  return(print(p))
}

calc_smoothed_z_score <- function(y){
  #y <- smooth(y, 0.25)
  
  result <- ThresholdingAlgo(y,lag,threshold,influence)
  result$signals[result$signals == -1] <- 0
  
  return(result)
}