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
library(readr)

library('ggmap')
library('rgdal')
library('rgeos')
library('maptools')
library('tmap')

library(raster)
library(xlsx)
library(RColorBrewer)

###############
#DATA WRANGLING
###############

#to do:
#add markers as event

###############

TestData <- read_csv("ALLRoutes.csv")
shapes <- shapefile("../SA3_2016_AUST.shp")
ColorData <- read_csv("RandomColourData.csv")

#line test data
mapData = TestData[,c("Latitude","Longitude","Speed","Route Num")]
mapData$group = TestData$`Route Num`

#data with only marker points
mapData2 = mapData[seq(1, nrow(mapData), 100), ]

###############
#CREATE PALETTES
###############

#to do:
#figure out colour for route 

###############

locPalette = colorFactor("YlOrRd", shapes$STE_NAME16)
RoutePalette = colorNumeric(c("white","yellow", "navy"), mapData$group)
#https://rstudio.github.io/leaflet/colors.html
#https://www.r-graph-gallery.com/183-choropleth-map-with-leaflet.html

###############
#HOVER TEXT
###############

#to do:
#look into links for pop up bubbles: https://rstudio.github.io/leaflet/popups.html

###############

locationText <- paste(
  "Location: ", shapes$STE_NAME16,"<br/>", 
  "Area: ", shapes$AREASQKM16, "<br/>", 
  sep="") %>%
  lapply(htmltools::HTML)

routeText <- paste(
  "Route Number: ", mapData$group,"<br/>", 
  "Speed: ", mapData$Speed, "<br/>", 
  sep="") %>%
  lapply(htmltools::HTML)

m <- leaflet() %>%
  addTiles() %>%
  addPolylines(data = mapData, lng = ~Longitude, lat = ~Latitude, group = ~group, label = ~routeText, color = "black") %>%
  addCircleMarkers(data = mapData2, lng= ~Longitude, lat= ~Latitude, popup = ~as.character(Speed), 
                   label = ~routeText, radius = 5, fillColor = "red", color = "red"

) %>%
  setView(lng=153.0251, lat=-27.4698, zoom=10)
m

pal <- colorFactor("YlOrRd", shapes$STE_NAME16)
locPalette = colorFactor("YlOrRd", ColorData$RandomOne)
ma <- leaflet() %>%
  addTiles() %>%
  addPolygons(data=shapes,
              fillColor = ~locPalette(ColorData$RandomOne),
              weight = 2,
              opacity = 1,
              color = "white",
              dashArray = "3",
              fillOpacity = 0.6,
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.3,
                bringToFront = TRUE),
              label = mytext,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) %>%
  setView(lng=153.0251, lat=-27.4698, zoom=10) #%>%
ma

  #EDIT CODE
  
write.xlsx(as.data.frame(shapes), "shapes.xlsx")


#PREVIOUS
# converting JSON to dataframe so that it can be used in the leaflet map
data2 <- fromJSON("BioMap/data.json")

data2 <- data2[!is.na(data2$`Low latitude (deg)`),]
data2 <- data2 %>%
  mutate(lat = `Low latitude (deg)`,
         long = `Low longitude (deg)`,
         group = `Date`)


# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
# states <- readOGR("SA3_2016_AUST.shp",
#                   layer = "cb_2013_us_state_20m", GDAL1_integer64_policy = TRUE)


