






testr <- "/Users/sseale/test.R"
pkgs <- c("dplyr", "stringr")

find_pkg_fxn <- function(r_script, packages) {
  lapply(packages, require, character.only = TRUE)
  #library(packages)
  rs <- readLines(r_script)
  #print(rs)
  x <- lapply(packages, function(i) {
    fxns <- ls(paste0("package:", i))
    for (f in fxns) {
      rs <- gsub(pattern = paste0(f, "("), replacement = paste0(i, "::", f, "("), x = rs, fixed = T)
    }
    #print(rs)
    return(rs)
    
  })
  #print(rs)
  return(x)
}


a <- find_pkg_fxn(testr, pkgs)
a


rs
z <- readLines(testr)
z

n <- gsub("sum", "base::sum", z)
n

search()

ls("package:dplyr")



