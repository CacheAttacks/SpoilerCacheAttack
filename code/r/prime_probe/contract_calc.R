calc_prob_exact_sterling(16,16,10)

#prob 
#http://www.cits.rub.de/imperia/md/content/may/dima08/06_urnen.pdf
calc_prob_exact_sterling <- function(balls, bins, full_bins){
  if(full_bins > balls)
    return(0)
  
  #bins choose full_bins * full_bins! * S(balls,full_bins)
  combs <- choose(bins, full_bins) * factorial(full_bins) * 
    as.numeric(gmp::Stirling2(balls, full_bins))
  all_combs <- bins^balls
  prob <- combs/all_combs
  return(prob)
}

calc_free_bins_avg <- function(balls, bins){
  free_bins <- 0
  for(i in 1:balls){
    free_bins <- free_bins + calc_prob_exact_sterling(balls, bins, i) * (bins-i)
  }
  return(free_bins)
}

#associativity associativity of L3-Cache
#del_number number of deleted memory-blocks in each iteration
get_contract_perfect_del_number <- function(associativity, avg_es_size, avg_prime_probe_time=0){
  last_saved_prime_probes <- 0
  for(del_number in 1:50){
    groups <- avg_es_size / del_number
    #unrealistic assumption, cause actually there are more than 16 memory blocks in the avg es 
    #which correspond to the same cache set
    free_groups <- calc_free_bins_avg(associativity, groups)
    #groups * 2 for management overhead
    saved_prime_probes <- free_groups * del_number - (groups * 2) 
    if(saved_prime_probes > last_saved_prime_probes || last_saved_prime_probes == 0){
      last_saved_prime_probes <- saved_prime_probes
    } else{
      print(paste0("saved:", last_saved_prime_probes, " real_del:", 
                   last_saved_prime_probes + (avg_es_size / (del_number-1))*2, 
                                              " groups:", groups))
      return(del_number-1)
    }
  }
  return("error")
}

#> get_contract_perfect_del_number(16, 1000)
#[1] "saved:657.682329462477 real_del:824.348996129143 groups:76.9230769230769"
#[1] 12
#> get_contract_perfect_del_number(16, 126)
#[1] "saved:15.7220517709164 real_del:57.7220517709164 groups:18"
#[1] 6
#> get_contract_perfect_del_number(16, 68)
#[1] "saved:-7.1558972602074 real_del:15.5107694064593 groups:9.71428571428571"
#[1] 6

get_contract_perfect_del_number(16, 1000)

calc_free_bins_avg(16,16)

calc_prob_exact_sterling(16,16,1)
