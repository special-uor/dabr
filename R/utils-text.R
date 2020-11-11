#' Add single quotes
#'
#' Add single quotes to string.
#'
#' @param str String.
#'
#' @return String surrounded by single quotes
#' @export
#'
#' @examples
#' dabr::quote("A")
#' dabr::quote("l'A")
quote <- function(str) {
  return(paste0("'", gsub("\\'", "\\\\'", str), "'"))
}

#' Combine attributes
#'
#' Combine attributes from a vector of strings.
#'
#' @param ... Strings.
#'
#' @return Combined string with all the attributes.
#' @export
#'
#' @examples
#' dabr::attributes("A", "B", "C")
#' dabr::attributes(c("A", "B", "C"))
#' dabr::attributes(c("A", "B", "C"), "D", "E", "F")
attributes <- function(...) {
  return(paste(c(...), sep = ", ", collapse = ", "))
}
