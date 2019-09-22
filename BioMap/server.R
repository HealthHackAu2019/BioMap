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
#to do: decide where the best places for markers - perhaps at each turn point?
mapData2 = mapData[seq(1, nrow(mapData), 100), ]

###############
#CREATE PALETTES
###############

#to do:
#figure out colour for route / polylines
#https://gis.stackexchange.com/questions/292844/adding-color-to-polylines-in-leaflet-in-r 

###############

locPalette = colorFactor(ColorData$RandomOne, ColorData$RandomOne)
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

###############
#SERVER
###############

shinyServer(function(input, output) {

  #Route Map
  ###############
  
  #polylines represent each group
  #markers represent key events
  #to do: make line clickables and show relevant data in a panel
  
  output$RouteMap <- renderLeaflet({
    m <- leaflet() %>%
      addTiles() %>%
      addPolylines(data = mapData, lng = ~Longitude, lat = ~Latitude, group = ~group, label = ~routeText) %>%
      addMarkers(data = mapData2, lng= ~Longitude, lat= ~Latitude, popup = ~as.character(Speed), label = ~routeText) %>%
      setView(lng=153.0251, lat=-27.4698, zoom=10)
    m
  })
  
  #Location Map
  ###############
  
  #polygons with boundary outlines 
  #polygon colors represent state
  #To do: Setup colours and pop ups with relevant variables
  #TO do: map the colours by AREASQKM16
  
  output$LocationMap <- renderLeaflet({
    ma <- leaflet() %>%
      addTiles() %>%
      addPolygons(data=shapes,
                  fillColor = ~ColorData$RandomOne,
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
                  label = locationText,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")) %>%
      setView(lng=153.0251, lat=-27.4698, zoom=10) #%>%
    ma
  })
  
  #Altitude Plot
  ###############
  
  #line represents altitude

  
  output$AltitudePlot <- renderPlot({
    ggplot(data=TestData[TestData$`Route Num` == 1,], aes(x=Time, y=Altitude)) + geom_line()
  })
  
  
})


