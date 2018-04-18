plot_res <- function(file_path, range = "all", width = "auto") {
  tbl_plot <- read.table(file_path)
  names(tbl_plot) <- c("(multiply)mpih−mul.c:85", "(square)mpih−mul.c:271", "(modulo)mpih−div.c:356")
  tbl_plot[,"timeslot"] <- factor(rownames(tbl_plot), levels = rownames(tbl_plot))
  
  if(class(range) != "character"){
    tbl_plot <- tbl_plot[range,]
  }
  if(width == "auto"){
    width <- nrow(tbl_plot)/10
  }
  
  for(i in 1:nrow(tbl_plot)){
    if(abs(tbl_plot[i,1]-tbl_plot[i,2]) < 5){
      tbl_plot[i,1] <- tbl_plot[i,1] -5
    }
    if(abs(tbl_plot[i,2]-tbl_plot[i,3]) < 5){
      tbl_plot[i,3] <- tbl_plot[i,3] -5
    }
    if(abs(tbl_plot[i,1]-tbl_plot[i,3]) < 5){
      tbl_plot[i,3] <- tbl_plot[i,3] -5
    }
  }
  
  ggplot2::ggplot(reshape2::melt(tbl_plot), ggplot2::aes(x=timeslot, y=value)) +
    ggplot2::geom_point(ggplot2::aes(colour=factor(variable))) +
    ggplot2::ylim(0,100) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1))
  ggplot2::ggsave(paste0("r_code/plots/",tail(strsplit(file_path, "/")[[1]], n=1), ".pdf"), width=width, limitsize=F)
}
