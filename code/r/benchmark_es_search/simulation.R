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
    #rand_index <- sample(1:length(pool),1)
    #candidate <- pool[rand_index]
    #pool <- pool[-rand_index]
    stats["expand_rounds"] <- stats["expand_rounds"] + 1
      
    while(length(pool) > 0){
      #expand
      rand_index <- sample(1:length(pool),1)
      candidate <- pool[rand_index]
      pool <- pool[-rand_index]
      
      #if(length(pool) < 1){
      #  print(length(pool))
      #}
      
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
      
      if(length(pool) > 0){
        index_vec[candidate] <- index_vec[candidate] + 1
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

#simulate_es(pool_size = 4096, max_cache_sets = 128)




#storeFor <- simulate_es(pool_size = 100, max_cache_sets = 4)

#bla <- function(){
tbl <- NULL
res <- NULL
df <- data.frame(pool_size=numeric(),expand_ops=numeric(),contract_ops=numeric(),
                 collect_ops=numeric(),es_count =numeric(),expand_rounds=numeric())
for(pool_size in seq(2048,6144,128)){
  index <- (pool_size-2048)/128+1
  runs <- 10
  for(i in 1:runs){
    df[nrow(df)+1,] <- c("pool_size"=pool_size, simulate_es(pool_size = pool_size, max_cache_sets = 128))
  }
  #a <- lapply(1:runs, function(x) simulate_es(pool_size = pool_size, max_cache_sets = 128))
  #mean <- sum(sapply(a, function(x)x[3]))/runs
  #print(paste0("pool_size:", pool_size, sum(sapply(a, function(x)x[3]))/runs))
  #res[index] <- mean
  #df[nrow(df),] <- a
}
#}

#save(df, file ="time_data.RData")



setwd("~/MA_2/master-moritz_krebbel-drive_by_cache_attacks/code/r/benchmark_es_search")
load("time_data.RData")

df_mean <- aggregate(df[, -1], list(df$pool_size), mean)
names(df_mean)[2:4] <- c("Expand-Phase", "Contract-Phase", "Collect-Phase")

m <- reshape::melt(df_mean[,1:4], id="Group.1")

ggplot2::ggplot() + 
  ggplot2::geom_line(data=m, ggplot2::aes(Group.1, value, color=variable, linetype=variable)) +
  ggplot2::scale_y_continuous(name="Wahrscheinlichkeit (\\%)", 
                            limits=c(0, 300000),
                            breaks=seq(0,300000,60000)) +
  ggplot2::scale_x_continuous(name="Anzahl an Adressen im Pool (x)", 
                              limits=c(2048, 6144), 
                              breaks=c(seq(2048,6144,412)))+
  ggplot2::theme(legend.position = c(0.1, 0.83), legend.title=ggplot2::element_blank())
  