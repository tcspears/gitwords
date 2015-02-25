#' Function for calculating weekly statistics
#' @param Data.frame of word counts for each date (produced by collapse_date)
#' @return Matrix of weekly statistics

weekly_stats <- function(words.table){
  Weekday <- weekdays(as.POSIXlt(words.table$Date))
  Weekday <- factor(Weekday,levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"),labels=c("Mon","Tue","Wed","Thu","Fri","Sat","Sun"))
  weekly <- rbind(tapply(words.table[,4],Weekday,median),tapply(words.table[,5],Weekday,median))
  rownames(weekly) <- c("Net Additions","Net Modifications")
  return(weekly)
}
