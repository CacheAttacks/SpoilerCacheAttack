prob_oracle <- function(prob){
  if(prob == 0){
    return(FALSE)
  }
  val <- sample(1:2^(-log2(prob)), 1)
  return(val == 1)
}

#false_high_acces access time is high but a eviction didn't take place
#false_low_access access time is low but a eviction take place, very unlikely

simulate_es <- function(pool_size = 2048, max_cache_sets = 128, 
                        false_high_acces = 0.001, false_low_access = 0){
  pool <- sample(1:max_cache_sets, pool_size, T)
  
  #costs
  stats <- NULL
  stats["expand_ops"] <- 0
  stats["contract_ops"] <- 0
  stats["collect_ops"] <- 0
  stats["es_count"] <- 0
  stats["expand_rounds"] <- 0
  
  while(length(pool) > 0){
    expand_successful <- FALSE
    index_vec <- integer(max_cache_sets)
    
    #choose candidate
    rand_index <- sample(1:length(pool),1)
    candidate <- pool[rand_index]
    pool <- pool[-rand_index]
    stats["expand_rounds"] <- stats["expand_rounds"] + 1
      
    while(length(pool) > 0){
      #expand
      rand_index <- sample(1:length(pool),1)
      rand_value <- pool[rand_index]
      pool <- pool[-rand_index]
      
      index_vec[rand_value] <- index_vec[rand_value] + 1
      
      #false detection
      #if(prob_oracle(false_high_acces)){
        #no effect because result is proved multiple times
      #} 
      
      if(index_vec[candidate] == 16 && !prob_oracle(false_low_access)){
        #assume a start with 16
        stats["expand_ops"] <- stats["expand_ops"] + sum(index_vec) - 16
        expand_successful <- TRUE
        break
      }
    }
    if(expand_successful){
      #contract
      stats["contract_ops"] <- stats["contract_ops"] + sum(index_vec)
      #collect
      stats["collect_ops"] <- stats["collect_ops"] + length(pool)
      #delete candiate like blocks
      pool <- pool[pool != candidate]
      
      stats["es_count"] <- stats["es_count"] + 1
    }
    
    #refill pool
    for(index in 1:length(index_vec)){
      if(index != candidate || !expand_successful){
        pool <- c(pool, rep(index, index_vec[index]))
      }
    }
    
    #print(paste0("pool size= ", length(pool), ", expand_suc: ", expand_successful))
    
    if(stats["es_count"] == 128){
      break
    }
  }
  print(paste0("es_count= ", stats["es_count"]))
  #print(paste0("mean expand size= ", stats["expand_ops"] / stats["es_count"]))
  print(paste0("expand_ops=", stats["expand_ops"], ", contract_ops", stats["contract_ops"], 
               ", collect_ops=", stats["collect_ops"], ", rounds=", stats["expand_rounds"]))
  return(stats)
}

simulate_es(pool_size = 4096, max_cache_sets = 128)
storeFor <- simulate_es(pool_size = 100, max_cache_sets = 4)
