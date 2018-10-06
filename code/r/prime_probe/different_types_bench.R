setwd("/home/619501/MA_2/master-moritz_krebbel-drive_by_cache_attacks/code/r/prime_probe/")


library(ggplot2)
library(grid)
library(dplyr)
library(lubridate)

#15313257125037569 0 -1 
#15313257125048364 10795 -1 
#15313257125058999 10635 -1 
#15313257125069589 10590 -1 
#15313257125080276 10687 0 
#15313257125091763 11487 -1 
#15313257125102474 10711 -1 
#15313257125113173 10699 0 
#15313257125124010 10837 -1 
#15313257125134682 10672 0 
#15313257125145586 10904 -1 
#15313257125156309 10723 -1 
#15313257125166953 10644 -1 
#15313257125177628 10675 -1 
#15313257125188269 10641 -1 
#15313257125198916 10647 0 
#15313257125209739 10823 -1 
#15313257125220386 10647 -1 
#15313257125231012 10626 0 
#15313257125241859 10847 -1 
#15313257125252515 10656 0 

generate_plot <- function(tbl, distance = 2, title = ""){
  colnames(tbl) <- c("Sub","Shift")
  tbl[,"Sub"] <- tbl[,"Sub"]/max(tbl[,"Sub"])*300
  tbl[,"Shift"] <- tbl[,"Shift"]/max(tbl[,"Shift"])*300
  tbl_melt <- reshape2::melt(tbl)
  tbl_melt[["sample"]] <- rep(1:nrow(tbl), ncol(tbl))
  
  #plot <- 
  ggplot2::ggplot(tbl_melt, ggplot2::aes(x=sample,y=variable)) + 
    ggplot2::geom_tile(ggplot2::aes(fill = value)) +
    ggplot2::scale_fill_gradientn(colours = RColorBrewer::brewer.pal( 6, "Greys"), 
                                  limits = c(100, NA), na.value = "white") + 
    #ggplot2::coord_flip() +
    ggtitle(title) +
    ggplot2::guides(fill=FALSE) +
    ggplot2::theme(axis.title.y=ggplot2::element_blank(),
                   axis.title.x=ggplot2::element_blank(),
                   #plot.margin=unit(c(5.5,40,5.5,5.5), "pt"),
                   plot.title = element_text(hjust = 0.5#,
                                             #margin = margin(t = 10, b = -5)
                                             )) + 
    ggplot2::scale_x_continuous(name="Sample (x)", 
                                limits=c(0, nrow(tbl)+1), 
                                breaks=c(seq(1,nrow(tbl),distance))) +
    theme(panel.background = element_blank())
  #ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90))
}

load("different_types.RData")

js_normal <- js_normal[47:143,]
wasm_normal <- wasm_normal[49:139,]
max_chase_9 <- max_chase_9[50:150,]
split2_wasm <- split2_wasm[36:178,]

load("real_5000.RData")
load("slowdown_test_s_mp_div_2d_0.RData")
tbl_both_10000 <- tbl_both_5000
tbl_both_5000 <- real_5000

tbl_both_5000 <- tbl_both_5000[13:56,]
js_normal <- tbl_both_10000[58:158,]


generate_plot(js_normal, 7, "aasd")

plot_js_normal <- generate_plot(js_normal,10,"Javascript")
plot_wasm_normal <- generate_plot(wasm_normal,10,"Wasm")
plot_max_chase_9 <- generate_plot(max_chase_9,10,"Wasm Max 9")
plot_split2_wasm <- generate_plot(split2_wasm,10,"Wasm Split")

grid.newpage()
grid.draw(rbind(ggplotGrob(plot_js_normal), ggplotGrob(plot_wasm_normal), 
                ggplotGrob(plot_split2_wasm),  
                size = "last"))


ggplot2TikzPlot <- function(name, ggplot, width = 6, height = 4){
  require( tikzDevice )
  tikz( name,  width = width, height = height)
  grid.newpage()
  grid.draw(cbind(ggplotGrob(plot_js_normal), ggplotGrob(plot_wasm_normal), 
                  ggplotGrob(plot_split2_wasm), 
                  size = "last"))
  dev.off()
}
ggplot2TikzPlot("plot_different_probe_types.tex", plot, 5.98, 4)
