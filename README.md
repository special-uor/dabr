
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dabr: Database Management with R <img src="https://raw.githubusercontent.com/special-uor/dabr/main/inst/images/logo.png" alt="logo" align="right" height=200px/>

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/dabr?color=black)](https://cran.r-project.org/package=dabr)
[![](https://img.shields.io/badge/devel%20version-0.0.3-yellow.svg)](https://github.com/special-uor/dabr)
[![R build
status](https://github.com/special-uor/dabr/workflows/R-CMD-check/badge.svg)](https://github.com/special-uor/dabr/actions)
<!-- badges: end -->

The goal of dabr is to provide functions to manage databases: select,
update, insert, and delete records, list tables, backup tables as CSV
files, and import CSV files as tables.

## Installation

You can install the released version of dabr from
[CRAN](https://cran.r-project.org/package=dabr) with:

``` r
install.packages("dabr")
```

And the development version from
[GitHub](https://github.com/special-uor/dabr) with:

``` r
# install.packages("remotes")
remotes::install_github("special-uor/dabr", "dev")
```

## Example

Connecting to the Reading Palaeofire Database (RPD), locally installed
under the name `RPD-latest`:

``` r
conn <- dabr::open_conn_mysql("RPD-latest", 
                              password = rstudioapi::askForPassword(prompt = "Password"))
```

Explore the database structure by listing the tables and their
attributes:

``` r
dabr::list_tables(conn)
#> 
#> 
#> |age_model |
#> |:---------|
#> |ID_MODEL  |
#> |ID_SAMPLE |
#> |mean      |
#> |median    |
#> |UNCERT_5  |
#> |UNCERT_25 |
#> |UNCERT_75 |
#> |UNCERT_95 |
#> 
#> 
#> |chronology       |
#> |:----------------|
#> |ID_MODEL         |
#> |ID_SAMPLE        |
#> |original_est_age |
#> 
#> 
#> |date_info        |
#> |:----------------|
#> |ID_ENTITY        |
#> |ID_DATE_INFO     |
#> |material_dated   |
#> |date_type        |
#> |avg_depth        |
#> |thickness        |
#> |lab_number       |
#> |age_C14          |
#> |age_calib        |
#> |error            |
#> |correlation_info |
#> |age_used         |
#> |reason_age_used  |
#> |notes            |
#> 
#> 
#> |DELETE_charcoal |
#> |:---------------|
#> |ID_SAMPLE       |
#> |quantity        |
#> |sample_size     |
#> 
#> 
#> |DELETE_chronology  |
#> |:------------------|
#> |ID_SAMPLE          |
#> |original_age_model |
#> |original_est_age   |
#> |BACON_INTCAL13_age |
#> |UNCERT_5           |
#> |UNCERT_25          |
#> |UNCERT_75          |
#> |UNCERT_95          |
#> 
#> 
#> |entity               |
#> |:--------------------|
#> |ID_SITE              |
#> |ID_ENTITY            |
#> |entity_name          |
#> |latitude             |
#> |longitude            |
#> |elevation            |
#> |depositional_context |
#> |measurement_method   |
#> |TYPE                 |
#> |source               |
#> |core_location        |
#> |last_updated         |
#> |ID_UNIT              |
#> 
#> 
#> |entity_link_pub |
#> |:---------------|
#> |ID_ENTITY       |
#> |ID_PUB          |
#> 
#> 
#> |model_name |
#> |:----------|
#> |ID_MODEL   |
#> |model_name |
#> 
#> 
#> |pub         |
#> |:-----------|
#> |ID_PUB      |
#> |citation    |
#> |pub_DOI_URL |
#> 
#> 
#> |sample                   |
#> |:------------------------|
#> |ID_ENTITY                |
#> |ID_SAMPLE                |
#> |avg_depth                |
#> |depth_top                |
#> |depth_bottom             |
#> |sample_thickness         |
#> |charcoal_measurement     |
#> |analytical_sample_volume |
#> 
#> 
#> |site             |
#> |:----------------|
#> |ID_SITE          |
#> |site_name        |
#> |latitude         |
#> |longitude        |
#> |elevation        |
#> |site_type        |
#> |water_depth      |
#> |basin_size_class |
#> |catch_size_class |
#> |flow_type        |
#> |basin_size_km2   |
#> |catch_size_km2   |
#> 
#> 
#> |unit    |
#> |:-------|
#> |ID_UNIT |
#> |UNIT    |
```

**ALWAYS\!** close your connection to the database (when you are done):

``` r
dabr::close_conn(conn)
```
