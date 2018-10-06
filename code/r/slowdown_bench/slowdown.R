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
  tbl[tbl[,"Sub"]>300,"Sub"] <- 250
  tbl[tbl[,"Shift"]>300,"Shift"] <- 250
  tbl[,"Sub"] <- tbl[,"Sub"]/max(tbl[,"Sub"])*300
  tbl[,"Shift"] <- tbl[,"Shift"]/max(tbl[,"Shift"])*300
  tbl_melt <- reshape2::melt(tbl)
  tbl_melt[["sample"]] <- rep(1:nrow(tbl), ncol(tbl))
  
  #plot <- 
    ggplot2::ggplot(tbl_melt, ggplot2::aes(x=sample,y=variable)) + 
    ggplot2::geom_tile(ggplot2::aes(fill = value)) +
    ggplot2::scale_fill_gradientn(colours = RColorBrewer::brewer.pal( 6, "Greys"), 
                                  limits = c(100, NA), na.value = "white") + 
    ggplot2::coord_flip() +
      ggtitle(title) +
    ggplot2::guides(fill=FALSE) +
    ggplot2::theme(axis.title.y=ggplot2::element_blank(),
                   axis.title.x=ggplot2::element_blank(),
                   plot.title = element_text(hjust = 0.5,
                                             margin = margin(t = 10, b = -5))) + 
    ggplot2::scale_x_continuous(name="Sample (x)", 
                                limits=c(0, nrow(tbl)+1), 
                                breaks=c(seq(1,nrow(tbl),distance))) +
      theme(panel.background = element_blank())
    #ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90))
}

load("real_5000.RData")
load("slowdown_test_s_mp_div_2d_0.RData")

tbl_both_10000 <- tbl_both_5000
tbl_both_5000 <- real_5000

tbl_both_5000 <- tbl_both_5000[13:56,]
tbl_both_10000 <- tbl_both_10000[58:158,]
tbl_both_3000 <- tbl_both_3000[21:48,]
tbl_both_1000 <- tbl_both_1000[9:19,]
tbl_no_slowdown <- tbl_no_slowdown[18:24,]

tbl <- tbl_both_1000
tbl <- tbl_both_3000
tbl <- tbl_both_5000
tbl <- tbl_both_10000
tbl <- tbl_no_slowdown

load("split2_value.RData")

split2_p0 <- split2_p0[11:19,]
split2_p1000 <- split2_p1000[9:24,]
split2_p3000 <- split2_p3000[9:43,]
split2_p4000 <- split2_p4000[23:71,]
split2_p5000 <- split2_p5000[23:88,]

generate_plot(split2_p1000, 4, "aasd")

plot_split2_p0 <- generate_plot(split2_p0,1,"0")
plot_split2_p1000 <- generate_plot(split2_p1000,2,"1000")
plot_split2_p3000 <- generate_plot(split2_p3000,4,"3000")
plot_split2_p4000 <- generate_plot(split2_p4000,5,"4000")
plot_split2_p5000 <- generate_plot(split2_p5000,6,"5000")

  grid.newpage()
  grid.draw(cbind(ggplotGrob(plot_split2_p0), ggplotGrob(plot_split2_p1000), 
                ggplotGrob(plot_split2_p3000), ggplotGrob(plot_split2_p4000), 
                ggplotGrob(plot_split2_p5000),
                size = "last"))

ggplot2TikzPlot <- function(name, ggplot, width = 6, height = 4){
  require( tikzDevice )
  tikz( name,  width = width, height = height)
  grid.newpage()
  grid.draw(cbind(ggplotGrob(plot_split2_p0), ggplotGrob(plot_split2_p1000), 
                ggplotGrob(plot_split2_p3000), ggplotGrob(plot_split2_p4000), 
                ggplotGrob(plot_split2_p5000),
                size = "last"))
  dev.off()
}
ggplot2TikzPlot("plot_observe_shift_different_breaks_split2.tex", plot, 5.98, 4)






#----------------------------old---------------------------

plot_1000 <- generate_plot(tbl_both_1000,1,"1000")
plot_3000 <- generate_plot(tbl_both_3000,3,"3000")
plot_5000 <- generate_plot(tbl_both_5000,5,"5000")
plot_10000 <- generate_plot(tbl_both_10000,10,"10000")
plot_no_slowdown <- generate_plot(tbl_no_slowdown,1,"0")

grid.newpage()
grid.draw(cbind(ggplotGrob(plot_no_slowdown), ggplotGrob(plot_1000), 
                ggplotGrob(plot_3000), ggplotGrob(plot_5000), 
                ggplotGrob(plot_10000),
                size = "last"))


ggplot2TikzPlot <- function(name, ggplot, width = 6, height = 4){
  require( tikzDevice )
  tikz( name,  width = width, height = height)
  grid.newpage()
  grid.draw(cbind(ggplotGrob(plot_no_slowdown), ggplotGrob(plot_1000), 
                ggplotGrob(plot_3000), ggplotGrob(plot_5000), 
                ggplotGrob(plot_10000),
                size = "last"))
  dev.off()
}
ggplot2TikzPlot("plot_observe_shift_different_breaks.tex", plot, 5.98, 4)
