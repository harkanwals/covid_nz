library(tidyverse)
library(janitor)

## Cases

cases <- read_csv("raw_data/covid_cases_2021-08-19.csv") %>% 
  clean_names() 

cases %>% 
  filter(dhb != "Managed Isolation & Quarantine") %>% 
  group_by(report_date) %>% 
  count(name = "case_count") %>% 
  write_csv("data/community_case_count.csv")

cases %>% 
  filter(dhb == "Managed Isolation & Quarantine") %>% 
  group_by(report_date) %>% 
  count(name = "case_count")  %>%
  write_csv("data/miq_case_count.csv")


## Scans
scans <- read_csv("raw_data/nz-covid-tracer-usage-2021-08-19.csv") %>% 
  clean_names()

scans[is.na(scans)] = 0

scans %>% 
  mutate(origin_date = gsub(" 12:00","", date_time_from, fixed = TRUE))  %>% 
  mutate(origin_date = as.Date(origin_date, format="%d/%m/%Y")) ->
  scans

scans %>% select(origin_date, "App registrations" = app_registrations, "NZBN Registered Businesses" = nzbn_registered_businesses) %>% 
  write_csv("data/tracer_registrations.csv")

scans %>% select(origin_date, "Scans" = scans, "Manual Entries" = manual_entries) %>% 
  write_csv("data/tracer_scans.csv")

scans %>% 
  select(origin_date, "Active Devices" = active_devices) %>% 
  write_csv("data/tracer_actives.csv")
