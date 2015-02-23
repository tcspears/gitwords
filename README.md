# gitwords
Tools for tracking word counts of commits made to git repositories

## Requirements
* git
* R (preferably version 3.1.2 or higher). Within R, you will also need to install the following packages (all of which are available on CRAN):
  * ggplot2 for producing plots
  * devtools (optional), to install the package from this github repository.

## Installing gitwords
The easiest way to install gitwords is to use the `install_github()` function in the devtools package to install it directly from this github.

If you do not have devtools installed already, then run:
```
install.packages("devtools")
```
Once devotees has been installed, load it into R:
```
library("devtools")
```
Finally, to install the gitwords package, run the following in R:
```
install_github('gitwords','tcspears')
```
You should then be able to load it into memory using:
```
library("gitwords")
```

### Installation of the shell scripts
I have also included three shell scripts to allow you to access  these functions from the terminal. To use these, you will need to follow the following steps.

First, download the three scripts -- `count-words`,`count-words-stats`, and `count-words-plot`. 

Next, we need to determine whether RScript is installed in the standard location. Open up a terminal/shell and run:
```
$ /usr/bin/RScript
```
If you get an error message like:
```
-bash: /usr/bin/RScript: No such file or directory 
```
then you will need to do some detective work to determine where this program is located, and then edit the first line of each of the three scripts with this correct location. If instead of an error message you get a message that begins with the following, 
```
Usage: /path/to/Rscript [--options] [-e expr [-e expr2 ...] | file] [args]
```
then you can move on to the next step.

Next, copy the three files to ’/usr/local/bin’ so that you don’t have to specify the full path to these files each time you want to use them. Alternatively, any directory listed in your terminal’s $PATH will be fine. On unix based systems, this can be achieved by running:
```
sudo cp git-words /usr/local/bin/git-words
sudo cp git-words-stats /usr/local/bin/git-words-stats
sudo cp git-words-plot /usr/local/bin/git-words-plot
```
Unless you are running as root, you will need to supply the password to your user account to authorise these commands.

Next, you will need to make these files executable. Open up the terminal (in Mac OS X and Linux), and type in the following
```
chmod +x /usr/local/bin/count-words
chmod +x /usr/local/bin/count-words-stats
chmod +x /usr/local/bin/count-words-plot
```

Finally, if you chose 