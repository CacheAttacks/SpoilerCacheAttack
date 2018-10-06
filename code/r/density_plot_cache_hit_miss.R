setwd("~")
filename <- "miss.txt"
miss <- (sapply(strsplit(readChar(filename, file.info(filename)$size), " "), as.numeric))
filename <- "hit.txt"
hit <- (sapply(strsplit(readChar(filename, file.info(filename)$size), " "), as.numeric))

set.seed(42)
hit <- sample(hit,1000)
miss <- sample(miss,1000)
df <- data.frame("Hit"=hit,"Miss"=miss)
df_melt <- reshape::melt(df)

ggplot2TikzPlot <- function(name, ggplot, width = 6, height = 4){
  require( tikzDevice )
  tikz( name,  width = width, height = height)
  print(ggplot)
  dev.off()
}


plot <- ggplot2::ggplot(df_melt, aes(value)) + ggplot2::geom_density() +
ggplot2::scale_x_continuous(name="Zugriffszeit in Taktzyklen", 
                            limits=c(0, 350), 
                            breaks=c(seq(0,350,50)))+
ggplot2::scale_y_continuous(name="Wahrscheinlichkeit") 

ggplot2TikzPlot("cache_hit_miss_density.tex", plot)
