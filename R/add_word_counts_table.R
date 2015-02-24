#' Adds word counts to a data.frame of commits.
#' @param commit.table Data.frame of commits, produced by extract_commits.
#' @param repo Character string giving the relative or absolute path to the git repository.
#' @return Updated data.frame of commits with word counts as new columns.
#' @examples
#' a <- extract_commits(repo="~/repositories/project/")
#' a <- add_word_counts_table(a,repo="~/repositories/project/")

add_word_counts_table <- function(commit.table,repo){
  
  # The loop words by calling count_words for each line i of the table using
  # as input the commit ID from the i+1 line (previous commit) and the i line
  # (new commit). The two elements of the list returned by count_words are then
  # assigned to the 3rd and 4th column. The fifth column is then computed as the
  # difference between these two.
  
  for(i in seq(1,length(commit.table[,1])-1)){
    counts <- count_words(commit.table[i+1,1],commit.table[i,1],repo)
    commit.table[i,3] <- counts[[1]]
    commit.table[i,4] <- counts[[2]]
    commit.table[i,5] <- commit.table[i,3] - commit.table[i,4]
    commit.table[i,6] <- commit.table[i,3] + commit.table[i,4]
  }
  # Adds names to the new columns (to make them prettier).
  colnames(commit.table)[3:6] <- c("New Words","Deleted Words","Net Additions","Net Modifications")
  
  # Returns the modified table.
  return(commit.table)
}