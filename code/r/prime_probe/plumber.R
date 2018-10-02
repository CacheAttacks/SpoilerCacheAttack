# plumber.R

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#* @get /printdata
function(){
  data
}

val <- 10

#* @param a Value for a
#* @get /change
function(a){
  val <<- a
}

#* Plot a histogram
#* @png
#* @get /plot
function(){
  val <- 10
  if(data == "jo"){
    val <- 1000
  }
  rand <- rnorm(val)
  hist(rand)
}

#* @png
#* @get /dummy
function(){
  plot(1)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b){
  as.numeric(a) + as.numeric(b)
}

#By default, the API endpoint forbids “cross-domain” requests, 
#but it’s possible with a workaround to override this behavior 
#creating a custom function that will forward the right headers 
#to the API using a filter such as the following snippet.
#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  a <<- res
  plumber::forward()
}

#Once this filter is defined, each endpoint will allow 
#“cross-domain” requests. It’s possible to disable it for some, 
#by appending the line #* @preempt cors before the declaration 
#of a function like this :
#* @preempt cors
#* @get /sub
cors_disabled <- function(a, b){
  as.numeric(a) - as.numeric(b)
}

data <- ""
dataworker <- ""

#* @param newdata data for the file
#* @post /changedata
function(newdata){
  data <<- newdata
  mydata <<- newdata
  #print(newdata)
}

#* @param newdata data for the file
#* @post /changedataworker
function(newdata){
  dataworker <<- newdata
  mydataworker <<- newdata
  #print(newdata)
}

#* @param newdata monitored es index vec
#* @post /changeindexvec
function(newdata){
  indexvecdata <<- newdata
  #print(indexvec)
  indexvec <<- sapply(which(sapply(strsplit(indexvecdata, split=","), as.numeric) != 0)-1, as.character)
  if(length(indexvec) == 0)
    warning("length(indexvec) == 0")
  print(indexvec)
}

#* @param newdata monitored x index vec
#* @post /changexindexvec
function(newdata){
  changexindexvec <<- newdata
  #print(indexvec)
  xindexvec <<- sapply(which(sapply(strsplit(changexindexvec, split=","), as.numeric) != 0)-1, as.character)
  if(length(xindexvec) == 0)
    warning("length(indexvec) == 0")
  print(xindexvec)
}

#* @param newdata monitored es index vec
#* @post /changeindexvecworker
function(newdata){
  indexvecdataworker <<- newdata
  #print(indexvec)
  indexvec <<- sapply(which(sapply(strsplit(indexvecdataworker, split=","), as.numeric) != 0)-1, as.character)
  if(length(indexvec) == 0)
    warning("length(indexvec) == 0")
  print(indexvec)
}

#* @param newdata data for the file
#* @get /changedataget
function(newdata){
  data <<- newdata
}

#* @get /getdata
function(){
  data
}

#* @get /findnoisycacheset
find_noise_es <- function() {
  tbl <- data.table::fread(data)
  find_noise_es_gen(tbl, 32)
}


#* @png (width=1500,height=750)
#* @param selected_x select range e.g. 1:10
#* @get /plotdata
visualize_times <- function(selected_x){
a <- Sys.time()
  #x-axis eviction sets, y-axis samples
  tbl <- data.table::fread(data)
  if(dataworker != ""){
    tblworker <- data.table::fread(dataworker)
    
    dataworker <- ""
  }
  if(ncol(tbl)*nrow(tbl) > 1000000){
    warning("tbl to big!")
    return(0)
  }
  find_noise_es_gen(tbl)
  
  print(selected_x)
  
  es_vec <- "none"
  if(grepl(":", selected_x)){
    es_vec <- strsplit(selected_x,":")[[1]][1]:strsplit(selected_x,":")[[1]][2]
  } else if(grepl(",", selected_x)){
    es_vec <- as.numeric(strsplit(selected_x, ",")[[1]])
  } else {
    selected_x <- as.numeric(selected_x)
    if(!is.na(selected_x) && selected_x <= ncol(tbl) && selected_x > 0){
      es_vec <- selected_x
    }
  }
  print(es_vec)
  
  #if(es_vec != "none")
  #  tbl <- tbl[,es_vec, drop=F]
  
  #tbl <- tbl[-(1:15000),]
  tbl <- tbl[-(1:50),]
  
  if(es_vec != "none")
    tbl <- tbl[es_vec,]
  
  #tbl <- tbl[-(nrow(tbl)-10:nrow(tbl)),]
  colnames(tbl) <- indexvec
  tmp_tbl <<- tbl
  tbl_melt <- reshape2::melt(tbl)
  tbl_melt[["sample"]] <- rep(1:nrow(tbl), ncol(tbl))
  colnames(tbl_melt)[1] <- "es"
  #cap at 3500
  max_value <- 1000
  tbl_melt[tbl_melt$value>max_value,"value"] <- max_value
  b <- Sys.time()
  print(b-a)
  
  plot <- ggplot2::ggplot(tbl_melt, ggplot2::aes(x=sample,y=es)) + 
    ggplot2::geom_tile(ggplot2::aes(fill = value)) +
    ggplot2::scale_fill_gradientn(colours = RColorBrewer::brewer.pal( 6, "Blues"), limits = c(100, NA), na.value = "white")
  c <- Sys.time()
  print(c-b)
  e <- print(plot)
  d <- Sys.time()
  print(d-c)
  return(e)
}


find_noise_es_gen <- function(tbl, group_size = 32) {
  mean_vec <- apply(tbl, 2, mean)
  mean_vec_groups <- unlist(lapply(split(mean_vec, ceiling(seq_along(mean_vec)/group_size)), mean))
  noise_es_index <- match(max(mean_vec_groups), mean_vec_groups)
  print(paste0("es ", noise_es_index, " from ", (noise_es_index-1)*group_size, " to ", noise_es_index*group_size-1))
  return((noise_es_index-1)*group_size)
}

source("find_es.R")

#* @get /identifybits
function(){
  tbl <- data.table::fread(data)
  print(paste0("median:", median(tbl[[1]])))
  return(0)
  bitstr_list <<- identify_bits(tbl)
  info_str <- compare_bitstr_list(bitstr_list, default_bitstr)
  #return(bitstr_list)
  return(info_str)
}
#13.3 kilobit
#3.4*10^9/13300 = 2556391 per 10 bits
#10 * c + 10 * r * prime + y * prime
#prime = 400
#10 * c + 4000 + 8000

#* @png (width=1300,height=950)
#* @get /printbits
printbits <- function(){
  tbl <- data.table::fread(data)
  #use median cause there are more untouched samples
  median_vec <- apply(tbl, 2, median)
  #threshold
  threshold <- 2 * median_vec
  bit_on_vec <- data.frame(apply(tbl, 2, function(vec) vec > threshold))

  
  return(plot(bit_on_vec[50:nrow(bit_on_vec),1]))
}

source("smoothed_z-score_algo.R")

#* @png (width=1920,height=500)
#* @get /plotchannel
plotchannel <- function(){
  tbl <- data.table::fread(data)
  if(ncol(tbl) == 1){
    #tbl[,"sample"] <- 1:nrow(tbl)
    max_value <- 1000
    tbl[tbl$V1>max_value, "V1"] <- max_value
    #plot <- ggplot2::ggplot(tbl, ggplot2::aes(x = sample, y = V1)) + ggplot2::geom_histogram(stat = "identity")
    #print(plot)
    
    y <- tbl[[1]][(length(tbl[[1]])*0.2):(length(tbl[[1]])-10)]
    y <- mean_smooth(y)
    print(y)
    return(plot_smoothed_z_score(y))
  }
}

