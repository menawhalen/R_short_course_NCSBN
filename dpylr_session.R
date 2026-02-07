library(tidyverse)
library(mdsr)

## Examples of Select
CIACountries %>%
  glimpse

select(CIACountries, country, pop, gdp)
### The below is the same
CIACountries %>%
  select(country, pop, gdp)

CIACountries %>%
  select(contains("p"))

CIACountries %>%
  select(country,starts_with("oil"))

CIACountries_sub <- CIACountries %>%
  select(-roadways,-educ)

View(CIACountries_sub)

### Filtering Examples

filter(CIACountries, pop > 1000000)

CIACountries %>%
  filter(pop > 1000000)

CIACountries %>%
  filter(country %in% c("Chile","Costa Rica"))

CIACountries %>%
  filter(country == "Chile" | country == "Costa Rica")

### Filter and Select Combined

CIACountries %>%
  filter(pop > 1e8) %>%
  select(country,pop,gdp)

### Mutate Variables

CIACountries %>%
  mutate(gdp_lvl = case_when(
    gdp < 10000 ~ "low",
    gdp >= 10000 & gdp < 50000 ~ "med",
    TRUE ~ "high"
  ),
  dens = pop / area) %>%
  mutate(gdp_lvl = factor(gdp_lvl,
                          levels = c("low","med","high"))) %>%
  select(country, gdp_lvl, dens) %>%
  filter(gdp_lvl == "low")

## Group By

CIACountries_lvl <- CIACountries %>%
  mutate(gdp_lvl = case_when(
    gdp < 10000 ~ "low",
    gdp >= 10000 & gdp < 50000 ~ "med",
    TRUE ~ "high"
  )) %>%
  mutate(gdp_lvl = factor(gdp_lvl,
                          levels = c("low","med","high")))

### Using group_by alone does not change the dataset
### We always use group_by with summarise

CIACountries_lvl %>%
  group_by(gdp_lvl) %>%
  summarise(mean_pop = mean(pop),
            sd_pop = sd(pop))

CIACountries_lvl %>%
  mutate(high_educ = educ > 4.5) %>%
  group_by(high_educ) %>%
  summarize(mean_area = mean(area),
            median_area = median(area))

CIACountries_lvl %>%
  mutate(high_educ = educ > 4.5) %>%
  group_by(high_educ) %>%
  tally()

## Dealing with NAs
CIACountries_lvl %>%
  mutate(high_educ = educ > 4.5) %>%
  group_by(high_educ) %>%
  summarize(mean_oil = mean(oil_prod, na.rm=TRUE),
            median_oil = median(oil_prod, na.rm=TRUE))
### na.rm = TRUE removes NAs
## Filter Out NAs
CIACountries %>%
  filter(!is.na(educ))
