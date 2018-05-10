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
}

#* @param newdata data for the file
#* @get /changedataget
function(newdata){
  data <<- newdata
}

#* @get /plotdata
visualize_times <- function(){
  #x-axis eviction sets, y-axis samples
  tbl <<- read.table(text=data)
  #tbl <- tbl[,1:256]
  tbl_melt <<- reshape2::melt(tbl)
  tbl_melt[["sample"]] <<- rep(1:nrow(tbl), ncol(tbl))
  colnames(tbl_melt)[1] <<- "es"
  #cap at 3500
  max_value <- 2000
  tbl_melt[tbl_melt$value>max_value,"value"] <<- max_value
  
  plot <- ggplot2::ggplot(tbl_melt, ggplot2::aes(x=sample,y=es)) + 
    ggplot2::geom_tile(ggplot2::aes(fill = value)) +
    ggplot2::scale_fill_gradient(low = "white", high = "steelblue")
  print(plot)
}