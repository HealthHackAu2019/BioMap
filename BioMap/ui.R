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

###############
#USER INTERFACE
###############

#UI guidance: https://rstudio.github.io/shinydashboard/structure.html#column-based-layout

###############

dashboardPage(
  dashboardHeader(title = "BioMap Australia"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Route Dashboard", tabName = "Route", icon = icon("dashboard")),
      menuItem("Location Dashboard", tabName = "Location", icon = icon("dashboard")),
      menuItem("Data", tabName = "data", icon = icon("th"))

    )
  ),
  dashboardBody(
    tabItems(
      # Route tab
      tabItem(tabName = "Route",
              fluidRow(
                plotOutput("AltitudePlot", height = 200),
                leafletOutput("RouteMap",height = 1000)
              ),

        conditionalPanel("false", icon("crosshair"))
      ),
      # Location tab
      tabItem(tabName = "Location",
              leafletOutput("LocationMap",height = 1000),
              conditionalPanel("false", icon("crosshair"))
      ),
              
      # Data tab
      tabItem(tabName = "data",
              h2("Data that feeds Dashboard")
      )
    )
  )
)
#)
