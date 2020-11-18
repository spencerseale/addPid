### R Package addPid

##### Description

A fundamental rule in R package development requires that the package be self contained and it not modify the users environment. Key to this is not requiring users to load and attach packages prior to execution. In order to do this, package functions (with the exception of the base package) must be in the format: `package::function()`. This single function package scans .R files for package functions and appends the package from which they have been loaded from in the proper format. This is useful when converting .R files into formats necessary for R package creation.

Insert a specified list of packages to look for or let the tool search for functions from every R package installed on the machine.

##### Installation

* `devtools::install_github("spencerseale/addPid")`
* `library(addPid)`

##### Arguments

`r_script`
A connection to a file (.R or .Rmd) containing package functions.

`packages`
Optionally specify a character vector of packages to be searched for.

`ignore`
Optional character vector of package names to ignore.

`detach`
Logical stating whether packages should be detached after input. Default is TRUE.

##### Details

Add `::` notation to functions so that packages are directly referenced in their calls. R package development requires not attaching packages and instead loading them directly by `package::function()`. This function and package exists to negate manually appending package identifyers to corresponding functions in R code.
