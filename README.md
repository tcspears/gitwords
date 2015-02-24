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

### Just how does this thing work?

git includes a convenient tool called diff, which allows one to create a document that shows the words that were added and deleted between two commits. For instance, suppose that yesterday you wrote a document consisting of the following sentence:

```
The quick brown fox jumped over the lazy dog.
```
and committed this document to a git repository. Today, you change the document to read:
```
The slow red fox jumped over the lazy cat.
``` 
Running git-diff on these two commits will produce a text document that looks like this:
```
The
- quick brown
+ slow red
fox jumped over the lazy
- dog.
+ cat. 
```
The idea behind gitwords is that we can calculate the number of new words and deleted words in a document between any two commits by counting up the number of words on the lines beginning with ‘+’ and ‘-‘, respectively. For instance, in the above case, the number of new words would be 3, and the number of deleted words would also be 3. What gitwords does is sums up these three word counts for all of the commits made on each day in the git repository in order to calculate daily word counts.

gitwords is focussed on measuring two productivity metrics that are relevant to writers. The first is ‘net additions’, which roughly captures how much your writing project ‘grew’ in a particular day. It is defined as the difference between the number of new words and deleted words on a particular day:

net additions = new words - deleted words

In the above example, net additions will be equal to zero (3 words added, 3 words deleted.) Of course, a significant component of productive writing involves editing, so gitwords also measures ‘net modifications’, which is defined as the sum of new words and deleted words in a particular day:

net modifications = new words + deleted words

gitwords provides a number of functions for summarising and plotting these metrics by date, day of the week, etc. See the RMarkDown document (described below) to see it in action.

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

## Requirements
* git. See [here](http://git-scm.com/downloads) for more information.
* A working R installation. See [here](http://www.r-project.org/). 
* Within R, you will also need to install the ‘ggplot2’ package, which can be obtained by running `install.packages(“ggplot2”)’ within an R session.
* At the moment, gitwords only runs ‘out of the box’ on Mac OS X, Linux, or some variety of Unix. I expect that it is possible to make it work on Windows with only a small number of changes, but I don’t have a Windows machine so I haven’t done this yet.

## Installing gitwords

### Step 1:

To install gitwords, you will first need to ‘clone’ (i.e. download) this repository to your local computer with git. Do this by opening up the command line terminal and run:
```
$ git clone https://github.com/tcspears/gitwords gitwords
```
which will create a new directory on your computer called “gitwords” that contains all of the relevant code.

Next, run `pwd` (short for ‘print working directory’) at the command line and make a note of what it is reported. For instance, on my computer I get the following:
```
$ pwd
/Users/taylor
``` 
You will need this bit of information later in step 3.

### Step 2:
Next, you will need to see if git is installed to the same location that gitwords will expect it to be. Try running the following at the command line:
```
$ /usr/bin/git
```
If you get a message like:
```
usage: git [--version] [--help] [-C <path>] [-c name=value]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p|--paginate|--no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           <command> [<args>]

```
then git is located in the right place and you can move on to step 3.

If instead you get an error message like:
```
-bash: /usr/bin/git: No such file or directory
```
then you will need to do some detective work to determine where git is installed. Once you have located it, open up the file called “parameters.R” within the R sub-directory of the newly created ‘gitwords’ directory, and change the value of `git.location` to correspond to the location of git on your computer.

### Step 3:
Open up R, and set your working directory to the directory that you made a note of in step 1, which corresponds to the directory on your computer that contains the “gitwords” repository. Do this by using the `setwd()` function. In my case, this would be:
```
setwd(“/Users/taylor”)
```
Next, install gitwords into R:
```
install(“gitwords”)
```
After it has installed, you can then load the gitwords package using `library(gitwords)`.

### Installation of the shell scripts
I have also included three shell scripts to allow you to access  these functions from the terminal. (I prefer to do this, as it is inconvenient to have R running constantly.) To use these, you will need to follow the following steps.

#### Step 1:
First, grab the three scripts -- `get_words`,`word_stats`, and `plot_words` from the ‘scripts’ subdirectory of the gitwords repository you downloaded to your computer. 

Next, we need to determine whether Rscript is installed in the standard location. Open up a terminal/shell and run:
```
$ /usr/bin/Rscript
```
If you get an error message like:
```
-bash: /usr/bin/Rscript: No such file or directory 
```
then, like before, you will need to do some detective work to determine where this program is located, and then edit the first line of each of the three scripts with this correct location. If instead of an error message you get a message that begins with the following, 
```
Usage: /path/to/Rscript [--options] [-e expr [-e expr2 ...] | file] [args]
```
then you are good to go, and can move on to the next step.

#### Step 2:

Next, you will need to make these files executable. Open up the command line terminal, navigate to the directory where these files are located, and type in the following
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

Now the shell scripts should be ready for you to use! You can also now safely delete the ‘gitwords’ repository you downloaded in step 1.


