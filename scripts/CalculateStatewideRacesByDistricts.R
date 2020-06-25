rm(list = ls())

library(tidyverse)

gov <- read_csv("data/Wisconsin2018Governor_ReportingUnits.csv")
gov.simple <- gov %>%
  mutate(gov_total = rowSums(.[7:21])) %>%
  select(county, muni, reporting_unit_name, ends_with("district"),
         gov_dem = tony_evers_mandela_barnes_dem,
         gov_rep = scott_walker_rebecca_kleefisch_rep,
         gov_total)


ag <- read_csv("data/Wisconsin2018AttorneyGeneral_ReportingUnits.csv")
ag.simple <- ag %>%
  mutate(ag_total = rowSums(.[7:10])) %>%
  select(county, muni, reporting_unit_name, ends_with("district"),
         ag_dem = josh_kaul_dem,
         ag_rep = brad_schimel_rep,
         ag_total)

sos <- read_csv("data/Wisconsin2018SecretaryOfState_ReportingUnits.csv")
sos.simple <- sos %>%
  mutate(sos_total = rowSums(.[11:14])) %>%
  select(county, muni, reporting_unit_name, ends_with("district"),
         sos_dem = doug_la_follette_dem,
         sos_rep = jay_schroeder_rep,
         sos_total)

uss <- read_csv("data/Wisconsin2018Senator_ReportingUnits.csv")
uss.simple <- uss %>%
  mutate(uss_total = rowSums(.[7:11])) %>%
  select(county, muni, reporting_unit_name, ends_with("district"),
         uss_dem = tammy_baldwin_dem,
         uss_rep = leah_vukmir_rep,
         uss_total)

treasurer <- read_csv("data/Wisconsin2018Treasurer_ReportingUnits.csv")
treasurer.simple <- treasurer %>%
  mutate(trs_total = rowSums(.[11:14])) %>%
  select(county, muni, reporting_unit_name, ends_with("district"),
         trs_dem = sarah_godlewski_dem,
         trs_rep = travis_hartwig_rep,
         trs_total)

all.races <- gov.simple %>%
  inner_join(ag.simple) %>%
  inner_join(sos.simple) %>%
  inner_join(treasurer.simple) %>%
  inner_join(uss.simple)

write_csv(all.races, "data/Wisconsin2018_StatewideRaces_ReportingUnits.csv")

by.assembly <- all.races %>%
  group_by(assembly_district) %>%
  summarise_if(is.numeric, sum)
write_csv(by.assembly, "data/Wisconsin2018_StatewideRaces_AssemblyDistricts.csv")

by.wss <- all.races %>%
  group_by(senate_district) %>%
  summarise_if(is.numeric, sum)
write_csv(by.wss, "data/Wisconsin2018_StatewideRaces_SenateDistricts.csv")

by.con <- all.races %>%
  group_by(congressional_district) %>%
  summarise_if(is.numeric, sum)
write_csv(by.con, "data/Wisconsin2018_StatewideRaces_CongressionalDistricts.csv")
