#' Grep a Git Repository
#' 
#' Searches an entire git repository (including all previous commits) for a particular expression, and then returns the results after dropping duplicate outputs.
#' 
#' @param expression A regular expression
#' @param repo (optional) The location of a git repository (defaults to the current working directory)
#' @return A character vector of results.

grep_repo <- function(expression,repo=getwd()){
  a <- system(paste(git.location," grep ","\'",expression,"\' ","$(git rev-list --all)",sep=""),intern=TRUE)
  b <- substr(a,42,nchar(a))
  dup <- duplicated(b)
  c <- b[!dup]
  return(c)
}