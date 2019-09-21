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

#DATA 
sampleRoute = read_csv("TestData.csv")

#longitude and latitude variables
#ns1:LatitudeDegrees
#ns1:LongitudeDegrees


# converting JSON to dataframe so that it can be used in the leaflet map
data2 <- fromJSON("../data.json")
data2 <- data2[!is.na(data2$`Low latitude (deg)`),]
data2 <- data2 %>%
  mutate(lat= `Low latitude (deg)`,
         long = `Low longitude (deg)`,
         group = `Date`)



sampleRoute$ns1_LatitudeDegrees

#line test data

markers <- data.frame(Observation = c("A", "B"),
                   InitialLat = c(sampleRoute$ns1_LatitudeDegrees[5],sampleRoute$ns1_LatitudeDegrees[433]),
                   InitialLong = c(sampleRoute$ns1_LongitudeDegrees[5],sampleRoute$ns1_LongitudeDegrees[433]),
                   NewLat = c(sampleRoute$ns1_LatitudeDegrees[5],sampleRoute$ns1_LatitudeDegrees[433]),
                   NewLong = c(sampleRoute$ns1_LongitudeDegrees[5],sampleRoute$ns1_LongitudeDegrees[433]),
                   stringsAsFactors = FALSE)

markers2 <- data.frame(group = c("A", "B"),
                    lat = c(markers$InitialLat, markers$NewLat),
                    long = c(markers$InitialLong, markers$NewLong))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })

  #base map
  output$RouteMap <- renderLeaflet({
    m <- leaflet() %>%
      addTiles() %>%
      addRectangles(
        lng1=152.000, lat1=-28.000,
        lng2=154.000, lat2=-27.000,
        fillColor = "transparent") %>%
      addPolylines(data = markers2, lng = ~long, lat = ~lat, group = ~group) %>%
      addMarkers(data = data2, lng= ~long, lat= ~lat, popup = ~as.character(group), label = ~as.character(group)) %>%
      setView(lng=153.0251, lat=-27.4698, zoom=10) #%>%

    m
  })
  
  #base map
  output$LocationMap <- renderLeaflet({
    ma <- leaflet() %>%
      addTiles() %>%
      addRectangles(
        lng1=152.000, lat1=-28.000,
        lng2=154.000, lat2=-27.000,
        fillColor = "transparent") %>%
      addPolylines(data = markers2, lng = ~long, lat = ~lat, group = ~group) %>%
      setView(lng=153.0251, lat=-27.4698, zoom=10) #%>%
    
    ma
  })
  
})


