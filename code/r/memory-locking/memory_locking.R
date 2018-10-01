setwd("~/MA_2/master-moritz_krebbel-drive_by_cache_attacks/code/r/memory-locking/")
load("data.RData")
noattack <- no_attack #for ggplot2TikzPlot

ggplot2TikzPlot <- function(name, ggplot, width = 6, height = 3.3){
  require( tikzDevice )
  tikz( name,  width = width, height = height)
  print(ggplot)
  dev.off()
}

#plot_access_times_memory_blocking <- function(no_attack, attack){

tbl <- cbind(noattack,attack)
colnames(tbl) <- c("kein Memory-Locking","Memory-Locking")
tbl <- tbl[1:50,]

tbl_melt <- reshape2::melt(tbl)

tbl_melt[["sample"]] <- rep(1:nrow(tbl), ncol(tbl))
colnames(tbl_melt)[1] <- "es"
colnames(tbl_melt)[2:3] <- c("Zugriffszeit","Sample")

#max_value <- 5000
#tbl_melt[tbl_melt$value>max_value,"value"] <- max_value

plot <- 
  ggplot2::ggplot(tbl_melt, ggplot2::aes(x=Sample,y=es)) + 
  ggplot2::geom_tile(ggplot2::aes(fill = Zugriffszeit)) +
  ggplot2::scale_fill_gradientn(colours = RColorBrewer::brewer.pal( 6, "Greys"), limits = c(100, NA), na.value = "white") +
  ggplot2::ylab("") +
    ggplot2::theme(axis.text.y = ggplot2::element_text(angle = 90, hjust = 0.5))

ggplot2TikzPlot("plot_memory_locking_issues.tex", plot)
#}
  