library(shiny)
library(leaflet)
library(maps)
library(ggplot2)
library(ggmap)
library(mapdata)
library(rsconnect)
library(tidyr)
library(shinydashboard)
library(shiny)
library(rsconnect)
library(dplyr)
library(jsonlite)

library('ggmap')
library('rgdal')
library('rgeos')
library('maptools')
library('tmap')

#DATA 
TestData <- read_csv("BioMap/TestData.csv")

#longitude and latitude variables
#ns1:LatitudeDegrees
#ns1:LongitudeDegrees


# converting JSON to dataframe so that it can be used in the leaflet map
data2 <- fromJSON("BioMap/data.json")

data2 <- data2[!is.na(data2$`Low latitude (deg)`),]
data2 <- data2 %>%
  mutate(lat = `Low latitude (deg)`,
         long = `Low longitude (deg)`,
         group = `Date`)

#sampleRoute$ns1_LatitudeDegrees

#line test data

markers <- data.frame(Observation = c("A", "B"),
                      InitialLat = c(TestData$ns1_LatitudeDegrees,TestData$ns1_LatitudeDegrees),
                      InitialLong = c(TestData$ns1_LongitudeDegrees,TestData$ns1_LongitudeDegrees),
                      NewLat = c(TestData$ns1_LatitudeDegrees,TestData$ns1_LatitudeDegrees),
                      NewLong = c(TestData$ns1_LongitudeDegrees,TestData$ns1_LongitudeDegrees),
                      stringsAsFactors = FALSE)

markers2 <- data.frame(group = c("A", "B"),
                       lat = c(markers$InitialLat, markers$InitialLat),#, markers$NewLat),
                       long = c(markers$InitialLong, markers$InitialLong)#, markers$NewLong)
                       )


#RouteMap <- renderLeaflet({
  m <- leaflet() %>%
    addTiles() %>%
    addPolylines(data = markers2, lng = ~long, lat = ~lat, group = ~group) %>%
    addMarkers(data = markers2, lng= ~long, lat= ~lat, popup = ~as.character(group), label = ~as.character(group)) %>%
    setView(lng=153.0251, lat=-27.4698, zoom=10) #%>%
  
  m
#})

  #EDIT CODE
  
  map <- readOGR(dsn = "data", layer = "MB_2016_QLD")
  #plot(map)
  
  saveRDS(object = map, file = "data/qldMap.Rds")
  
  qldMap <- readRDS('data/qldMap.Rds')
  leaflet() %>% addTiles() %>% addPolygons(data = qldMap)
  
  
  
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))
  
  
  sampleRoute = read_csv("BioMap/TestData.csv")
  sampleRoute$ns1_LatitudeDegrees[5],sampleRoute$ns1_LatitudeDegrees[433]
  sampleRoute$ns1_LongitudeDegrees[5],sampleRoute$ns1_LongitudeDegrees[433]
  
  