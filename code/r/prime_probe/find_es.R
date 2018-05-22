find_noise_es <- function(tbl) {
  mean_vec <- apply(tbl, 2, mean)
  mean_vec_64_groups <- unlist(lapply(split(mean_vec, ceiling(seq_along(mean_vec)/64)), mean))
  noise_es_index <- match(max(mean_vec_64_groups), mean_vec_64_groups)
  print(paste0("es ", noise_es_index, " from ", (noise_es_index-1)*64, " to ", noise_es_index*64-1))
}

split_in_sync <- function(bit_on_vec, sync_repeat_threshold){
  
}

#assume each col has same bits
identify_bits <- function(tbl){
  #use median cause there are more untouched samples
  median_vec <- apply(tbl, 2, median)
  #threshold
  threshold <- 2 * median_vec
  bit_on_vec <<- data.frame(apply(tbl, 2, function(vec) vec > threshold))
  #number of continues values > threshold => sync pattern
  sync_repeat_threshold <- 10
  #number of continues values > threshold => bit on
  bit_on_repeat_threshold <- 2
  #number of continues values <= threshold => bit off
  bit_off_repeat_threshold <- 1
  
  bits_between_sync <- 10
  
  return(plot(bit_on_vec[50:nrow(bit_on_vec),1]))
  
  discard_first_measurements <- 50
  
  anlyse_time_line(bit_on_vec[50:nrow(bit_on_vec),1], bit_on_repeat_threshold, bit_off_repeat_threshold, 
                   sync_repeat_threshold, bits_between_sync)
}

anlyse_time_line <- function(time_line, bit_on_repeat_threshold, bit_off_repeat_threshold, 
                             sync_repeat_threshold, bits_between_sync){
  over_threshold_count <- 0
  under_threshold_count <- 0
  bit_on <- F
  bit_on_counter <- 0
  sync_counter <- 0
  sync_bit_on <- F
  slot_counter <- 0
  bit_off_counter_between_sync <- 0
  bitstr_between_sync <- ""
  bitstr <- ""
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
    #sync on detected
    if(over_threshold_count > sync_repeat_threshold){
      sync_bit_on <- T
    }
    #bit off detected
    if(under_threshold_count > bit_off_repeat_threshold){
      if(bit_on){
        bit_off_counter <- slot_counter - over_threshold_count
        if(sync_bit_on){
          sync_counter <- sync_counter + 1
          bitstr_between_sync <- paste0(bitstr_between_sync, "(", bit_off_counter, ")s")
          if(sync_counter == 1){
            bitstr_between_sync <- "s"
            bit_off_counter_between_sync <- 0
          } else {
            average_pause_length <- bit_off_counter_between_sync / (bits_between_sync + 1)
            bitstr <- paste0(bitstr, edit_sync_str(bitstr_between_sync, average_pause_length))
            bitstr_between_sync <- ""
            bit_on_counter <- 0
          }
        } else {
          bit_on_counter <- bit_on_counter + 1
          bitstr_between_sync <- paste0(bitstr_between_sync, "(", bit_off_counter, ")1")
        }
        slot_counter <- 0
        bit_off_counter_between_sync <- bit_off_counter_between_sync + bit_off_counter
      }

      under_threshold_count <- 0
      over_threshold_count <- 0
      bit_on <- F
      sync_bit_on <- F
    }
  }
  return(bitstr)
}
#1000111001

gregexpr("\\([0-9]+\\)","1(29)s(29)1(127)1(29)1(27)1(94)1(31)s(23)1")


edit_sync_str <- function(sync_str, average_pause_length){
  if(substr(sync_str,1,1) != "s" || substr(sync_str,nchar(sync_str),nchar(sync_str)) != "s") {
    warning("sync_str invalid ", sync_str)
    return("invalid")
  }
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
  return(substr(final_str,2,nchar(final_str)))
}
