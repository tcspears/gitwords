#' Grep a Git Repository
#' 
#' Searches an entire git repository (including all previous commits) for a particular expression, and then returns the results after dropping duplicate outputs.
#' 
#' @param expression A regular expression
#' @param repo (optional) The location of a git repository (defaults to the current working directory)
#' @return A character vector of results.

grep_repo <- function(expression,repo=getwd()){
  # Grep entire repo for expression and then save output to 'a'
  a <- system(paste(git.location," grep ","\'",expression,"\' ","$(git rev-list --all)",sep=""),intern=TRUE)
  
  # Cut the git commit ID from output to enable comparison of duplicates
  b <- substr(a,42,nchar(a))
  
  # Identify and drop duplicates
  dup <- duplicated(b)
  c <- b[!dup]
  
  # Return output
  return(c)
}