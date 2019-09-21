# Rough go at map boundaries

library('ggmap')
library('rgdal')
library('rgeos')
library('maptools')
library('dplyr')
library('tidyr')
library('tmap')
library('leaflet')

# Load dbf file using readOGR`

setwd("C:/Users/Ashley/Documents/Git Repositories/BioMap/Data")
map <- readOGR(dsn = "data", layer = "MB_2016_QLD")
#plot(map)

saveRDS(object = map, file = "qldMap.Rds")

qldMap <- readRDS('qldMap.Rds')
leaflet() %>% addTiles() %>% addPolygons(data = qldMap)
