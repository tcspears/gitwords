#' Subsets a commit.table to a specific range of dates.
#' 
#' @param commit.table Data.frame of commits, produced by extract_commits.
#' @param date Character vector of dates. Can either be a single date, or a pair of dates representing a range.
#' @return A data.frame of commits that is a subset of the original data.frame.
#' @examples
#' a <- extract_commits(repo="~/repositories/project/")
#' b <- subset_commits_date(a,date=c("2015-01-01","2015-02-20"))
#' c <- subset_commits_date(a,date="2015-01-01")

subset_commits_date <- function(commit.table,date){
  subset.table <- NULL
  if(length(date)==2){
    subset.table <- commit.table[as.Date(commit.table$Date) %in% t(seq(as.Date(date[1]),as.Date(date[2]),1)),]
    if(length(subset.table[,1]) == 0){
      stop(paste("No commits between ",date[1]," and ",date[2],sep=""))
    }
  } else if(length(date)==1){
    subset.table <- commit.table[as.Date(commit.table$Date)==date,]
    if(length(subset.table[,1]) == 0){
      stop(paste("No commits on ",date,sep=""))
    }
  } else {
    stop("Invalid date specification")
  }
  return(subset.table)
}