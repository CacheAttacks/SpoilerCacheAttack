max_cache_sets <- 128
pool_size <- 4096
pool <- sample(1:128, pool_size, T)

index_vec <- integer(max_cache_sets)
while(length(pool)>0){
  #expand
  rand_index <- sample(1:length(pool),1)
  rand_value <- pool[rand_index]
  pool <- pool[-rand_index]
  
  index_vec[rand_value] <- index_vec[rand_value] + 1
  if(index_vec[rand_value] >= 16){
    break 
  }
}
