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

#    http://shiny.rstudio.com/
#

library(shiny)
library(rsconnect)
library(dplyr)
library(jsonlite)
library(raster)
library(maps)
library(ggplot2)
library(ggmap)
library(mapdata)
library(tidyr)
library(shinydashboard)
library(readr)
library(xlsx)
library(RColorBrewer)

#DATA 
TestData <- read_csv("Data/Routes/ALLRoutes.csv")
shapes <- shapefile("SA3_2016_AUST.shp")

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

mytext <- paste(
  "Location: ", shapes$STE_NAME16,"<br/>", 
  "Area: ", shapes$AREASQKM16, "<br/>", 
  #"Population: ", round(world_spdf@data$POP2005, 2), 
  sep="") %>%
  lapply(htmltools::HTML)

mytext2 <- paste(
  "Group: ", mapData$group,"<br/>", 
  "Speed: ", mapData$Speed, "<br/>", 
  #"Population: ", round(world_spdf@data$POP2005, 2), 
  sep="") %>%
  lapply(htmltools::HTML)

#line test data

mapData = TestData[,c("Latitude","Longitude","Speed","Route Num")]
mapData$group = TestData$`Route Num`
mapData2 = mapData[seq(1, nrow(mapData), 100), ]

m <- leaflet() %>%
  addTiles() %>%
  addPolylines(data = mapData, lng = ~Longitude, lat = ~Latitude, group = ~group, label = ~mytext2) %>%
  addMarkers(data = mapData2, lng= ~Longitude, lat= ~Latitude, popup = ~as.character(Speed), label = ~as.character(group)) %>%
  setView(lng=153.0251, lat=-27.4698, zoom=10)
m





pal <- colorFactor("YlOrRd", shapes$STE_NAME16)

ma <- leaflet() %>%
  addTiles() %>%
  addPolygons(data=shapes,
              fillColor = ~locPalette(STE_NAME16),
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
