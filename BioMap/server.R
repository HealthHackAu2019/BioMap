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
  output$mymap <- renderLeaflet({
    m <- leaflet() %>%
      addTiles() %>%
      addRectangles(
        lng1=152.000, lat1=-28.000,
        lng2=154.000, lat2=-27.000,
        fillColor = "transparent") %>%
      setView(lng=153.0251, lat=-27.4698, zoom=10)
    m
  })

  
})
