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

#DATA 
sampleRoute = read_csv("TestData.csv")

#longitude and latitude variables
#ns1:LatitudeDegrees
#ns1:LongitudeDegrees


shapes <- shapefile("../SA3_2016_AUST.shp")


# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
# states <- readOGR("SA3_2016_AUST.shp",
#                   layer = "cb_2013_us_state_20m", GDAL1_integer64_policy = TRUE)

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
                      InitialLat = c(TestData$ns1_LatitudeDegrees,TestData$ns1_LatitudeDegrees),
                      InitialLong = c(TestData$ns1_LongitudeDegrees,TestData$ns1_LongitudeDegrees),
                      NewLat = c(TestData$ns1_LatitudeDegrees,TestData$ns1_LatitudeDegrees),
                      NewLong = c(TestData$ns1_LongitudeDegrees,TestData$ns1_LongitudeDegrees),
                      stringsAsFactors = FALSE)

markers2 <- data.frame(group = c("A", "B"),
                       lat = c(markers$InitialLat, markers$InitialLat),#, markers$NewLat),
                       long = c(markers$InitialLong, markers$InitialLong)#, markers$NewLong)
)



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
      addMarkers(data = markers2, lng= ~long, lat= ~lat, popup = ~as.character(group), label = ~as.character(group)) %>%
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
      #addPolygons(data=shapes,weight=5,col = 'red') %>% 
      addPolylines(data = markers2, lng = ~long, lat = ~lat, group = ~group) %>%
      setView(lng=153.0251, lat=-27.4698, zoom=10) #%>%
    
    ma
  })
  
})


