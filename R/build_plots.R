#' Function to builds plots (called by the shell script)
#' 
#' @param date (optional) character vector of dates, can either be of length 1, 2, or left unspecified. If length(date)==1, then the plots will include all commits from that day until the latest commit. If length(date)==2, then date will be treated as a range, and the plot will include all commits within that range. If date is left unspecified, then the plot will include all commits in the repository.
#' @param repo (optional) character string giving the relative or absolute path to the git repository. If left unspecified, the current working directory will be used as the repo.
#' @param tofile (optional) logical specifying whether the plot should be written to a pdf file (instead of displayed interactively)
#' @examples
#' build_plots()
#' build_plots(date="2015-01-01")
#' build_plots(date="2015-01-01",repo="~/repositories/project/")
#' build_plots(date=c("2015-01-01","2015-02-20"))
#' build_plots(date=c("2015-01-01","2015-02-20"),repo="~/repositories/project/")

build_plots <- function(date=NULL,repo=getwd(),tofile=FALSE){
  a <- extract_commits(repo)
  b <- NULL
  if(is.null(date)){
    b <- a
  } else if(length(date)==1){
    upper.date <- as.character(as.Date(a[order(as.Date(a$Date),decreasing=TRUE),][1,2]))
    lower.date <- date
    b <- subset_commits_date(commit.table=a,date=c(lower.date,upper.date))
  } else {
    b <- subset_commits_date(commit.table=a,date=date)
  }
  c <- add_word_counts_table(b,repo)
  d <- collapse_date(c)
  if(tofile==FALSE){
    plot_words(d)
  } else {
    if(substr(repo,nchar(repo),nchar(repo))=="/"){
      pdf(file=paste(repo,"wordplot.pdf",sep=""))
      plot_words(d)
      dev.off()
      cat("Plot saved as wordplot.pdf within ",repo,"\n")
    } else {
      pdf(file=paste(repo,"/wordplot.pdf",sep=""))
      plot_words(d)
      dev.off()
      cat("Plot saved as wordplot.pdf within ",repo,"\n")
    }
  }
}