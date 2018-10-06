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


ggplot2::ggplot(df_melt, aes(value)) + ggplot2::geom_density()
ggplot2::scale_x_continuous(name="Anzahl an Adressen im Pool (x)", 
                            limits=c(2048, 5000), 
                            breaks=c(seq(2500,5000,500)))
