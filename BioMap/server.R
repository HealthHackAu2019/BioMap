#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#deploy
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
library(sf)

###############
#DATA WRANGLING
###############

#to do:
#add markers as event

###############

mapData <- read_csv("ALLRoutes.csv")
shapes <- shapefile("SA3_2016_AUST.shp")
ColorData <- read_csv("RandomColourData.csv")

#line test data
mapData$group = mapData$Route

#data with only marker points
mapData2 = mapData[(mapData$Marker >= 1), ]

###############
#CREATE PALETTES
###############

#to do:
#figure out colour for route / polylines
#fix location colours
#https://gis.stackexchange.com/questions/292844/adding-color-to-polylines-in-leaflet-in-r 

###############

locPalette = colorFactor("Spectral", ColorData$AirQuality)
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
  "Location: ", shapes$SA3_NAME16,"<br/>", 
  "Area: ", shapes$AREASQKM16, "<br/>", 
  "Air Quality: ", ColorData$AirQuality, "<br/>", 
  sep="") %>%
  lapply(htmltools::HTML)

routeText <- paste(
  #"Route Number: ", mapData$Route,"<br/>", 
  "Speed: ", mapData$Speed, "<br/>", 
  "Heart Rate: ", mapData$HR, "<br/>", 
  sep="") %>%
  lapply(htmltools::HTML)

###############
#SERVER
###############


shinyServer(function(input, output) {

  #Plot Render
  ###############

  #line represents altitude
  output$AltitudePlot <- renderPlot({
    
    if (input$dropdown2 == "route1") {
      d = mapData[mapData$Route == 1,]
    } else if (input$dropdown2 == "route2"){
      d = mapData[mapData$Route == 2,]
    } else {
      d = mapData[mapData$Route == 2,]
    }
    
    ggplot(data=d, aes(x=Time, y=Altitude)) + geom_line()
    
  })
 
  
  #line represents Heart Rate
  output$HeartRatePlot <- renderPlot({
    
    if (input$dropdown2 == "route1") {
      d = mapData[mapData$Route == 1,]
    } else if (input$dropdown2 == "route2"){
      d = mapData[mapData$Route == 2,]
    } else {
      d = mapData[mapData$Route == 2,]
    }
    
    ggplot(data=d, aes(x=Time, y=HR)) + geom_line()
    
  })
  

  
  #Route Map
  ###############
  
  #polylines represent each group
  #markers represent key events
  #to do: make line clickables and show relevant data in a panel
  
  output$RouteMap <- renderLeaflet({
    if (input$dropdown2 == "route1") {
      mapData = mapData[mapData$Route == 1,]
      mapData2 = mapData2[mapData2$Route == 1,]
    } else if (input$dropdown2 == "route2"){
      mapData = mapData[mapData$Route == 2,]
      mapData2 = mapData2[mapData2$Route == 2,]
    } else if (input$dropdown2 == "route3"){
      mapData = mapData[mapData$Route == 3,]
      mapData2 = mapData2[mapData2$Route == 3,]
    }
    
    m <- leaflet() %>%
      addTiles() %>%
      addPolylines(data = mapData, lng = ~Longitude, lat = ~Latitude, group = ~group, label = ~routeText, color = "black") %>%
      addCircleMarkers(data = mapData2, lng= ~Longitude, lat= ~Latitude, popup = ~as.character(Story), 
                       label = ~routeText, radius = 5, fillColor = "red", color = "red"
                       
      ) %>%
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
    
    #if (input$dropdown == "airQual") {
      #mapData$Color = input$dropdown
    #}
  
    ma <- leaflet() %>%
      addTiles() %>%
      addPolygons(data=shapes,
                  fillColor = ~locPalette(ColorData$AirQuality),
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
  

  
  

})


