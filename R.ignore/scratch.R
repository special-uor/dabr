
# @export
print_table <- function(attributes, tbname = NULL, width = 10) {
  attr.width <- lapply(attributes, nchar)
  max.chr <- max(c(attr.width, nchar(tbname)), rm.na = TRUE)
  line <- rep("-", max(max.chr))
  tab <- function(str, max.chr) {
    left <- max.chr - nchar(str) - 2
    left <- ifelse(left < 0, 0, left)
    paste0("| ", str, paste0(rep(" ", left), collapse = ""), "|")
  }
  msg <- NULL
  if (!is.null(tbname))
    msg <- paste0(line, tab(str), line)
  for (i in seq_along(attributes))
    msg <- paste0(msg, "\n", tab(attributes[i]))
  message(msg)
}
