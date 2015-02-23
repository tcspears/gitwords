#' Get word counts for a date or a range of dates (called by the shell script)
#' 
#' @param date (optional) character vector of dates, can either be of length 1, 2, or left unspecified. If length(date)==1, then get_words returns the word counts for that particular day. If length(date)==2, then date will be treated as a range, and get_words will return all word counts for dates within that range. If date is left unspecified, then get_words will return the word counts for the current date.
#' @param repo (optional) character string giving the relative or absolute path to the git repository. If left unspecified, the current working directory will be used as the repo.
#' @return Data.frame of word counts for one date or a range of dates.
#' @examples
#' get_words()
#' get_words(date="2015-01-01")
#' get_words(date="2015-01-01",repo="~/repositories/project/")
#' get_words(date=c("2015-01-01","2015-02-20"))
#' get_words(date=c("2015-01-01","2015-02-20"),repo="~/repositories/project/")

get_words <- function(date=Sys.Date(),repo=getwd()){
  a <- extract_commits(repo)
  a <- drop_interday(a)
  b <- subset_commits_date(a,date)
  
  # Note: the ugly looking subsetting procedure to form 'c' takes the rownames of b, sorts them in decreasing order, extracts the first 
  # element, and then adds 1 onto it. (We need to do this in order to get the last commit on 'a' before the beginning
  # of the date interval in order to calculate word counts. After it extracts this, it binds the element of a corresponding to 
  # this row number to the matrix b.
    
  c <- rbind(b,a[rownames(a)==head(as.numeric(rownames(b))[order(as.numeric(rownames(b)),decreasing=TRUE)],n=1)+1,])
  d <- add_word_counts_table(c,repo)
  e <- collapse_date(d)
  rownames(e) <- NULL
  return(e)
}