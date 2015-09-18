#' Drops interday commits to prevent double counting.
#' 
#' @param commit.table Data.frame of commits, produced by extract_commits.
#' @return Data.frame of commits with interday entries removed.

drop_interday <- function(commit.table){
  commit.table <- commit.table[complete.cases(commit.table),]
  commit.table$index <- 0
  for(i in seq(1,length(unique(as.Date(commit.table$Date))))){
    commit.table[as.Date(commit.table$Date)==unique(as.Date(commit.table$Date))[i],]$index <- seq(1,length(commit.table[as.Date(commit.table$Date)==unique(as.Date(commit.table$Date))[i],1]))
  }
  commit.table$keep <- 0
  for(j in seq(1,length(commit.table[,1]))){
    if(commit.table$index[j]==1){
      commit.table$keep[j] <- 1
    } else if(commit.table$index[j]==head(order(commit.table[as.Date(commit.table$Date)==as.Date(commit.table$Date)[j],]$index,decreasing=TRUE),n=1)){
      commit.table$keep[j] <- 1
    } else {
      commit.table$keep[j] <- 0
    }
  }
  
  commit.table.subset <- commit.table[commit.table$keep==1,]
  commit.table.subset <- commit.table.subset[,-(3:4)]
  return(commit.table.subset)
}
