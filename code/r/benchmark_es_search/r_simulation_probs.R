l <- list()
for(i in 1:1000){
  l[[length(l)+1]] <- (table(sample(1:128, 128*1, replace = T))[1] >= 1)
}
Reduce("+", l)/1000

n<-100000
l <- 1:n
for(i in 1:n){
  l[i] <- sum(sample(1:128, 128*16, replace = T) %in% 1) >= 16
}
Reduce("+", l)/n


n<-50000
l <- 1:n
for(i in 1:n){
  l[i] <- sum(table(sample(1:128, 3860, replace = T)) >= 16)
}
Reduce("+", l)/n
1-(sum(sapply(l,function(x){x<128}))/n)

n<-100000
l <- 1:n
for(i in 1:n){
  l[i] <- sum(table(sample(1:4, 90, replace = T)) >= 16)
}
sum(sapply(l,function(x){x==4}))/n


n<-10000
l <- 1:n
k <- 3 #farben, slices
a <- 2 #assoziativität
samples <- 8
for(i in 1:n){
  l[i] <- sum(table(sample(1:k, samples, replace = T)) >= a)
}
sum(sapply(l,function(x){x==k}))/n

values <- c(264, 140, 224, 116, 24, 292, 212, 239, 684, 252, 24, 24, 176, 908, 787, 640, 92, 1451, 80, 304, 172, 244, 564, 127, 804, 416, 104, 877, 716, 104, 40, 64, 176, 100, 500, 48, 104, 189, 96, 808, 620, 100, 72, 252, 172, 728, 168, 268, 54, 214, 160, 324, 454, 286, 90, 4918, 278, 516, 1160, 168, 236, 116, 252, 131, 160, 44, 136, 64, 1072, 122, 572, 296, 48, 316, 228, 940, 100, 748, 2949, 120, 104, 88, 389, 32, 772, 544, 268, 488, 4413, 232, 64, 4332, 39, 536, 24)
table(values)                  
