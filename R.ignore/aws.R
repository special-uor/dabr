conn <- dabr::open_conn_mysql(dbname = "RPD",
                              user = "admin",
                              password = rstudioapi::askForPassword("Enter your password"),
                              host = "rpd.cylxsu7jqlgt.us-east-2.rds.amazonaws.com")
dabr::list_tables(conn)
