find_noise_es <- function(tbl) {
  mean_vec <- apply(tbl, 2, mean)
  mean_vec_64_groups <- unlist(lapply(split(mean_vec, ceiling(seq_along(mean_vec)/64)), mean))
  noise_es_index <- match(max(mean_vec_64_groups), mean_vec_64_groups)
  print(paste0("es ", noise_es_index, " from ", (noise_es_index-1)*64, " to ", noise_es_index*64-1))
}

#assume each col has same bits
identify_bits <- function(tbl){
  #use median cause there are more untouched samples
  median_vec <- apply(tbl, 2, median)
  #threshold
  threshold <- 3 * median_vec
  bit_on_vec <- data.frame(apply(tbl, 2, function(vec) vec > threshold))
}