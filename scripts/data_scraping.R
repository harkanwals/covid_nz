library(rvest)
library(tidygeocoder)
library(tidyverse)

url_data <- "https://www.health.govt.nz/our-work/diseases-and-conditions/covid-19-novel-coronavirus/covid-19-health-advice-public/contact-tracing-covid-19/covid-19-contact-tracing-locations-interest"

css_selector_table_1 <- "#node-11392 > div.field.field-name-body.field-type-text-with-summary.field-label-hidden > div > div > div:nth-child(7) > table"

url_data %>% 
  read_html() -> web_page

html_nodes(web_page, "table") %>% 
  .[1] %>% 
  html_table(fill = TRUE) -> auckland

auckland_locations <- auckland[[1]]

html_nodes(web_page, "table") %>% 
  .[2] %>% 
  html_table(fill = TRUE) -> coromandel

coromandel_locations <- coromandel[[1]]


coromandel_locations %>% 
  mutate( area = "Coromandel") ->
  coromandel_locations

auckland_locations %>%
  mutate(area = "Auckland") %>% 
  select(-`What to do`) %>% 
  write_csv("data/auckland_locations_20th_aug_14_06.csv")


auckland_locations_local <- read_csv("data/auckland_locations_latest.csv")
auckland_locations_local

auckland_locations_local %>% group_by(`Location name`, `Date added`) %>% 
  count() %>% arrange(`Location name`) %>% View()
# previous_locations <- read_csv("data/all_locations.csv")
# 
# anti_join(previous_locations, all_locations)
# 
# all_locations %>% write_csv("data/all_locations_aug_19_10_15_am.csv")
# 
# all_locations %>% 
#   filter(address != "Bus 97B") %>% 
#   filter(address != "Bus 25B") %>% 
#   geocode(address, method = 'osm', lat = latitude , long = longitude) ->
#   some_locations_geocoded
# 
#   
#   
# some_locations_geocoded %>% 
#   write_csv("data/some_locations_geocoded.csv")
# 
# 
# leaflet(some_locations_geocoded) %>% addTiles() %>%
#   addMarkers(~longitude, ~latitude, popup = ~as.character(day, times), label = ~as.character(address))
