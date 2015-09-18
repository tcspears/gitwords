#' Extracts a table of commits and dates/times from a git log
#' 
#' @param repo Character string giving the relative or absolute path to the git repository.
#' @return data.frame containing (a) a column of commits and (b) a column of dates/times in POSIXct format.
#' @examples
#' extract_commits(repo="~/repositories/project/")

extract_commits <- function(repo){

  # Set working directory to repo and store current working directory location
  # Note: This is really a horrible practice because it entails modifying a 
  # global environmental variable, but I can't figure out a way to pass a 
  # specific location to git grep.
  
  old.location <- getwd()
  setwd(repo)
  
  # Calls git log using the shell and assigns the output to a character vector
  a <- system("git log",intern=TRUE)
  
  # This part extracts a table of commits and dates/times.
  # Does this by looking for lines beginning with 'commit' and
  # then reading in the next 40 lines after a space as the commit
  # ID, and then two lines down to extract the date. Note that this
  # function might need to be updated if git ever changes their git
  # log format. Note that the below might break easily if git log ever 
  # changes its date format.
  table <- data.frame()
  table.count <- 1
  for(i in seq(1,length(a))){
    if(substr(a[i],1,6)=="commit"){
      table[table.count,1] <- substr(a[i],8,47)
      table[table.count,2] <- substr(a[i+2],9,38)
      table.count <- table.count + 1
    }
  }
  colnames(table) <- c("Commit","Date")
  
  # Formats the date string as a POSIXct variable
  table[,2] <- as.POSIXct(substr(table[,2],1,nchar(table[,2])),format="%a %b %d %H:%M:%S %Y %z")
  
  # Reset working directory to old.location and return the modified table
  setwd(old.location)
  return(table)
}