% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dabr.R
\name{select}
\alias{select}
\alias{select.MariaDBConnection}
\title{Execute \code{SELECT} query}
\usage{
select(conn, ...)

\method{select}{MariaDBConnection}(conn, ..., quiet = FALSE)
}
\arguments{
\item{conn}{DB connection object.}

\item{...}{\code{SELECT} query and optional parameters.}

\item{quiet}{Boolean flag to hide status messages.}
}
\value{
Data frame containing the selected records.
}
\description{
Execute \code{SELECT} query
}
\examples{
\dontrun{
conn <- open_conn_mysql("sys", "root")
out <- select(conn, "SELECT variable, value FROM sys_config")
close_conn(conn)
}
}
\seealso{
Other DB functions: 
\code{\link{close_conn}()},
\code{\link{delete}()},
\code{\link{insert}()},
\code{\link{list_tables}()},
\code{\link{open_conn_mysql}()},
\code{\link{select_all}()},
\code{\link{update}()}
}
\concept{DB functions}
