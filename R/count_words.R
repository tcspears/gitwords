#' Counts the number of new and deleted words between two git commits
#' 
#' Calls git diff from the shell in porcelain mode to calculate the number of new and deleted words between two commits.
#' 
#' @param commit_old Character string giving the previous commit ID
#' @param commit_new Character string giving the current commit ID
#' @param repo Character string giving the relative or absolute path to the git repository.
#' @return List containing two elements: number of new words, and number of deleted words.
#' @examples
#' count_words(commit_old="35c964f569ce26ab2a9b35469252730c854e6cb2",commit_new="849b280bccd4e3b294bc4a8a67f9f80184009edf",repo="~/repositories/project/")

count_words <- function(commit_old,commit_new,repo){
  setwd(repo)
  
  # This runs git diff in porcelain mode, and then saves the output as a
  # character vector 'a'.
  a <- system(paste(git.location," ",commit_old,"..",commit_new," --word-diff=porcelain",sep=""),intern=TRUE)
  
  # Next we loop through each element of a. If the element begins with "+",
  # then we count the number of words in that line and that number to new_words.
  # If the element begins with "-", then we count the number of words in that
  # line and add that number to del_words.
  new_words <- 0
  del_words <- 0
  for(i in seq(1,length(a))){
    if(substr(a[i],1,1)=="+"){
      # Words are defined using the regular expression '\\W+'. 
      new_words <- new_words + sapply(gregexpr("\\W+", substr(a[i],2,nchar(a[i],allowNA=TRUE))), length)
    } else if(substr(a[i],1,1)=="-"){
      del_words <- del_words + sapply(gregexpr("\\W+", substr(a[i],2,nchar(a[i],allowNA=TRUE))), length)
    }
  }
  
  # Returns a list containing two elements: new words and deleted words.
  return(list("New Words"=new_words,"Deleted Words"=del_words))
}
