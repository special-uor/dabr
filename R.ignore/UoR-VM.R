conn <- dabr::open_conn_mysql("RPD",
                              user = "roberto",
                              password = rstudioapi::askForPassword("Enter your password"),
                              host = "127.0.0.1",
                              port = "3307")

conn <- RMariaDB::dbConnect(drv = RMariaDB::MariaDB(),
                            host = "127.0.0.1",
                            port = 3307,
                            user = "roberto",
                            password = "dizzyCla$s96",
                            dbname = "RPD")
dabr::list_tables(conn)

roberto@localhost:3307
