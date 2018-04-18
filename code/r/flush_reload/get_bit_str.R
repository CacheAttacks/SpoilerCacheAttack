get_bit_str <- function(file_path){
  tbl <- read.table(file_path)
  names(tbl) <- c("mult", "sq", "mod")

  #zero is sq (mod) sq
  #one is sq (mod) mult (mod) sq
  threshold <- 100
  op_min_slots <- 5
  bitvector <- NULL

  #flags
  begin_op <- 0
  slot_counter <- 0
  slot_mod_counter <- 0
  mult_flag <- 0

  for(i in 1:nrow(tbl)){
    slot_counter <- slot_counter + 1
    if(tbl[i,"mod"] < threshold && tbl[i,"mod"] > 0){
      slot_mod_counter <- slot_mod_counter + 1
    }

    if(tbl[i,"mult"] < threshold && tbl[i,"mult"] > 0){
      mult_flag <- 1
    }

    if(tbl[i,"sq"] < threshold && tbl[i,"sq"] > 0){
      if(begin_op == 0)
      {
        slot_counter <- 0
        slot_mod_counter <- 0
        begin_op <- 1
      }
      else if(slot_counter >= op_min_slots)
      {
        if(tbl[i,"mult"] < threshold)
        {
          #assume failed speculative execution
          next
        }
        if(slot_mod_counter < 2)
        {
          #assume long execution of square operation
          next
        }
        #assume decetion of new bit
        bitvector <- c(bitvector, if(mult_flag==1) 1 else 0)
        names(bitvector)[length(bitvector)] <- i

        slot_counter <- 0
        slot_mod_counter <- 0
        mult_flag <- 0
      }
    }
  }

  return(bitvector)
}
