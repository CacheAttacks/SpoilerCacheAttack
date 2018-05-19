test <- function(){
  
  balls <- 16
  bins <- 16
  full_bins <- 16
  calc_prob_exact(balls,bins,full_bins)
  
  exact <- sapply(1:16, function(x) calc_prob_exact(balls,bins,x))
  exact/sum(exact)
  
  sapply(1:16, function(x) calc_prob_lower_bound(balls,bins,x))
  sapply(1:16, function(x) calc_prob_upper_bound(balls,bins,x))
}

#calc prob for: l random thrown balls on b bins, fill exact m bins
calc_prob_exact <- function(balls, bins, full_bins){
  #[prod x=0 to full_bins-1 ((bins-x)/bins)]
  res <- Reduce('*', lapply(0:(full_bins-1), function(x) (bins-x)/bins), init = 1)
  if(balls > full_bins)
    res <- res * (full_bins/bins)^(balls-full_bins) #* choose(balls, balls-full_bins)
  return(res)
}

calc_prob_exact_alt <- function(balls, bins, full_bins){
  calc_prob_lower_bound(balls, bins, full_bins) * calc_prob_upper_bound(balls, bins, full_bins)
}

#calc prob for: l random thrown balls on b bins, fill at max m bins
calc_prob_upper_bound <- function(balls, bins, full_bins){
  if(full_bins >= balls)
    return(1)
  (full_bins/bins)^(balls-full_bins)
}

#calc prob for: l random thrown balls on b bins, fill at min m bins
calc_prob_lower_bound <- function(balls, bins, full_bins){
  if(balls < full_bins)
    return(0)
  #[prod x=0 to full_bins-1 ((bins-x)/bins)]
  res <- Reduce('*', lapply(0:(full_bins-1), function(x) (bins-x)/bins), init = 1)
  return(res)
}

real_test(4,5,1000000)

real_test <- function(balls, bins, iterations){
  count_vec <- numeric(bins)
  
  for(i in 1:iterations){
    val <- length(unique(sample(1:bins, balls, replace = T)))
    count_vec[val] <- count_vec[val] + 1
  }
  sum_count_vec <- sum(count_vec)
  for(i in 1:length(count_vec)){
    print(paste0("i:", i , "=", count_vec[i], "(", count_vec[i]/sum(count_vec), ")"))
  }
}

empty_bins(16,28)

empty_bins <- function(balls, bins){
  needed_balls <- 0
  for(i in 1:bins){
    #coupon_prob
    next_ball_avg <- bins/(bins-i+1)
    needed_balls <- needed_balls + next_ball_avg
    if(needed_balls > balls){
      before <- needed_balls - next_ball_avg
      return(bins-i)
    }
      
  }
}

next_coupon <- function(bins, i){
  bins/(bins-i+1)
}

#P(X_i = k) https://de.wikipedia.org/wiki/Sammelbilderproblem#cite_note-10
next_coupon_prob(i,coupons,k){
  (i-1/coupons)^(k-1) * ((coupons-i+1)/coupons)
}

#[1] "i:1=0(0)"
#[1] "i:2=0(0)"
#[1] "i:3=0(0)"
#[1] "i:4=1(1e-06)"
#[1] "i:5=34(3.4e-05)"
#[1] "i:6=858(0.000858)"
#[1] "i:7=10132(0.010132)"
#[1] "i:8=59918(0.059918)"
#[1] "i:9=185403(0.185403)"
#[1] "i:10=304934(0.304934)"
#[1] "i:11=273819(0.273819)"
#[1] "i:12=129985(0.129985)"
#[1] "i:13=31256(0.031256)"
#[1] "i:14=3535(0.003535)"
#[1] "i:15=122(0.000122)"
#[1] "i:16=3(3e-06)"
