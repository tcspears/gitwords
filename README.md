# gitwords
Tools for tracking word counts of commits made to git repositories

## Description
gitwords provides a series of functions for counting, summarising, and plotting the number of words committed to a git repository over time. It is intended to be used by writers — PhD students, academics, etc. — who use git as a version control system for their writing projects. 

As a PhD student, I found git to be an indispensable tool for keeping track of various versions of my thesis chapters. But I was disappointed by the lack of available tools within git for tracking my writing progress on a day-to-day basis. Indeed, git was designed for software developers rather than writers. While git includes some functionality to track the number of lines of code committed to a repository, ‘lines of code’ is a fairly useless measure of productivity for writers. Word counts certainly aren’t perfect (and can be easily gamed), but at least they help you get a sense of your writing productivity over time.

gitwords includes three main functions that can help you keep track of your writing progress:
* `get_words()`: calculates word counts of commits made to a git repository for a date or a range of dates.
* `word_stats()`: calculates summary statistics (mean, median, standard deviation, minimum, maximum) of the daily word counts made to a git repository for a range of dates. Dates where no commits are made are not included, so technically these stats represent the conditional mean/median/etc given that you write on a that day.
* `plot_words()`: Builds a series of plots (histogram, line graph with logical regression line) of daily word counts committed to a git repository.

gitwords is written in R to take advantage of R’s plotting functionality (and in particular, within the ggplot2 package), but you can also access it from the command line / shell / Terminal, in the same way as you would access git itself. 

### How just how does this thing work?

git includes a convenient tool called diff, which allows you to create a document that shows the words that were added and deleted between two commits. For instance, suppose that yesterday, you wrote:

```
The quick brown fox jumped over the lazy dog.
```
and committed it to a git repository. Today, you change the above text to:
```
The slow red fox jumped over the lazy cat.
``` 
Running git-diff will produce a text document that looks like this:
```
~ The
  - quick brown
  + slow red
~ fox jumped over the lazy
  - dog
  + cat 
```

## Usage

### Within R

I have included a RMarkDown document that demonstrates how to use these functions within R. You can view an HTML version of the output of that document [here](http://htmlpreview.github.io/?https://github.com/tcspears/gitwords/blob/master/EXAMPLES.html). You can also read the package documentation within R to see the complete syntax for the functions. 

### Within the command line / terminal

Using the gitwords functions from the command line is also easy, although the syntax changes a bit when you provide parameters to these scripts. It is easiest to see how by way of example:

For instance,
```
> get_words(date=“2015-01-01”,repo=“~/Dropbox/Repositories/Thesis”)
```
becomes:
```
$ get_words “2015-01-01” “~/Dropbox/Repositories/Thesis”
```
whereas
```
> get_words(date=c(“2015-01-01”,”2015-02-02),repo=“~/Dropbox/Repositories/Thesis”)
```
becomes:
```
$ get_words “2015-01-01” “2015-02-02” “~/Dropbox/Repositories/Thesis”
```

### How this fits into my workflow:



## Requirements
* git. See [here](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for more information.
* A working R installation. See [here](http://www.r-project.org/). 
* Within R, you will also need to install the following packages (all of which are available on CRAN via the `install.packages()` function within R):
  * ggplot2 for producing pretty plots
  * devtools (optional), to install the package from this github repository.

## Installing gitwords
The easiest way to install gitwords is to use the `install_github()` function in the devtools package to install it directly from this github repository.

If you do not have devtools installed already, then open up an R session and run:
```
> install.packages("devtools")
```
Once devotees has been installed, load it into R:
```
> library("devtools")
```
Finally, to install the gitwords package, run the following in R:
```
> install_github('gitwords','tcspears')
```
You should then be able to load it into memory using:
```
> library("gitwords")
```

### Installation of the shell scripts
I have also included three shell scripts to allow you to access  these functions from the terminal. To use these, you will need to follow the following steps.

#### Step 1:
First, download the three scripts -- `get_words`,`word_stats`, and `plot_words` from the [scripts directory](https://github.com/tcspears/gitwords/tree/master/scripts).

Next, we need to determine whether Rscript is installed in the standard location. Open up a terminal/shell and run:
```
$ /usr/bin/Rscript
```
If you get an error message like:
```
-bash: /usr/bin/Rscript: No such file or directory 
```
then you will need to do some detective work to determine where this program is located, and then edit the first line of each of the three scripts with this correct location. If instead of an error message you get a message that begins with the following, 
```
Usage: /path/to/Rscript [--options] [-e expr [-e expr2 ...] | file] [args]
```
then you are good to go, and can move on to the next step.

#### Step 2:

Next, you will need to make these files executable. Open up the terminal (in Mac OS X and Linux), navigate to the directory where these files are located, and type in the following
```
$ chmod +x get_words
$ chmod +x word_stats
$ chmod +x plot_words
```
If all works appropriately, then the terminal will not return any output.

#### Step 3:

Finally, copy the three files to ’/usr/local/bin’ so that you don’t have to specify the full path to these files each time you want to use them. (Alternatively, any directory listed in your terminal’s $PATH will be fine.) On unix based systems, this can be achieved by running:
```
$ sudo cp get_words /usr/local/bin/get_words
$ sudo cp word_stats /usr/local/bin/word_stats
$ sudo cp plot_words /usr/local/bin/plot_words
```
Unless you are running as root, you will need to supply the password to your user account to authorise these commands. But unless the commands have trouble executing, then the terminal will not return any output.



