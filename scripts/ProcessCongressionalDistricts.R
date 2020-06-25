rm(list = ls())

library(tidyverse)
library(readxl)

# these files have the results for each district on a different sheet

congress.path <- tempfile()
download.file("https://elections.wi.gov/sites/elections.wi.gov/files/Ward%20by%20Ward%20Report-Gen%20Election-Congress_0.xlsx",
              congress.path)
congress.names <- read_excel(congress.path,
                             sheet = 2,
                             skip = 9) %>%
  names()
congress <- read_excel(congress.path,
                       sheet = 2,
                       skip = 11,
                       col_names = congress.names) %>%
  rename("county" = 1, "reporting_unit" = 2) %>%
  mutate(county = zoo::na.locf(county)) %>%
  filter(county != "Office Totals:",
         reporting_unit != "County Totals:") %>%
  janitor::clean_names()
congress
