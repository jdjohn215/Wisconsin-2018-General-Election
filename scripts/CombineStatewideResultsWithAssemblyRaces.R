rm(list = ls())

library(tidyverse)

# statewide races in assembly districts
statewide <- read_csv("data/Wisconsin2018_StatewideRaces_AssemblyDistricts.csv") %>%
  mutate(assembly_district = word(assembly_district, -1))

# assembly race results
assembly <- read_csv("data/Wisconsin2018_AssemblyRaces_Summary.csv") %>%
  # match statewide format
  select(assembly_district = district, wsa_dem = Democrat, 
         wsa_rep = Republican, wsa_total = total) %>%
  mutate(assembly_district = word(assembly_district, -1))

combine <- inner_join(statewide, assembly)

write_csv(combine, "data/Wisconsin2018_AssemblyDistricts_StatewideRacesAndAssemblyRaces.csv")
