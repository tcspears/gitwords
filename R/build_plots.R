#' Builds plots of net additions
#' 
#' @param Data.frame of word counts for each date (produced by collapse_date)
#' @param cols (optional) Numeric indicating the number of columns in the resulting plot
#' @param metric (optional) Character string indicating which word count measure should be plotted. Acceptable options are "net", "new", or "deleted".
#' @return A multiplot containing (a) net additions as a function of time, and (b) a density histogram of net additions. 
#' @examples
#' a <- extract_commits(repo="~/repositories/project/")
#' a <- add_word_counts_table(a,repo="~/repositories/project/")
#' b <- collapse_date(a)
#' build_plots(b)

build_plots <- function(words.table,metric="net",cols=1){
  
  # This addresses a very stupid bug in ggplot2: that it cannot make reference
  # to local vars (i.e. words.table).
  .e <- environment()
  
  # Loads ggplot2 for making plots.
  library(ggplot2)
  
  # Builds the plots, depending on the choice of metric.
  if(metric=="new"){
    p1 <- ggplot(data=words.table, aes(x=words.table[,1], y=words.table[,2]),environment=.e) + geom_point() + geom_smooth() + labs(title="New words per day, excluding outliers",x="Date",y="Word count")
    p2 <- qplot(words.table[,2],geom="blank",main="New words per day, excluding outliers",xlab="Word count",environment=.e) +
      geom_line(aes(y = ..density..,colour = "Observed"), stat="density") +
      geom_histogram(aes(y = ..density..), alpha=0.4) +
      scale_colour_manual(name = 'Density', values = c('red', 'blue')) +
      theme(legend.position="none")
  } else if(metric=="deleted"){
    p1 <- ggplot(data=words.table, aes(x=words.table[,1], y=words.table[,3]),environment=.e) + geom_point() + geom_smooth() + labs(title="Deleted words per day, excluding outliers",x="Date",y="Word count")
    p2 <- qplot(words.table[,4],geom="blank",main="Deleted words per day, excluding outliers",xlab="Word count",environment=.e) +
      geom_line(aes(y = ..density..,colour = "Observed"), stat="density") +
      geom_histogram(aes(y = ..density..), alpha=0.4) +
      scale_colour_manual(name = 'Density', values = c('red', 'blue')) +
      theme(legend.position="none")
  } else if(metric=="net"){
    p1 <- ggplot(data=words.table, aes(x=words.table[,1], y=words.table[,4]),environment=.e) + geom_point() + geom_smooth() + labs(title="Net additions per day, excluding outliers",x="Date",y="Word count")
    p2 <- qplot(words.table[,4],geom="blank",main="Net additions per day, excluding outliers",xlab="Word count",environment=.e) +
      geom_line(aes(y = ..density..,colour = "Observed"), stat="density") +
      geom_histogram(aes(y = ..density..), alpha=0.4) +
      scale_colour_manual(name = 'Density', values = c('red', 'blue')) +
      theme(legend.position="none")
  } else {
    stop("Invalid metric")
  }

  # Plots the plots using multiplot.
  multiplot(p1,p2,cols=cols)
}