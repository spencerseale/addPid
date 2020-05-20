


#' @title Add :: (i.e. \code{<package>::<function>}) notation to package functions
#' 
#' @description Scan a file of R code for the presence of functions from of a list of input packages.
#' 
#' @param \code{r_script} A connection to a file (.R or .Rmd) containing package functions.
#' 
#' @param \code{packages} A character vector of packages having functions that should be searched for in r_script.
#' 
#' @details Add :: notation to functions so that packages are directly referenced in their calls. 
#' R package development requires not attaching packages and instead loading them directly by \code{package::function}.
#' This function and package exists to negate manually appending package identifyers to corresponding functions in R code.
#' 
#' @return An edited .R or .Rmd file written to the same directory as input file. 
#' 
#' @author Spencer Seale
#' 
#' @examples 
#' \dontrun{
#' pkgs <- c("dplyr", "stringr")
#' 
#' addPid("/path/to/r/script", pkgs)
#' }
#' 
#' @export addPid

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
