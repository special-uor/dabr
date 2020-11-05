#' @export
quote <- function(str) {
  return(paste0("'", str, "'"))
}

#' @export
attributes <- function(...) {
  return(paste0(..., collapse = ", "))
}
