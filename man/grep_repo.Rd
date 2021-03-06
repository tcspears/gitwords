% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/grep_repo.R
\name{grep_repo}
\alias{grep_repo}
\title{Grep a Git Repository}
\usage{
grep_repo(expression, repo = getwd())
}
\arguments{
\item{expression}{A regular expression}

\item{repo}{(optional) The location of a git repository (defaults to the current working directory)}
}
\value{
A character vector of results.
}
\description{
Searches an entire git repository (including all previous commits) for a particular expression, and then returns the results after dropping duplicate outputs.
}

