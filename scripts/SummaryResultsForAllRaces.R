rm(list = ls())

library(tidyverse)
library(readxl)

summary.path <- tempfile()
download.file("https://elections.wi.gov/sites/elections.wi.gov/files/Summary%20Results-2018%20Gen%20Election_0.xlsx",
              summary.path)
all.races.summary <- read_excel(summary.path,
                                sheet = 2,
                                skip = 4) %>%
  janitor::clean_names() %>%
  rename("office" = x3) %>%
  mutate(office = zoo::na.locf(office),
         candidate = replace(candidate, x10 == "Total Votes:", "Total Votes")) %>%
  filter(!is.na(party),
         !is.na(candidate)) %>%
  mutate(number_of_votes_received = replace(number_of_votes_received, is.na(number_of_votes_received),
                                            party[is.na(number_of_votes_received)]),
         party = replace(party, x10 == "Total Votes:", NA)) %>%
  select(office, votes = number_of_votes_received, candidate, party) %>%
  mutate(votes = as.numeric(str_remove_all(votes, ",")),
         candidate = str_squish(candidate))

write_csv(all.races.summary, "data/Wisconsin2018_AllRaces_LongFormat.csv")

# assembly races
assembly.races <- all.races.summary %>%
  filter(str_detect(office, "ASSEMBLY DISTRICT")) %>%
  mutate(party = replace(party, is.na(party), "total")) %>%
  group_by(office, party) %>%
  summarise(votes = sum(votes)) %>%
  ungroup() %>%
  pivot_wider(names_from = party, values_from = votes,
              values_fill = 0) %>%
  mutate(district = word(office, -3, -1)) %>%
  select(district, total, Democrat, Republican, Independent, Libertarian, Constitution)
write_csv(assembly.races, "data/Wisconsin2018_AssemblyRaces_Summary.csv")
