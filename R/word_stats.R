#' Function to compute summary statistics (called by the shell script)
#' 
#' @param date (optional) character vector of dates, can either be of length 1, 2, or left unspecified. If length(date)==1, then the summary statistics will include all commits from that day until the latest commit. If length(date)==2, then date will be treated as a range, and the summary statistics will include all commits within that range. If date is left unspecified, then the summary statistics will include all commits in the repository.
#' @param repo (optional) repo (optional) character string giving the relative or absolute path to the git repository. If left unspecified, the current working directory will be used as the repo.
#' @param netOnly (optional) logical to specify whether only net additions/modifications should be reported. Set to TRUE by default
#' @return Matrix of summary statistics for word counts
#' @examples
#' word_stats()
#' word_stats(date="2015-01-01")
#' word_stats(date="2015-01-01",repo="~/repositories/project/")
#' word_stats(date=c("2015-01-01","2015-02-20"))
#' word_stats(date=c("2015-01-01","2015-02-20"),repo="~/repositories/project/")

word_stats <- function(date=NULL,repo=getwd(),netOnly=TRUE){
  a <- extract_commits(repo)
  a <- drop_interday(a)
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
  
  # Drops new and deleted words if netOnly is set to true
  if(netOnly==TRUE){
    d <- d[,-(2:3)]
  }
  
  Mean <- sapply(d[,-1], mean, na.rm=TRUE) 
  Median <- sapply(d[,-1], median, na.rm=TRUE) 
  StDev <- sapply(d[,-1], sd, na.rm=TRUE) 
  Min <- sapply(d[,-1], min, na.rm=TRUE) 
  Max <- sapply(d[,-1], max, na.rm=TRUE) 
  return(rbind(Mean,Median,StDev,Min,Max))
}