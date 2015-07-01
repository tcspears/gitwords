#' Grep a Git Repository
#' 
#' Searches an entire git repository (including all previous commits) for a particular expression, and then returns the results after dropping duplicate outputs.
#' 
#' @param expression A regular expression
#' @param repo (optional) The location of a git repository (defaults to the current working directory)
#' @return A character vector of results.

grep_repo <- function(expression,repo=getwd()){
  # Set working directory to repo and store current working directory location
  # Note: This is really a horrible practice because it entails modifying a 
  # global environmental variable, but I can't figure out a way to pass a 
  # specific location to git grep.
  
  old.location <- getwd()
  setwd(repo)
  
  # Grep entire repo for expression and then save output to 'a'
  a <- system(paste(git.location," grep ","\'",expression,"\' ","$(git rev-list --all)",sep=""),intern=TRUE)
  
  # Cut the git commit ID from output to enable comparison of duplicates
  # Do this by subbing out everything before first colon (which corresponds to 
  # the commit id).
  b <- sub("^(.*?):","",a)
  
  # Identify and drop duplicates
  dup <- duplicated(b)
  out <- b[!dup]
  attributes(out)$repo <- repo
  
  # Reset working directory to old.location and return output
  setwd(old.location)
  return(out)
}