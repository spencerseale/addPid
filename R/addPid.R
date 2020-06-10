
#' @title Add :: (\code{<package>::<function>}) notation to package functions
#' 
#' @description Scan a file of R code for the presence of functions from packages installed on machine or a custom list of packages.
#' 
#' @param \code{r_script} A connection to a file (.R or .Rmd) containing package functions.
#' 
#' @param \code{packages} Optionally specify a character vector of packages to be searched for.
#' 
#' @param \code{ignore} Optional character vector of package names to ignore.
#' 
#' @param \code{detach} Logical stating whether packages should be detached after input. Default is TRUE.
#' 
#' @details Add :: notation to functions so that packages are directly referenced in their calls. 
#' R package development requires not attaching packages and instead loading them directly by \code{package::function}.
#' This function and package exists to negate manually appending package identifyers to corresponding functions in R code.
#' 
#' @return An edited .R file written to the same directory as input file. 
#' 
#' @author Spencer Seale
#' 
#' @examples 
#' \dontrun{
#' addPid("/path/to/r/script")
#' }
#' 
#' @export addPid

addPid <- function(r_script, packages=NULL, ignore=NULL, detach=TRUE) {
  # initializing vector for package unloading and counter for substitutions
  p_name <- c()
  rep_counter <- 0
  
  # list to hold packages that have functions that made replacements
  f_rep <- c()
  p_rep <- c()
  
  if (is.null(packages)) {
    # pkg must be in the search path
    message("Loading packages installed on machine into search path...")
    suppressMessages(lapply(row.names(installed.packages()), require, character.only = TRUE))
  } else {
    message("Loading specified packages installed on machine into search path...")
    suppressMessages(lapply(packages, require, character.only = TRUE))
  }
  
  pkgs <- c()
  for (s in search()) {
    pkgs <- append(pkgs,  gsub("package:", "", s))
  }
  
  # removing native packages from list to be annotated with package name
  pkgs <- pkgs[!pkgs %in% c("package:base", "stats", "utils", ".GlobalEnv", "tools:rstudio", "Autoloads", "base", 
                               "datasets", "methods", "grDevices", "graphics")]
  
  if (!is.null(ignore)) {
    pkgs <- pkgs[!pkgs %in% ignore]
  }
  
  # read in R script that is to be edited 
  rs <- readLines(r_script)
  
  # list of characters that must be escaped in regex
  esc <- c(".","+","*","?","[","^","]","$","(",")","{","}","=","!","<",">","|",":","-")
  
  message("Scanning .R script for functions from packages...")
  for (p in pkgs) {
    message(paste("*", p))
    fxns <- ls(paste0("package:", p))
    p_name <- append(p_name, paste0("package:", p))
    
    # scanning script for all instances of functions from each package
    for (f in fxns) {
      f_name <- f
      # need to add escape characters to special characters exisiting in package functions for final gsub to work with regex
      for (e in esc) {
        f <- gsub(paste0("[\\", e, "]"), paste0("\\\\", e), f, perl=T)
      }
      
      # setting look behind to only accept non word characters except . and :
      look_behind <- "(?<=[\\W])(?<![:.])"
      pat <- paste0(look_behind, f, "(?=\\()")
      rep <- paste0(p, "::", f)
      
      # first add replacements to a temp var rather than original
      temp <- gsub(pat, rep, rs, ignore.case = F, perl = T)
      
      # if not identical, then at least one match made
      if (!identical(rs, temp)) {
        rep_counter = rep_counter + 1
        f_rep <- append(f_rep, f_name)
        p_rep <- unique(append(p_rep, p))
      }
      
      # after compared, set temp to rs to integrate changes
      rs <- temp
    }
  }
  message("Scanning complete.")
  
  # return search path to previous state
  if (detach) {
    suppressWarnings(invisible(lapply(p_name, function(i) {detach(i, character.only = T, unload = T)})))
  }
  
  # write out edited file if at least one edit was made
  if (rep_counter > 0) {
    writeLines(rs, paste0(dirname(r_script), "/fixed_", basename(r_script)))
    message("****      *******   *******   *  *   **     *******   *******")
    message("**  *     **        **        *  *   **        *      **")
    message("*****     *******   *******   *  *   **        *      *******")
    message("**  **    **             **   *  *   **        *           **")
    message("**   **   *******   *******   ****   *******   *      *******")
    message(paste0("*", rep_counter, " unique functions annotated with package name."))
    message("*Packages with functions edited:")
    message(paste(p_rep, collapse = "\n"))
    message("*Functions from packages edited:")
    message(paste(f_rep, collapse = "\n"))
    message("*The edited .R file has been saved in same dir as input script.")
  } else {
    message("*No edits made, an edited file is not necessary and will not be written out.")
  }
}

# x <- addPid("/Users/sseale/addPid/tests/test.R", packages = c("dplyr", "stringr"))
# x



