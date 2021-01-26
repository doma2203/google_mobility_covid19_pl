library(tidyverse)
library(readr)
library(plotly)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

raw_data <- read_csv("2020_PL_Region_Mobility_Report.csv", 
                    col_types = cols(country_region_code = col_skip(),sub_region_2 = col_skip(), metro_area = col_skip(),census_fips_code = col_skip(), 
                    country_region = col_skip(), date = col_date(format = "%Y-%m-%d")))
raw_data<-raw_data[!is.na(raw_data$iso_3166_2_code),]
raw_data$sub_region_1<-as.factor(raw_data$sub_region_1)
raw_data$iso_3166_2_code<-as.factor(raw_data$iso_3166_2_code)

fig<- plot_ly(data=raw_data,x = ~date, y = ~retail_and_recreation_percent_change_from_baseline,color=sub_region_1,mode="line")
#levels()
fig <- fig %>% layout(
  title = "Retail and recreation",
  xaxis=list(
    rangeselector = list(
      buttons = list(
        list(
          count = 1,
          label = "1 mo",
          step = "month",
          stepmode = "backward"),
        list(
          count = 3,
          label = "3 mo",
          step = "month",
          stepmode = "backward"),
        list(
          count = 6,
          label = "6 mo",
          step = "month",
          stepmode = "backward"),
        list(step = "all"))
    ),
    rangeslider = list(type = "date")),
  yaxis = list(title = "total cases")
)

app <- Dash$new()

app$layout(
  htmlDiv(
    list(
      dccGraph(figure=fig) 
    )
  )
)

app$run_server(host = '0.0.0.0', port = Sys.getenv('PORT', 8050))