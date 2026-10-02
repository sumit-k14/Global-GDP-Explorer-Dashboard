library(shiny)
library(tidyverse)
library(DT)
library(bslib)
library(plotly) # Added for interactive charts

# Load and pivot dataset to long format once at startup
gdp_raw <- read_csv("GDP by Country 1999-2022.csv")

gdp_long <- gdp_raw %>%
  pivot_longer(cols = -Country, names_to = "year", values_to = "gdp") %>%
  mutate(year = as.integer(year))
