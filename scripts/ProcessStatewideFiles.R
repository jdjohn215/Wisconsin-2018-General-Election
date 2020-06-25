rm(list = ls())

library(tidyverse)

# This file processes the WEC election result files which have one sheet per election

# this function downloads a given excel file from WEC
get_results <- function(url){
  file.path <- tempfile()
  download.file(url = url, destfile = file.path)
  readxl::read_excel(file.path) %>%
    janitor::clean_names()
}

gov <- get_results("https://elections.wi.gov/sites/elections.wi.gov/files/2018%20General%20Election%20Governor%20Contest%20Candidates%20with%20Districts.xlsx") %>%
  mutate(race = "governor")

ag <- get_results("https://elections.wi.gov/sites/elections.wi.gov/files/Attorney%20General_WardByWard_withDistricts%202018%20General_0.xlsx") %>%
  mutate(race = "attorney general")

sos <- get_results("https://elections.wi.gov/sites/elections.wi.gov/files/Secretary%20of%20State_WardByWard_withDistricts%202018%20General_0.xlsx") %>%
  mutate(race = "secretary of state")

treasurer <- get_results("https://elections.wi.gov/sites/elections.wi.gov/files/State%20Treasurer_WardByWard_withDistricts%202018%20General_0.xlsx") %>%
  mutate(race = "state treasurer")

uss <- get_results("https://elections.wi.gov/sites/elections.wi.gov/files/US%20Senator_WardByWard_withDistricts%202018%20General_0.xlsx") %>%
  mutate(race = "US senator")

write_csv(gov, "data/Wisconsin2018Governor_ReportingUnits.csv")
write_csv(ag, "data/Wisconsin2018AttorneyGeneral_ReportingUnits.csv")
write_csv(sos, "data/Wisconsin2018SecretaryOfState_ReportingUnits.csv")
write_csv(treasurer, "data/Wisconsin2018Treasurer_ReportingUnits.csv")
write_csv(uss, "data/Wisconsin2018Senator_ReportingUnits.csv")