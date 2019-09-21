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
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(title = "BioMap Australia"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Location Dashboard", tabName = "Location", icon = icon("dashboard")),
      menuItem("Data", tabName = "data", icon = icon("th"))

    )
  ),
  dashboardBody(
    tabItems(
      # first tab item
      tabItem(tabName = "dashboard",
        tabPanel("Tab 2" ,
                 #map
          leafletOutput("RouteMap",height = 1000)
      
        ),
        
        conditionalPanel("false", icon("crosshair"))
      ),
      # second tab item
      tabItem(tabName = "data",
              h2("Data that feeds Dashboard")
      ),
      
      #third tab item
      tabItem(tabName = "Location",
              tabPanel("Tab 3" ,
                       #map
                       leafletOutput("LocationMap",height = 1000)
        ),
              
              conditionalPanel("false", icon("crosshair"))
                       
      )
  )
)
)
