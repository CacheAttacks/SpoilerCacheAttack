setwd("~/MA_2/master-moritz_krebbel-drive_by_cache_attacks/code/r/barplot_cache_hit_miss/")
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


plot <- ggplot2::ggplot(df_melt, ggplot2::aes(value)) + ggplot2::geom_bar(ggplot2::aes(y = (..count..)/sum(..count..))) +
ggplot2::scale_x_continuous(name="Zugriffszeit in Taktzyklen", 
                            limits=c(50, 260), 
                            breaks=c(seq(50,300,50)))+
ggplot2::scale_y_continuous(name="Wahrscheinlichkeit") 

ggplot2TikzPlot("cache_hit_miss_density.tex", plot)
