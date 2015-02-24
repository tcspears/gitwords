#' Builds plots of net additions
#' 
#' @param Data.frame of word counts for each date (produced by collapse_date)
#' @param metric (optional) Character string indicating which word count measure should be plotted. Acceptable options are "net" (net additions and modifications) and "nd" (new and deleted)
#' @return A multiplot containing line graphs and density histograms of the chosen metric.. 
#' @examples
#' a <- extract_commits(repo="~/repositories/project/")
#' a <- add_word_counts_table(a,repo="~/repositories/project/")
#' b <- collapse_date(a)
#' build_plots(b)

build_plots <- function(words.table,metric="net"){
  
  # This addresses a very stupid bug in ggplot2: that it cannot make reference
  # to local vars (i.e. words.table).
  .e <- environment()
  
  # Loads ggplot2 for making plots.
  library(ggplot2)
  
  # Grabs data for weekly summaries
  
  weekly <- weekly_stats(words.table)
  
  # Converts weekly summaries into a data.frame so that it can be used by ggplot2
  
  weekly.df <- as.data.frame(t(weekly))
  weekly.df$Weekday <- rownames(weekly.df)
  
  weekly.df <- reshape(weekly.df, 
                       varying = c("Net Additions (median)", "Net Modifications (median)"), 
                       v.names = "count",
                       timevar = "metric", 
                       times = c("Net Additions (median)", "Net Modifications (median)"), 
                       direction = "long")
  
  weekly.df$Weekday <- factor(weekly.df$Weekday,levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"),labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))
  weekly.df$metric <- factor(weekly.df$metric,levels=c("Net Additions (median)","Net Modifications (median)"))
  
  # Builds the plots, depending on the choice of metric.
  if(metric=="nd"){
    p2 <- ggplot(data=words.table, aes(x=words.table[,1], y=words.table[,2]),environment=.e) + geom_point() + geom_smooth() + labs(title="New words per day, excluding outliers",x="Date",y="Word count")
    p1 <- qplot(words.table[,2],geom="blank",main="New words per day, excluding outliers",xlab="Word count",environment=.e) +
      geom_line(aes(y = ..density..,colour = "Observed"), stat="density") +
      geom_histogram(aes(y = ..density..), alpha=0.4) +
      scale_colour_manual(name = 'Density', values = c('red', 'blue')) +
      theme(legend.position="none")
    p4 <- ggplot(data=words.table, aes(x=words.table[,1], y=words.table[,3]),environment=.e) + geom_point() + geom_smooth() + labs(title="Deleted words per day, excluding outliers",x="Date",y="Word count")
    p3 <- qplot(words.table[,4],geom="blank",main="Deleted words per day, excluding outliers",xlab="Word count",environment=.e) +
      geom_line(aes(y = ..density..,colour = "Observed"), stat="density") +
      geom_histogram(aes(y = ..density..), alpha=0.4) +
      scale_colour_manual(name = 'Density', values = c('red', 'blue')) +
      theme(legend.position="none")
    multiplot(p1,p2,p3,p4,cols=2)  
  } else if(metric=="net"){
    p1 <- qplot(words.table[,4],geom="blank",main="Net additions per day",xlab="Word count",environment=.e) +
      geom_line(aes(y = ..density..,colour = "Observed"), stat="density") +
      geom_histogram(aes(y = ..density..), alpha=0.4) +
      scale_colour_manual(name = 'Density', values = c('red', 'blue')) +
      theme(legend.position="none")
    p2 <- ggplot(data=words.table, aes(x=words.table[,1], y=words.table[,4]),environment=.e) + geom_point() + geom_smooth() + labs(x="Date",y="Word count")
    p3 <- ggplot(data=weekly.df[weekly.df$metric=="Net Additions (median)",],aes(x=Weekday, y=count))+geom_bar(stat="identity")+labs(x="Weekday",y="Word count")
    p4 <- qplot(words.table[,5],geom="blank",main="Net modifications per day",xlab="Word count",environment=.e) +
      geom_line(aes(y = ..density..,colour = "Observed"), stat="density") +
      geom_histogram(aes(y = ..density..), alpha=0.4) +
      scale_colour_manual(name = 'Density', values = c('red', 'blue')) +
      theme(legend.position="none")
    p5 <- ggplot(data=words.table, aes(x=words.table[,1], y=words.table[,5]),environment=.e) + geom_point() + geom_smooth() + labs(x="Date",y="Word count")
    p6 <- ggplot(data=weekly.df[weekly.df$metric=="Net Modifications (median)",],aes(x=Weekday, y=count))+geom_bar(stat="identity")+labs(x="Weekday",y="Word count")
    multiplot(p1,p2,p3,p4,p5,p6,cols=2)
  } else {
    stop("Invalid metric")
  }  
}