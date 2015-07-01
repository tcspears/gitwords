# TODO

Add functionality to get_words that reports the percentile of a given day's word counts compared to the previous week, month, and across the whole commit. To be usable, this will require get_words to write the complete commit history (with word counts) to disk the first time it is run, and then load it each time thereafter.

Psuedo-code might be:

if(word count file exists){
 load the file
if(requested dates are in file){
 then return word counts at these dates
} else {
 calculate word counts for existing dates
 concatenate new word counts onto existing file
 save file
 return word counts for selected dates
}
} else {
 build the file from scratch
 save file to disk
 return word counts for selected dates.
}

Build a ‘bag of words’ model to examine whether the changes captured by net modifications are due to copying and pasting or due to actual deletions vs. additions. Such a function would construct two word bags, for new words and deleted words respectively, and then calculate their similarity according to some metric (possibly Euclidean?).
