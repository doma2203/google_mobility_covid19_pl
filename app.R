library(tidyverse)
library(readr)
raw_data <- read_csv("2020_PL_Region_Mobility_Report.csv", 
                    col_types = cols(country_region_code = col_skip(),sub_region_2 = col_skip(), metro_area = col_skip(),census_fips_code = col_skip(), 
                    country_region = col_skip(), date = col_date(format = "%Y-%m-%d")))
raw_data<-raw_data[!is.na(raw_data$iso_3166_2_code),]
