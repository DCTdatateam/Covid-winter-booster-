library(tidyverse)
library(lubridate)

## Weekly and cumulative totals

total_boosted <- read_csv("https://www.opendata.nhs.scot/dataset/086c153d-0fdc-4f7c-ad51-1e856c094a0e/resource/6978457e-f619-491c-885d-f60e90e81cbd/download/weekly_covid_vacc_scot_20221116.csv")

total_boosted <- total_boosted %>% 
  mutate(Date = ymd(Date)) %>% 
  mutate(Month=format(Date,"%b")) %>% 
  mutate(Day=format(Date,"%d")) %>% 
  mutate(Year=format(Date,"%Y"))

names(total_boosted)[names(total_boosted) == 'NumberVaccinated'] <- 'Weekly vaccinations'
names(total_boosted)[names(total_boosted) == 'CumulativeNumberVaccinated'] <- 'Running total'

## totals_button_chart <-  total_boosted %>%
##  pivot_longer(cols=c('Weekly vaccinations', 'Running total'),
##               names_to='Type',
##               values_to='Total') 


## Eligible uptake, and weekly and cumulative totals, all ages 

uptake <- read_csv("https://www.opendata.nhs.scot/dataset/086c153d-0fdc-4f7c-ad51-1e856c094a0e/resource/831b8008-7635-4774-8bf1-495985965546/download/weekly_covid_vacc_eligible_uptake_hb_20221116.csv")

uptake <- uptake %>%
  mutate(Date = ymd(Date)) %>%
  mutate(Month=format(Date,"%b")) %>% 
  mutate(Day=format(Date,"%d")) %>% 
  mutate(Year=format(Date,"%Y"))


## reorder Scotland first


uptake$HB <- factor(uptake$HB, levels = c("S92000003", "S08000015", "S08000016", "S08000017",
                                          "S08000018", "S08000019", "S08000020", "S08000021",
                                          "S08000022", "S08000023", "S08000024", "S08000025",
                                          "S08000026", "S08000027", "S08000028", "S08000029",
                                          "S08000030", "S08000031", "S08000032", "Unknown")) 

HB_order <- c("S92000003", "S08000015", "S08000016", "S08000017",
              "S08000018", "S08000019", "S08000020", "S08000021",
              "S08000022", "S08000023", "S08000024", "S08000025",
              "S08000026", "S08000027", "S08000028", "S08000029",
              "S08000030", "S08000031", "S08000032", "Unknown")

uptake <- uptake[ order(match(uptake$HB, HB_order)), ]

## latest date % vaccination coverage

latestdate <- max(uptake$Date)

latest_coverage <- uptake %>% 
  filter(HB != "Unknown") %>%
  filter(Date == latestdate) %>% 
  mutate(CumulativeNumberVaccinated=as.character(CumulativeNumberVaccinated))
  



## exports

write.csv(total_boosted, "data/total_boosted.csv", row.names = FALSE)
write.csv(uptake, "data/uptake_by_area_series.csv", row.names = FALSE)
write.csv(latest_coverage, "data/uptake_by_area_current.csv", row.names = FALSE)

