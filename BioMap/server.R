#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
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
library(RColorBrewer)

#DATA 
TestData <- read_csv("ALLRoutes.csv")
shapes <- shapefile("../SA3_2016_AUST.shp")

#line test data
mapData = TestData[,c("Latitude","Longitude","Speed","Route Num")]
mapData$group = TestData$`Route Num`

#data with only marker points
#to do: decide where the best places for markers - perhaps at each turn point?
mapData2 = mapData[seq(1, nrow(mapData), 100), ]

locPalette = colorFactor("YlOrRd", shapes$STE_NAME16)
RoutePalette = colorNumeric(c("white","yellow", "navy"), mapData$group)
#https://rstudio.github.io/leaflet/colors.html
#https://www.r-graph-gallery.com/183-choropleth-map-with-leaflet.html

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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  #Route Map with polylines for each route and markers
  #to do: make line clickables and show relevant data in a panel
  
  output$RouteMap <- renderLeaflet({
    m <- leaflet() %>%
      addTiles() %>%
      addPolylines(data = mapData, lng = ~Longitude, lat = ~Latitude, group = ~group, label = ~mytext2) %>%
      addMarkers(data = mapData2, lng= ~Longitude, lat= ~Latitude, popup = ~as.character(Speed), label = ~as.character(group)) %>%
      setView(lng=153.0251, lat=-27.4698, zoom=10)
    m
  })
  
  output$AltitudePlot <- renderPlot({
    ggplot(data=TestData[TestData$`Route Num` == 1,], aes(x=Time, y=Altitude)) + geom_line()
  })
  
  #Location map with boundary outlines and colours
  #To do:
  # - Setup colours and pop ups with relevant variables
  
#map the colours by AREASQKM16
  
  output$LocationMap <- renderLeaflet({
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
  })
  
})


