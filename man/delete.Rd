% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dabr.R
\name{delete}
\alias{delete}
\alias{delete.MariaDBConnection}
\title{Execute \code{DELETE} query}
\usage{
delete(conn, ...)

\method{delete}{MariaDBConnection}(conn, ..., quiet = FALSE)
}
\arguments{
\item{conn}{DB connection object.}

\item{...}{\code{DELETE} query and optional parameters.}

\item{quiet}{Boolean flag to hide status messages.}
}
\description{
Execute \code{DELETE} query
}
\examples{
\dontrun{
conn <- open_conn_mysql("sys", "root")
out <- delete(conn, "DELETE sys_config SET value = 1")
close_conn(conn)
}
}
\seealso{
Other DB functions: 
\code{\link{close_conn}()},
\code{\link{insert}()},
\code{\link{list_tables}()},
\code{\link{open_conn_mysql}()},
\code{\link{select_all}()},
\code{\link{select}()},
\code{\link{update}()}
}
\concept{DB functions}
