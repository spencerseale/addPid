
addPid <- function(r_script, packages) {
  # initializing vector
  p_name <- c()
  
  # pkg must be in the search path
  suppressMessages(lapply(packages, require, character.only = TRUE))
  
  # read in script 
  rs <- readLines(r_script)
  
  message("Scanning .R script for functions from packages...")
  
  for (p in packages) {
    message(paste("*", p))
    fxns <- ls(paste0("package:", p))
    p_name <- append(p_name, paste0("package:", p))
    # scanning script for all instances of functions from each package
    for (f in fxns) {
      look_behind <- "(?<=[\\W])(?<![:.])"
      pat <- paste0(look_behind, f, "\\(")
      rep <- paste0(p, "::", f, "\\(")
      rs <- gsub(pat, rep, rs, ignore.case = F, perl = T)
    }
  }
  writeLines(rs, paste0(dirname(r_script), "/fixed_", basename(r_script)))
  suppressWarnings(invisible(lapply(p_name, function(i) {detach(i, character.only = T, unload = T)})))
  message("Scanning complete.")
}


### testing --------------------------------------------------------------
# readLines(testr)
# testr <- "/Users/sseale/addPid/test.R"
# pkgs <- c("dplyr", "stringr")
# a <- addPid(testr, pkgs)
# a

# test string 
# test1 <- "function()   n() asd$nasd ::n() ghdn() %>%  \nn()  hey.n() :n() _n() -n() ->n()" 
# test1

# state what must be in lookbehind
# gsub("(?<=[=,\\s\\(\\)\\[\\]\\{\\}\\*\\!])(?<!::)n\\(", "dplyr::n\\(", test1, perl = T, ignore.case = F)

# state what cannot be in lookbehind 
# gsub("(?<=[\\W])(?<![:.])n\\(", "dplyr::n\\(", test1, perl = T, ignore.case = F)
