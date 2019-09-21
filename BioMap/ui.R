#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(maps)
library(ggplot2)
library(ggmap)
library(mapdata)
library(rsconnect)
library(tidyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("BioMap Australia"),
  
  # Sidebar with a slider input for number of bins 

  tabPanel("Tab 1" ,
           div(class="outer",
            sidebarLayout(
              sidebarPanel(
                sliderInput("bins",
                           "Number of bins:",
                           min = 1,
                           max = 50,
                           value = 30)
              ),
             
              # Show a plot of the generated distribution
              mainPanel(
                plotOutput("distPlot")
              )
            )
           )

  ),
  
  tabPanel("Tab 2" ,
           #map
           leafletOutput("mymap",height = 1000)

  ),
  
  conditionalPanel("false", icon("crosshair"))
)
)
