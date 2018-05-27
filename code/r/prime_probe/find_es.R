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
          list_pos_sync_block_begin[[length(list_pos_sync_block_begin)+1]] <- pos_snyc_bit_begin - 1
        } 
        list_pos_sync_block_begin[[length(list_pos_sync_block_begin)+1]] <-
          i - bit_off_repeat_threshold
      }
      sync_bit_on <- F
      over_threshold_count <- 0
    }
  }
  return(list_pos_sync_block_begin)
}

search_for_hotspot_regions <- function(){
  
}

#assume each col has same bits
identify_bits <- function(tbl){
  #use median cause there are more untouched samples
  median_vec <- apply(tbl, 2, median)
  print(median_vec)
  #threshold
  threshold <- 1.5 * median_vec
  bit_on_vec <<- data.frame(apply(tbl, 2, function(vec) vec > threshold))
  #number of continues values > threshold => sync pattern
  sync_repeat_threshold <- 5
  #number of continues values > threshold => bit on
  bit_on_repeat_threshold <- 2
  #number of continues values <= threshold => bit off
  bit_off_repeat_threshold <- 1
  
  bits_between_sync <- 10
  
  #return(plot(bit_on_vec[50:nrow(bit_on_vec),1]))
  
  #discard_first_measurements <- 1
  
  list_sync_blocks <- split_in_sync(bit_on_vec[,1], sync_repeat_threshold, bit_off_repeat_threshold)
  print(list_sync_blocks)
  
  for(i in 1:(floor(length(list_sync_blocks)/2))*2-1){
    start <- list_sync_blocks[[i]]
    end <- list_sync_blocks[[i+1]]
    str <- analyse_bits_between_sync(bit_on_vec[start:end,1], bit_on_repeat_threshold, bit_off_repeat_threshold, 
                   sync_repeat_threshold, bits_between_sync)
    print(str)
  }
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
  print(bitstr)
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
