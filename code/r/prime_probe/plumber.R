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

#* @param newdata data for the file
#* @post /changedata
function(newdata){
  data <<- newdata
  print(newdata)
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


#* @png (width=1300,height=950)
#* @param selected_es select range e.g. 1:10
#* @get /plotdata
visualize_times <- function(selected_es){
a <- Sys.time()
  #x-axis eviction sets, y-axis samples
  tbl <- data.table::fread(data)
  if(ncol(tbl)*nrow(tbl) > 1000000){
    warning("tbl to big!")
    return(0)
  }
  find_noise_es_gen(tbl)
  
  print(selected_es)
  
  es_vec <- "none"
  if(grepl(":", selected_es)){
    es_vec <- strsplit(selected_es,":")[[1]][1]:strsplit(selected_es,":")[[1]][2]
  } else if(grepl(",", selected_es)){
    es_vec <- as.numeric(strsplit(selected_es, ",")[[1]])
  } else {
    selected_es <- as.numeric(selected_es)
    if(!is.na(selected_es) && selected_es <= ncol(tbl) && selected_es > 0){
      es_vec <- selected_es
    }
  }
  print(es_vec)
  
  if(es_vec != "none")
    tbl <- tbl[,es_vec, drop=F]
  
  tmp_tbl <<- tbl
  tbl_melt <- reshape2::melt(tbl)
  tbl_melt[["sample"]] <- rep(1:nrow(tbl), ncol(tbl))
  colnames(tbl_melt)[1] <- "es"
  #cap at 3500
  max_value <- 750
  tbl_melt[tbl_melt$value>max_value,"value"] <- max_value
  b <- Sys.time()
  print(b-a)
  
  plot <- ggplot2::ggplot(tbl_melt, ggplot2::aes(x=sample,y=es)) + 
    ggplot2::geom_tile(ggplot2::aes(fill = value)) +
    ggplot2::scale_fill_gradient(low = "white", high = "steelblue")
  c <- Sys.time()
  print(c-b)
  e <- print(plot)
  d <- Sys.time()
  print(d-c)
  e
}


find_noise_es_gen <- function(tbl, group_size = 32) {
  mean_vec <- apply(tbl, 2, mean)
  mean_vec_groups <- unlist(lapply(split(mean_vec, ceiling(seq_along(mean_vec)/group_size)), mean))
  noise_es_index <- match(max(mean_vec_groups), mean_vec_groups)
  print(paste0("es ", noise_es_index, " from ", (noise_es_index-1)*group_size, " to ", noise_es_index*group_size-1))
  return((noise_es_index-1)*group_size)
}