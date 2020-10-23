#' Connect to database
#'
#' Uses \code{RMariaDB} to open a connection to a MySQL database
#'
#' @param dbname database name
#' @param user username of database owner
#' @param password password [default: \code{NULL}]
#' @param host database host, it can be local (default) or remote
#' @param port database port
#'
#' @return \code{MariaDBConnection} connection object
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- open_conn_mysql("sys", "root")
#' }
#'
#' @family DB functions
open_conn_mysql <- function(dbname,
                            user,
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
#' @param conn connection object
#' @param ... other arguments
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

#' Execute select query
#'
#' Retrieves records that meet the criteria declared in the query
#'
#' @param conn \code{MariaDBConnection} connection object
#' @param query select query
#' @param quiet boolean flag to hide status messages
#'
#' @return data frame containing the selected records
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- open_conn_mysql("sys", "root")
#' out <- select_query_mysql(conn, "SELECT variable, value FROM sys_config")
#' close_conn(conn)
#' }
#' @family DB functions
select_query_mysql <- function(conn, query, quiet = FALSE) {
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
  # Show query
  if (!quiet)
    message(paste0("Results:\n", nrow(records), " records were found."))
  # Clear the result
  RMariaDB::dbClearResult(rs)
  return(records)
}

#' Select all the records inside a particular table
#'
#' @param conn \code{MariaDBConnection} connection object
#' @param ... other arguments
#'
#' @return data frame with records
#' @rdname select_all
#' @export
#'
#' @family DB functions
select_all <- function(conn, ...) {
  UseMethod("select_all", conn)
}

#' @param table name of the table
#' @param quiet boolean flag to hide status messages
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
  return(ageR::select_query_mysql(conn, query, quiet))
}

#' Check if \code{conn} is an object with class \code{MariaDBConnection}
#'
#' @param conn \code{MariaDBConnection} connection object
#'
#' @return \code{TRUE} if \code{conn} a \code{MariaDBConnection} connection
#'     object, \code{FALSE} otherwise
#'
#' @family DB functions
#' @noRd
#' @keywords internal
is.MariaDBConnection <- function(conn) {
  inherits(conn, "MariaDBConnection")
}
