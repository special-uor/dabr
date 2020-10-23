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
                            host = "localhost",
                            port = 3306) {
  conn <- RMariaDB::dbConnect(RMariaDB::MariaDB(),
                              user = user,
                              password = password,
                              dbname = dbname,
                              host = host,
                              port = port)
  return(conn)
}

#' Close connection to database
#'
#' @param conn Connection object.
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

#' Execute \code{SELECT} query
#'
#' @param conn \code{MariaDBConnection} connection object.
#' @param ... Optional parameters.
#'
#' @return Data frame containing the selected records.
#' @rdname select
#' @export
#'
#' @family DB functions
select <- function(conn, ...) {
  UseMethod("select", conn)
}

#' @param query \code{SELECT} query.
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
select.MariaDBConnection <- function(conn, query, quiet = FALSE, ...) {
  # Verify that the query has a SELECT token
  if (!("SELECT" %in% unlist(strsplit(toupper(query), " "))))
    stop("Your query does not look like a valid SELECT query!")
  # Show query
  if (!quiet)
    message(paste0("Executing: \n", query))

  # Send query
  rs <- RMariaDB::dbSendQuery(conn, query)
  # Fetch records
  records <- RMariaDB::dbFetch(rs)
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
#' conn <- open_conn_mysql("sys", "root")
#' out <- select_all(conn, "sys_config")
#' close_conn(conn)
#' }
select_all.MariaDBConnection <- function(conn, table, quiet = FALSE, ...) {
  query <- paste0("SELECT * FROM ", table)
  return(dabr::select(conn, query, quiet))
}

#' Check connection object
#'
#' Check if \code{conn} is an object with class \code{MariaDBConnection}.
#'
#' @param conn \code{MariaDBConnection} connection object.
#'
#' @return \code{TRUE} if \code{conn} a \code{MariaDBConnection} connection
#'     object, \code{FALSE} otherwise.
#'
#' @family DB functions
#' @noRd
#' @keywords internal
is.MariaDBConnection <- function(conn) {
  inherits(conn, "MariaDBConnection")
}

#' Execute \code{UPDATE} query
#'
#' @param conn \code{MariaDBConnection} connection object.
#' @param ... Optional parameters.
#'
#' @rdname update
#' @export
#'
#' @family DB functions
update <- function(conn, ...) {
  UseMethod("update", conn)
}

#' @param query \code{UPDATE} query.
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
update.MariaDBConnection <- function(conn, query, quiet = FALSE, ...) {
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

#' Execute \code{INSERT} query
#'
#' @param conn DB connection object.
#' @param ... Optional parameters.
#'
#' @rdname insert
#' @export
#'
#' @family DB functions
insert <- function(conn, ...) {
  UseMethod("insert", conn)
}

#' @param query \code{INSERT} query.
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
insert.MariaDBConnection <- function(conn, query, quiet = FALSE, ...) {
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
                ifelse(rows, "s were ", " was "),
                "inserted.")
      }

    # Clear the result
    RMariaDB::dbClearResult(rs)
  }, error = function(e) {
    stop(conditionMessage(e))
  })
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
#'
#' @rdname list_tables
#' @export
list_tables.MariaDBConnection <- function(conn, quiet = FALSE, ...) {
  tryCatch({
    table_names <- RMariaDB::dbListTables(conn)
    tables_info <- lapply(table_names, RMariaDB::dbListFields, conn = conn)
    names(tables_info) <- table_names
    for (i in seq_len(length(tables_info))) {
      print(
        knitr::kable(tables_info[[i]], col.names = table_names[i])
      )
    }
  }, error = function(e) {
    stop(conditionMessage(e))
  })
}
