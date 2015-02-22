# gitwords
Tools for tracking word counts of commits made to git repositories

## Requirements
* git, as well as a git repository.
* R (preferably version 3.1.2)
* ggplot2 for producing plots
* The RScript package in R, if you would like to use the shell scripts.

## Installation
The easiest way to install gitwords is to use the install_github() function in the devtools package to install it directly from this github.

If you do not have devtools installed already, then run:
```
install.packages("devtools")
```
Once it has installed, load the devtools package into R:
```
library("devtools")
```
Finally, to install gitwords, run the following in R:
```
install_github('gitwords','tcspears')
```
You should then be able to load it into memory using:
```
library("gitwords")
```

### Installation of Shell Scripts
I have also included three shell scripts to allow you to run these functions from the terminal. To use these, you will need to follow the following steps.

First, download the three scripts -- `count-words`,`count-words-stats`, and `count-words-plot` -- and place them into a preferred directory on your computer.

Second, install the RScripts package into R using:
```
install.packages("devtools")
```
