
find_pkg_fxn <- function(r_script, packages) {
  # pkg must be in the search path
  lapply(packages, require, character.only = TRUE)
  
  # read in script 
  rs <- readLines(r_script)
  for (p in packages) {
    fxns <- ls(paste0("package:", p))
    
    # blanket removal of n() fxn in case dplyr package being used
    fxns <- fxns[!"n" == fxns]
    for (f in fxns) {
      rs <- gsub(pattern = paste0("[^functio]", f, "("), replacement = paste0(p, "::", f, "("), x = rs, fixed = T)
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


