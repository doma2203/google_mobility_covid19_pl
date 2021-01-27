library(tidyverse)
install.packages('devtools')
install.packages('rnaturalearth')
library(readr)
library(plotly)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(rnaturalearth)

raw_data <- read_csv("2020_PL_Region_Mobility_Report.csv", 
                    col_types = cols(country_region_code = col_skip(),sub_region_2 = col_skip(), metro_area = col_skip(),census_fips_code = col_skip(), 
                    country_region = col_skip(), date = col_date(format = "%Y-%m-%d")))
raw_data<-raw_data[!is.na(raw_data$iso_3166_2_code),]
#raw_data$sub_region_1<-as.factor(raw_data$sub_region_1)
raw_data$iso_3166_2_code<-as.factor(raw_data$iso_3166_2_code)
raw_data$sub_region_1 %>% str_replace_all("Łódź","Lódz") -> raw_data$sub_region_1
raw_data$sub_region_1 %>% str_replace_all("Świętokrzyskie","Swietokrzyskie") -> raw_data$sub_region_1
poland <- ne_states(country = "Poland", returnclass = "sf")
mapping<-data.frame(poland$name_en,poland$name_pl)
poland_plt<-plot_ly(poland,split=~name_pl)
raw_data<-merge(raw_data,mapping,by.x="sub_region_1",by.y="poland.name_en",sort=FALSE)
#raw_data<-merge(raw_data,mapping,by=intersect(names(raw_data), names(mapping)),all.y=TRUE,sort=FALSE)
#raw_data<-subset(raw_data, select = -c(sub_region_1) )
poland.name_pl<-as.factor(raw_data$poland.name_pl)
retail_recreation <- plot_ly(data=raw_data,x = ~date, y = ~retail_and_recreation_percent_change_from_baseline,color=~poland.name_pl,mode="line")
grocery_pharmacy <- plot_ly(data=raw_data,x = ~date, y = ~grocery_and_pharmacy_percent_change_from_baseline,color=~poland.name_pl,mode="line")
parks <- plot_ly(data=raw_data,x = ~date, y = ~parks_percent_change_from_baseline,color=~poland.name_pl,mode="line")
transit <- plot_ly(data=raw_data,x = ~date, y = ~transit_stations_percent_change_from_baseline,color=~poland.name_pl,mode="line")
workplaces <- plot_ly(data=raw_data,x = ~date, y = ~workplaces_percent_change_from_baseline,color=~poland.name_pl,mode="line")
residential <- plot_ly(data=raw_data,x = ~date, y = ~residential_percent_change_from_baseline,color=~poland.name_pl,mode="line")


retail_recreation <- retail_recreation %>% layout(
  title = "Handel i rekreacja",
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
  yaxis = list(title = "zmiana [%]")
)


grocery_pharmacy <- grocery_pharmacy %>% layout(
  title = "Sklepy spożywcze i farmacja",
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
  yaxis = list(title = "zmiana [%]")
)

parks <- parks %>% layout(
  title = "Parki",
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
  yaxis = list(title = "zmiana [%]")
)

transit <- transit %>% layout(
  title = "Stacje tranzytowe",
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
  yaxis = list(title = "zmiana [%]")
)

workplaces <- workplaces %>% layout(
  title = "Miejsca pracy",
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
  yaxis = list(title = "zmiana [%]")
)

residential <- residential %>% layout(
  title = "Miejsca zamieszkania",
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
  yaxis = list(title = "zmiana [%]")
)

#fig<-plot_ly(raw_data, type='choropleth', locationmode='Poland',locations=raw_data$iso_3166_2_code, z=raw_data$grocery_and_pharmacy_percent_change_from_baseline, text=raw_data$retail_and_recreation_percent_change_from_baseline, colorscale="Viridis")
# devtools::install_github("ropensci/rnaturalearthhires") 
page_title<-htmlH1("Google Mobility Report - PL")
page_descr<-htmlPlaintext("Na podstawie danych pobranych z https://www.google.com/covid19/mobility/")
page_subtitle<-htmlH2("O co chodzi?")
page_descr_long<-htmlP("Pandemia zmieniła dotychczasowe schematy poruszania się. Google udostępnia zebrane w tym czasie dane oparte o usługi geolokalizacyjne obecne w telefonach komórkowych i innych urządzeniach oraz zestawia je z okresem sprzed pandemii, aby pokazać co się zmieniło.")
page_baseline<-htmlH2("Jaki jest punkt odniesienia?")
page_baseline_long<-dccMarkdown("Punktem odniesienia w każdym przypadku jest **mediana obliczona dla danego dnia tygodnia z wartości sprzed pandemii (od 5. stycznia do 6 lutego 2020 roku)**. Każdy wykres tłumaczy, o ile procent zmieniło się odwiedzanie miejsc takich jak sklepy spożywcze, parki, punkty tranzytowe, miejsca pracy oraz zamieszkania.  ")
poland_grph<-dccGraph(id='Poland-map',figure = poland_plt)
retail_recreation_grph<-dccGraph(id='retail_recreation',figure=retail_recreation)
grocery_pharmacy_grph<-dccGraph(id='grocery_pharmacy',figure=grocery_pharmacy)
grocery_pharmacy_grph<-dccGraph(id='grocery_pharmacy',figure=grocery_pharmacy)
parks_grph<-dccGraph(id='parks',figure=parks)
transit_grph<-dccGraph(id='transit',figure=transit)
workplaces_grph<-dccGraph(id='workplaces',figure=workplaces)
residential_grph<-dccGraph(id='residential',figure=residential)

page_plot_2<-htmlH3("Handel i rekreacja")
page_plot_3<-htmlH3("Sklepy spożywcze i farmacja")
page_plot_4<-htmlH3("Parki")
page_plot_5<-htmlH3("Stacje tranzytowe")
page_plot_6<-htmlH3("Miejsca pracy")
page_plot_7<-htmlH3("Miejsca zamieszkania")
app <- Dash$new()
app$layout(
  htmlDiv(
    list(
      page_title,
      page_descr,
      page_subtitle,
      page_descr_long,
      page_baseline,
      page_baseline_long,
      poland_grph,
      page_plot_2,
      retail_recreation_grph,
      page_plot_3,
      grocery_pharmacy_grph,
      page_plot_4,
      parks_grph,
      page_plot_5,
      transit_grph,
      page_plot_6,
      workplaces_grph,
      page_plot_7,
      residential_grph
    )
  )
)

app$run_server(host = '0.0.0.0', port = Sys.getenv('PORT', 8050))

