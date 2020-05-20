
find_pkg_fxn <- function(r_script, packages) {
  # pkg must be in the search path
  lapply(packages, require, character.only = TRUE)
  
  # read in script 
  rs <- readLines(r_script)
  for (p in packages) {
    fxns <- ls(paste0("package:", p))
  
    for (f in fxns) {
      print(f)
      pat <- paste0("(?<!functio)(?<!fu)", f)
      print(pat)
      rep <- paste0(p, "::", f)
      print(rep)
      rs <- gsub(pat, rep, rs, ignore.case = F, perl = T)
      #print(paste0("[^::]", f, "("))
    }
  }
  writeLines(rs, paste0(dirname(r_script), "/fixed_", basename(r_script)))
  return(rs)
}


### testing 
testr <- "/Users/sseale/test.R"
pkgs <- c("dplyr", "stringr")
a <- find_pkg_fxn(testr, pkgs)
a

# p <- c("data.table","tidyverse","reshape2","MASS","viridis","polynom","scales", "dplyr")
# find_pkg_fxn("/Users/sseale/bb_repos/immunoSeqR/dev_R/getDiffAb.R", p)

test <- "::select  select"

gsub(paste0("[^::]", "select"), "dplyr::select", test)

test1 <- "function()   n()  ::n" 
var <- "n"
gsub(paste0("(?<!function)", var,), paste0("dplyr::", var), test1)

gsub("(?<!functio)(?<!fu)n", "::n", test1, perl = T, ignore.case = F)
gsub("(?>!::)n", "dpl::n", test1, perl = T, ignore.case = F)
#(?>!\\Q::\\E)

