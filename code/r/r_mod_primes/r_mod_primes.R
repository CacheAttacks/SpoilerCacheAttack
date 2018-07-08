setwd("/home/619501/MA_2/NSS/bin")
r_mod_primes <- data.table::fread("r_mod_primes.txt")
colnames(r_mod_primes) <- c("primes","rem")
r_mod_primes[,"min"] <- floor(r_mod_primes[["rem"]]/128)*128
r_mod_primes[,"max"] <- (floor(r_mod_primes[["rem"]]/128)+1)*128-1

gen_mathematica_str <- function(r_mod_primes){paste0("ChineseRemainder[{", Reduce(function(x,y) paste0(x,", ",y), r_mod_primes[["rem"]]), "},{", 
       Reduce(function(x,y) paste0(x,", ",y), r_mod_primes[["primes"]]), "}]")}

write(mathematica_str, file="mathematica_str.txt")


#generate example for
nprimes <- 50
example_mathematica_str <- gen_mathematica_str(r_mod_primes[31:(31+nprimes),])


minList <- c(0, 0, 3, 3, 0, 9, 6, 3, 0, 24, 24, 24, 24, 24, 24, 24)
maxList <- c(1, 2, 4, 5, 2, 11, 8, 5, 2, 26, 26, 26, 26, 26, 26, 26)
primes <- c(2,r_mod_primes[["primes"]][1:length(minList)-1])
primesProd <- Reduce("*", primes)
gcdvalues <- c(16294579238595022365, -10863052825730014910, 6517831695438008946, 
               -13966782204510019170, 2962650770653640430, 12534291721996171050,
               -13419065255313547830, 15436969804984758030, -7084599668954357550, 
               -6742584512522078220, -5256315883417749150, -7046304535608658320, 
               11128005333674649420, -12126198503140481760, 10400795258677673850, 
               1229779565176982820)

vars <- length(minList)
equations <- 2*vars


library(lpSolveAPI)
lprec <- make.lp(0, vars+2)
set.bounds(lprec, lower = c(minList), columns = 1:(vars))
set.bounds(lprec, upper = c(maxList), columns = 1:(vars))
set.type(lprec, type = "integer", columns = 1:(vars+2))
add.constraint(lprec, c(gcdvalues, primesProd, -primesProd), "<=", 32)
add.constraint(lprec, c(gcdvalues, primesProd, -primesProd), ">=", 0)
set.objfn(lprec, c(gcdvalues, 0, 0))
write.lp(lprec, filename="test.lp")


solve(lprec)
get.objective(lprec)
get.variables(lprec)

#get x
Reduce("+", get.variables(lprec)[1:(length(get.variables(lprec))-2)] * gcdvalues) %% primesProd
#Reduce("+", (c(1,2,2,3,6,4,0,17,17)* gcdvalues)) %% primesProd
#floor(Reduce("+", (c(1,2,2,3,6,4,0,17,17)* gcdvalues)) / primesProd)
#old

for(i in 1:equations){
  row <- c(rep(0,ceiling(i/2)-1), 1, rep(0,vars-1-ceiling(i/2)-1))
  print(row)
  condition <- if(i %% 2==1)"<=" else ">="
  print(condition)
  condition_value <- if(i %% 2==1) maxList[ceiling(i/2)] else minList[ceiling(i/2)]
  print(condition_value)
  add.constraint(x, i, row, condition, condition_value)
}




x <- make.lp(equations, vars)
for(i in 1:vars){
  set.column(x, i, c(rep(0,2*(i-1)),1,-1,rep(0,equations-2-2*(i-1))))
  set.constr.type(x, "<=", i)
}


