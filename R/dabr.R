#' @keywords internal
"_PACKAGE"

#' Close connection to database
#'
#' @param conn DB connection object.
#' @param ... Optional parameters.
#'
#' @rdname close_conn
#' @export
#'
#' @family DB functions
close_conn <- function(conn, ...) {
  UseMethod("close_conn", conn)
}

#' @rdname close_conn
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- open_conn_mysql("sys", "root")
#' close_conn(conn)
#' }
close_conn.MariaDBConnection <- function(conn, ...) {
  RMariaDB::dbDisconnect(conn)
}

#' @rdname close_conn
#' @export
close_conn.default <- function(conn, ...) {
  stop("Invalid connection object")
}

#' Execute \code{DELETE} query
#'
#' @param conn DB connection object.
#' @param ... \code{DELETE} query and optional parameters.
#'
#' @rdname delete
#' @export
#'
#' @family DB functions
delete <- function(conn, ...) {
  UseMethod("delete", conn)
}

#' @param quiet Boolean flag to hide status messages.
#'
#' @rdname delete
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- open_conn_mysql("sys", "root")
#' out <- delete(conn, "DELETE sys_config SET value = 1")
#' close_conn(conn)
#' }
delete.MariaDBConnection <- function(conn, ..., quiet = FALSE) {
  query <- paste(unlist(lapply(c(...), trimws)), collapse = " ")
  # Verify that the query has a DELETE token
  if (!("DELETE" %in% unlist(strsplit(toupper(query), " "))))
    stop("Your query does not look like a valid DELETE query!")
  # Show query
  if (!quiet)
    message(paste0("Executing: \n", query))

  tryCatch({
    res <- RMariaDB::dbExecute(conn, query)
    if (!quiet)
      if (res == 0) {
        message("\nResults: No records were deleted.")
      } else {
        message("\nResults: ", res, " record",
                ifelse(res > 1, "s were ", " was "),
                "deleted.")
      }
  }, error = function(e) {
    stop(conditionMessage(e))
  })
}

#' Get attributes of a table
#'
#' @inheritParams close_conn
#'
#' @export
#'
#' @rdname get_attr
get_attr <- function(conn, ...) {
  UseMethod("get_attr", conn)
}

#' @param name Table name.
#'
#' @return List of attributes for table \code{name}.
#' @export
#'
#' @rdname get_attr
get_attr.MariaDBConnection <- function(conn, name, ...) {
  tryCatch({
    return(RMariaDB::dbListFields(conn = conn, name = name))
  }, error = function(e) {
    stop(conditionMessage(e))
  })
}

#' Execute \code{INSERT} query
#'
#' @param conn DB connection object.
#' @param ... \code{INSERT} query and optional parameters.
#'
#' @rdname insert
#' @export
#'
#' @family DB functions
insert <- function(conn, ...) {
  UseMethod("insert", conn)
}

#' @param quiet Boolean flag to hide status messages.
#'
#' @rdname insert
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- open_conn_mysql("sys", "root")
#' query <- paste0(
#'   "INSERT INTO sys_config (variable, value, set_time, set_by) VALUES ",
#'   "('test_var', 999, '", Sys.time(), "', NULL)"
#' )
#' out <- insert(conn, query)
#' close_conn(conn)
#' }
insert.MariaDBConnection <- function(conn, ..., quiet = FALSE) {
  query <- paste(unlist(lapply(c(...), trimws)), collapse = " ")
  # Verify that the query has a INSERT token
  if (!("INSERT" %in% unlist(strsplit(toupper(query), " "))))
    stop("Your query does not look like a valid INSERT query!")
  # Show query
  if (!quiet)
    message(paste0("Executing: \n", query))

  tryCatch({
    # Send query
    rs <- RMariaDB::dbSendQuery(conn, query)
    rows <- RMariaDB::dbGetRowsAffected(rs)
    # Show query results
    if (!quiet)
      if (rows == 0) {
        message("\nResults: No records were inserted.")
      } else {
        message("\nResults: ", rows, " record",
                ifelse(rows > 1, "s were ", " was "),
                "inserted.")
      }

    # Clear the result
    RMariaDB::dbClearResult(rs)
  }, error = function(e) {
    stop(conditionMessage(e))
  })
}

#' Verify connection
#'
#' Verify if connection object is still valid, is connected to the database
#' server.
#'
#' @inheritParams close_conn
#'
#' @return Connection status.
#' @export
#'
#' @rdname is.connected
is.connected <- function(conn,  ...) {
  UseMethod("is.connected", conn)
}

#' @export
#'
#' @rdname is.connected
is.connected.MariaDBConnection <- function(conn, ...) {
  RMariaDB::dbIsValid(conn)
}

#' List tables
#'
#' @param conn DB connection object.
#' @param ... Optional parameters.
#'
#' @rdname list_tables
#' @export
#'
#' @family DB functions
list_tables <- function(conn, ...) {
  UseMethod("list_tables", conn)
}

#' @param quiet Boolean flag to hide status messages.
#' @param attr Boolean flag to list the attributes of each table.
#'
#' @return If \code{quiet = TRUE} returns a list with the tables' names. If
#'     \code{attr = TRUE} includes each attribute of the tables.
#'
#' @rdname list_tables
#' @export
list_tables.MariaDBConnection <- function(conn, quiet = FALSE, attr = TRUE, ...) {
  tryCatch({
    table_names <- RMariaDB::dbListTables(conn)
    if (!attr)
      return(table_names)
    tables_info <- lapply(table_names, get_attr, conn = conn)
    names(tables_info) <- table_names
    if (!quiet) {
      for (i in seq_along(tables_info))
        print(knitr::kable(tables_info[[i]], col.names = table_names[i]))
    } else {
      out <- vector("list", length(table_names))
      for (i in seq_along(tables_info))
        out[[i]] <- tables_info[[i]]
      names(out) <- table_names
      return(out)
    }
  }, error = function(e) {
    stop(conditionMessage(e))
  })
}

#' Connect to database
#'
#' Uses \code{RMariaDB} to open a connection to a MySQL database.
#'
#' @param dbname Database/Schema name.
#' @param user Username of database owner.
#' @param password Password (default: \code{NULL}).
#' @param host Database host, it can be local (default) or remote.
#' @param port Database port.
#'
#' @return \code{MariaDBConnection} connection object.
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- open_conn_mysql("sys")
#' }
#'
#' @family DB functions
open_conn_mysql <- function(dbname,
                            user = "root",
                            password = NULL,
                            host = "127.0.0.1",
                            port = 3306) {
  conn <- RMariaDB::dbConnect(drv = RMariaDB::MariaDB(),
                              user = user,
                              password = password,
                              dbname = dbname,
                              host = host,
                              port = port)
  return(conn)
}

#' Execute \code{SELECT} query
#'
#' @param conn DB connection object.
#' @param ... \code{SELECT} query and optional parameters.
#'
#' @return Data frame containing the selected records.
#' @rdname select
#' @export
#'
#' @family DB functions
select <- function(conn, ...) {
  UseMethod("select", conn)
}

#' @param quiet Boolean flag to hide status messages.
#'
#' @rdname select
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- open_conn_mysql("sys", "root")
#' out <- select(conn, "SELECT variable, value FROM sys_config")
#' close_conn(conn)
#' }
select.MariaDBConnection <- function(conn, ..., quiet = FALSE) {
  # rlang::dots_list()
  query <- paste(unlist(lapply(c(...), trimws)), collapse = " ")
  # Verify that the query has a SELECT token
  if (!("SELECT" %in% unlist(strsplit(toupper(query), " "))))
    stop("Your query does not look like a valid SELECT query!")

  # Change NAs to NULL
  # query <- gsub("NA", "NULL", query)

  # Show query
  if (!quiet)
    message(paste0("Executing: \n", query))

  # Send query
  rs <- RMariaDB::dbSendQuery(conn, query)
  # Fetch records
  records <- RMariaDB::dbFetch(rs) %>%
    tibble::as_tibble()
  # Show query results
  if (!quiet)
    if (nrow(records) == 0) {
      message("\nResults: No records were found.")
    } else {
      message("\nResults: ", nrow(records), " record",
              ifelse(nrow(records) > 1, "s were ", " was "),
              "found.")
    }

  # Clear the result
  RMariaDB::dbClearResult(rs)
  return(records)
}

#' Select all the records
#'
#' Select all the records inside a particular table, use the \code{table}
#' parameter.
#'
#' @param conn \code{MariaDBConnection} connection object.
#' @param ... Optional parameters.
#'
#' @return Data frame with records.
#' @rdname select_all
#' @export
#'
#' @family DB functions
select_all <- function(conn, ...) {
  UseMethod("select_all", conn)
}

#' @param table Name of the table.
#' @param quiet Boolean flag to hide status messages.
#'
#' @rdname select_all
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- dabr::open_conn_mysql("sys", "root")
#' out <- dabr::select_all(conn, "sys_config")
#' dabr::close_conn(conn)
#' }
select_all.MariaDBConnection <- function(conn, table, quiet = FALSE, ...) {
  query <- paste0("SELECT * FROM ", table)
  return(conn %>% dabr::select(query, quiet = quiet))
}

#' Execute \code{UPDATE} query
#'
#' @param conn DB connection object.
#' @param ... \code{UPDATE} query and optional parameters.
#'
#' @rdname update
#' @export
#'
#' @family DB functions
update <- function(conn, ...) {
  UseMethod("update", conn)
}

#' @param quiet Boolean flag to hide status messages.
#'
#' @rdname update
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- open_conn_mysql("sys", "root")
#' out <- update(conn, "UPDATE sys_config SET value = 1")
#' close_conn(conn)
#' }
update.MariaDBConnection <- function(conn, ..., quiet = FALSE) {
  query <- paste(unlist(lapply(c(...), trimws)), collapse = " ")
  # Verify that the query has a UPDATE token
  if (!("UPDATE" %in% unlist(strsplit(toupper(query), " "))))
    stop("Your query does not look like a valid UPDATE query!")
  # Show query
  if (!quiet)
    message(paste0("Executing: \n", query))

  tryCatch({
    res <- RMariaDB::dbExecute(conn, query)
    if (!quiet)
      if (res == 0) {
        message("\nResults: No records were updated.")
      } else {
        message("\nResults: ", res, " record",
                ifelse(res > 1, "s were ", " was "),
                "updated.")
      }
  }, error = function(e) {
    stop(conditionMessage(e))
  })
}
