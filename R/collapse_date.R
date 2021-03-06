#' Collapses a data.frame of word counts by date
#' 
#' Takes a table of word counts (produced by extract_commits and then modified by add_word_counts_table) and collapses the word counts by date.
#' 
#' @param commit.table Data.frame of commits (e.g. produced by drop_interday).
#' @param range Numeric vector of two elements that specifies the upper/lower bounds of word counts. Anything outside this range is considered an outlier and is dropped.
#' @return A data.frame containing dates and the corresponding counts for new words, deleted words, and net additions.
#' @examples 
#' a <- extract_commits(repo="~/repositories/project/")
#' a <- add_word_counts_table(a,repo="~/repositories/project/")
#' b <- collapse_date(a)

collapse_date <- function(commit.table,range=c(-4000,10000)){
  # Collapses each of the individual columns by date, resulting in 3 matrices.
  new.words <- tapply(commit.table[,3],as.Date(commit.table$Date),sum, na.rm = TRUE)
  del.words <- tapply(commit.table[,4],as.Date(commit.table$Date),sum, na.rm = TRUE)
  net.words <- tapply(commit.table[,5],as.Date(commit.table$Date),sum, na.rm = TRUE)
  net.mods <- tapply(commit.table[,6],as.Date(commit.table$Date),sum, na.rm = TRUE)
  
  # Binds the resulting tapply'd columns into a new matrix. Also binds the
  # rownames (dates) into the matrix so these can be used later. Finally,
  # converts the matrix into a data.frame (the more natural object for use
  # with ggplot2 and outputing to csv formats.)
  words.matrix <- cbind(new.words,del.words,net.words,net.mods)
  words.matrix <- cbind(rownames(words.matrix),words.matrix)
  colnames(words.matrix) <- c("Date","New Words","Deleted Words","Net Additions","Net Modifications")
  words.table <- as.data.frame(words.matrix)
  
  # Formats the columns of the new data.frame into data and numeric formats.
  # tapply breaks these formats, which is why we need this step.
  words.table[,1] <- as.Date(words.table$Date)
  words.table[,2] <- as.numeric(as.character(words.table[,2]))
  words.table[,3] <- as.numeric(as.character(words.table[,3]))
  words.table[,4] <- as.numeric(as.character(words.table[,4]))
  words.table[,5] <- as.numeric(as.character(words.table[,5]))
  
  # Subsets the table to remove outliers (defined as excessively large numbers of net additions)
  words.table <- words.table[words.table[,4] > range[1] & words.table[,4] < range[2],]
  
  # Deletes the top entry, which has NA values.

  first_row_has_nas <- any(is.na(words.table[-1, ]))

  if(first_row_has_nas){
      words.table <- words.table[-1,]
  }

  # Returns the modified table.
  return(words.table)
}